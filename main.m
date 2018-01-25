clc
clear all
close all
instrreset
clear classes


addpath(genpath('lib'));

%% Load parameters
para = parameters;
design = para.design; 
stim = para.stim;
resp = para.resp;

%% Logging subject info



%% Design
nTrial = design.nBlockInSession * design.nTrialInBlock;


% determine trial type
isSync = [];
for iBlock = 1:design.nBlockInSession
    isSync = [isSync; genRandBlock(design.nTrialInBlock, design.asyncTrialRate)];
end


% create log data structure
data = para.log.trial;
for iTrial = 1:nTrial
    data(iTrial) = para.log.trial;
    data(iTrial).isSync = isSync(iTrial);
end

% modality
isA = contains(design.modality, 'A');
isV = contains(design.modality, 'V');


%% Initialise 
init = PsyInitialize();

w = PsyScreen(1);
w.openTest([1, 1, 600, 600]);



%% visual stim
v = PsyOval(w);
v.size = [stim.v.size, stim.v.size];

%% auditory stim
beep = MakeBeep(stim.a.freq, stim.a.duration, stim.a.fs);
a = PsySound();
a.soundArray = beep;
a.open();
a.bufferLoading();


%% fixation 
fix = PsyCross(w);

%% Message
txt = PsyText(w);
txt_prompt = PsyText_Prompt(w);

%% Response

%% Heart obj
heart = Heart();
heart.open();

%% Start Experiment
% ============================================================================ %
%                                    Welcome                                   %
% ============================================================================ %
txt_prompt.playWelcome_and_prompt();


% ============================================================================ %
%                                  Calibration                                 %
% ============================================================================ %   
txt_prompt.text = 'Resting State Calibration\n\nPress Space to Continue';
txt_prompt.allowKey = 'space';
txt_prompt.playTextAndWaitForKey();
hr_rest = Calibration(w, heart);


% ============================================================================ %
%                          Experiment Start Press key                          %
% ============================================================================ %
txt_prompt.text = 'Experiment Start\n\nPress Space to Continue';
txt_prompt.allowKey = 'space';
txt_prompt.playTextAndWaitForKey();
WaitSecs(1);



%%
for iTrial = 1:10
    cPulse = 1;
    tNextHist = NaN(1, design.nPulseInTrial);
    
    if data(iTrial).isSync
        offset = 0;
    else
        offset = design.asyncOffset;
    end
    
    % ============================================================================ %
    %                           Wait for stable heartbeat                          %
    % ============================================================================ %
    txt_prompt.text = 'Wait for heartbeat stabilized...';
    txt_prompt.play();
    WaitStableWave(heart, para);
    
    % ============================================================================ %
    %                                   fixation                                   %
    % ============================================================================ %
    z = randRange(para.fix.tJitter);
    fix.play();
    WaitSecs(z);
    
    
    % **************************************************************************** %
    %                              Pulse presentation                              %
    % **************************************************************************** %
    while cPulse <= design.nPulseInTrial

        [hr, sd, tNext, amp, t, peakInd] = heart.cal_info();
        tNextHist = tNextHist_update_byRatio(tNext, tNextHist, hr, para.pred.tMinimalHrRatio);


        % --------------------------------- Schedule --------------------------------- %
        % V
        if isV
            v.draw();
            v.flipAtTime(tNextHist(cPulse) + offset, 1);
        end


        % A
        if isA
            a.playAtTime(tNextHist(cPulse) + offset);
        end


        % ---------------------------- Wait to next pulse  --------------------------- %
        tNextHist = WaitAndUpdateUntil(tNextHist(cPulse) + offset, heart, ...
            tNextHist, para);


        % ---------------------- wait to visual stim disappear  ---------------------- %

        if isV
            tNextHist = WaitAndUpdateUntil(tNextHist(cPulse) + stim.v.duration + offset, heart,...
                tNextHist, para);
            v.flip();
        end


        % ---------------------- wait to auditory stim disappear --------------------- %
        if isA
            tNextHist = WaitAndUpdateUntil(tNextHist(cPulse) + stim.a.duration + offset, heart, ...
                tNextHist, para);            
            a.stop();
        end

        cPulse = cPulse + 1;
    end
    
    
    % ============================================================================ %
    %                                   Response                                   %
    % ============================================================================ %
    txt.text = 'Sync  or  Async';
    txt.play();
    enablekeys = [KbName(resp.keySync) KbName(resp.keyAsync)];
    RestrictKeysForKbCheck(enablekeys);
    while 1
        GetMouse();
        [keyIsDown,secs, keyCode] = KbCheck();
        if keyIsDown
            data(iTrial).resp = KbName(keyCode);
            break
        end
    end
    
     
    % ============================================================================ %
    %                                   Feedback                                   %
    % ============================================================================ %
    ansIsSync = strcmp(data(iTrial).resp, resp.keySync);
    data(iTrial).acc = ansIsSync == data(iTrial).isSync;

    
    if design.isFeedbackShow
        if data(iTrial).acc
            txt.text = 'correct';
        else
            txt.text = 'wrong';
        end
        txt.play();
        WaitSecs(1);
    end
    

    % ============================================================================ %
    %                            Response to next trial                            %
    % ============================================================================ %
    
    txt.draw();
    txt.text = sprintf('\n\n\n\n\nPress %s key to continue', resp.keyNextTrial);
    txt.play();
    RestrictKeysForKbCheck(KbName(resp.keyNextTrial));  
    while ~KbCheck()
        GetMouse();
    end
    
    
    % ============================================================================ %
    %                                Mode selection                                %
    % ============================================================================ %
%     switch design    .
    

end






