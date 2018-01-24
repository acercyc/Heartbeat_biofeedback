clc
clear all
close all
clear classes
instrreset

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
w.openTest();



%% visual stim
v = PsyOval(w);
v.size = [stim.v.size, stim.v.size];

%% auditory stim
beep = MakeBeep(stim.a.freq, stim.a.duration, stim.a.fs);
a = PsySound();
a.soundArray = beep;
a.open();
a.bufferLoading();


%% Message
txt = PsyText(w);
txt_prompt = PsyText_Prompt(w);

%% Response



%% Start Experiment
% ============================================================================ %
%                                    Welcome                                   %
% ============================================================================ %
txt_prompt.playWelcome_and_prompt();

% ============================================================================ %
%                                  Calibration                                 %
% ============================================================================ %
heart = Heart();
heart.open();
hr_mean = Calibration(w, heart);



for iTrial = 1:10
    cPulse = 1;
    tNextHist = NaN(1, design.nPulseInTrial);
    
    if data(iTrial).isSync
        offset = 0;
    else
        offset = design.asyncOffset;
    end
    
    while cPulse <= design.nPulseInTrial

        tNext = heart.nextPulse();
        tNextHist = tNextHist_update(tNext, tNextHist, para.pred.tMinimal);

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
        while GetSecs() < (tNextHist(cPulse) + offset)
            tNext = heart.nextPulse();
            tNextHist = tNextHist_update(tNext, tNextHist, para.pred.tMinimal);        
        end


        % ---------------------- wait to visual stim disappear  ---------------------- %

        if isV
            while GetSecs() < (tNextHist(cPulse) + stim.v.duration + offset)
                tNext = heart.nextPulse();
                tNextHist = tNextHist_update(tNext, tNextHist, para.pred.tMinimal);             
            end
            v.flip();
        end


        % ---------------------- wait to auditory stim disappear --------------------- %
        if isA
            while GetSecs() < (tNextHist(cPulse) + stim.a.duration + offset)
                tNext = heart.nextPulse();
                tNextHist = tNextHist_update(tNext, tNextHist, para.pred.tMinimal);             
            end    
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

    if data(iTrial).acc
        txt.text = 'correct';
    else
        txt.text = 'wrong';
    end
    txt.play();
    
    WaitSecs(1);
    % ============================================================================ %
    %                            Response to next trial                            %
    % ============================================================================ %
    
    txt.draw();
    txt.text = sprintf('\n\n\n\n\nPress %s key to the next trial', resp.keyNextTrial);
    txt.play();
    RestrictKeysForKbCheck(KbName(resp.keyNextTrial));  
    while ~KbCheck()
    end
    

end






