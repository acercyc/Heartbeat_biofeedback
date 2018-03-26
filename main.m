function main()
% 1.0 - Acer 2018/01/26 15:08
addpath(genpath('lib'));
commandwindow();
clc
clear all
close all
instrreset
clear classes




%% Load parameters
para = parameters();
design = para.design; 
stim = para.stim;
resp = para.resp;
msg = para.msg;

%% Logging 
% --------- subject info GUI --------- %
s = SubjInfObj();
s.addField('Session');
s.Session = '0';
s.gui();


% ------------- Pathname ------------ %
datapath  = para.log.datapath;
if ~exist(datapath, 'dir')
    mkdir(datapath);
end  
datapath_mat = fullfile(datapath, sprintf('%s_%s.mat', s.SubjectID, s.Session));
datapath_CSV = fullfile(datapath, sprintf('%s_%s.csv', s.SubjectID , s.Session));


%% Design
nTrial = design.nBlockInSession * design.nTrialInBlock;

% determine trial type
isSync = [];
for iBlock = 1:design.nBlockInSession
    isSync = [isSync; genRandBlock(design.nTrialInBlock, design.asyncTrialRate)];
end


% create log data structure
expStartTime = datestr(now);
dataStruct = catstruct(s.makeStructure, para.log.trial);
data = repmat(dataStruct, 1, nTrial);
for iTrial = 1:nTrial
    data(iTrial).iTrial = iTrial;
    data(iTrial).isSync = isSync(iTrial);
    data(iTrial).expStartTime = expStartTime;
    data(iTrial).modality = design.modality;
end

% modality
isA = ~isempty(strfind(design.modality, 'A'));
isV = ~isempty(strfind(design.modality, 'V'));


%% Initialise 
init = PsyInitialize();
init.SuppressAllWarnings = 1;
init.SkipSyncTests = 1;
Screen('Preference','VisualDebugLevel', 0);

w = PsyScreen(para.device.monitorID);

if isempty(para.device.testWindowSize)
    w.open();
else
    w.openTest(para.device.testWindowSize);
end



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


%% Heart obj
heart = Heart();
heart.open();

%% Start Experiment
% ============================================================================ %
%                                    Welcome                                   %
% ============================================================================ %
txt_prompt.text = msg.Welcome;
txt_prompt.allowKey = 'space';
txt_prompt.playTextAndWaitForKey();

% ============================================================================ %
%                                  Calibration                                 %
% ============================================================================ %   
txt_prompt.text = msg.RestingCalibrationStart;
txt_prompt.allowKey = 'space';
txt_prompt.playTextAndWaitForKey();
hr_rest = Calibration(w, heart);



% ============================================================================ %
%                         Start Experiment with high HR                        %
% ============================================================================ %
if design.startExpWithHighHR
    DoExerciseAndCheck(w, heart, hr_rest);    
end



% ============================================================================ %
%                          Experiment Start Press key                          %
% ============================================================================ %
txt_prompt.text = msg.ExpStart;
txt_prompt.allowKey = 'space';
txt_prompt.playTextAndWaitForKey();
WaitSecs(1);


% ============================================================================ %
%                                  Trial Loop                                  %
% ============================================================================ %
for iTrial = 1:nTrial
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
    txt_prompt.text = para.msg.WaitStableSignal;
    txt_prompt.play();
    WaitStableWave(heart, para, w);
    
    % ============================================================================ %
    %                                   fixation                                   %
    % ============================================================================ %
    z = randRange(para.fix.tJitter);
    txt.text = sprintf('Trial %d', iTrial);
    txt.play();
    
    WaitSecs(z);
    
    
    % ============================================================================ %
    %                          Predictive function warmup                          %
    % ============================================================================ %
    nWarmup = 3;
    warmupHist = NaN(1, nWarmup);
    [~, ~, tNext, ~, ~, ~] = heart.cal_info();
    warmupHist(1) = tNext;
    while sum(~isnan(warmupHist)) == 0
        [hr, ~, tNext, ~, ~, ~] = heart.cal_info();
        warmupHist = tNextHist_update_byRatio(tNext, warmupHist, hr, para.pred.tMinimalHrRatio);
    end
    tNextHist(1) = tNext;
    
    % **************************************************************************** %
    %                              Pulse presentation                              %
    % **************************************************************************** %
    tt0 = GetSecs(); % test
    
    while cPulse <= design.nPulseInTrial
%         tNextHist_nLast = sum(~isnan(tNextHist));
        
        if cPulse ~= 1
            [hr, ~, tNext, ~, ~, ~] = heart.cal_info();        
            tNextHist = tNextHist_update_byRatio(tNext, tNextHist, hr, para.pred.tMinimalHrRatio);
        end
        
        
        if isnan(tNextHist(cPulse))
            continue
        end
        
%         if tNextHist_nLast == sum(~isnan(tNextHist))
%             continue
%         end
        
        % test
%         fprintf('next: %.5f', tNextHist);

        % test
%         heart.plot2();
%         drawnow();
        % test 
        
        offset
        tNext - tt0
        diff(tNextHist)
        % test end


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
            tNextHist = WaitAndUpdateUntil(tNextHist(cPulse) + stim.a.duration + offset + 0.05, heart, ...
                tNextHist, para);            
            a.stop();
        end

        cPulse = cPulse + 1;
    end
    
    
    % ============================================================================ %
    %                                   Response                                   %
    % ============================================================================ %
    txt.text = msg.RespChoice;
    txt.play();
    tResp = GetSecs();
    
    enablekeys = [KbName(resp.keySync) KbName(resp.keyAsync)];
    RestrictKeysForKbCheck(enablekeys);
    while 1
        GetMouse();
        [keyIsDown, secs, keyCode] = KbCheck();
        if keyIsDown
            data(iTrial).resp = KbName(keyCode);
            break
        end
    end
    data(iTrial).RT = secs - tResp;
     
    % ============================================================================ %
    %                                   Feedback                                   %
    % ============================================================================ %
    data(iTrial).resp_isSync = strcmp(data(iTrial).resp, resp.keySync);
    data(iTrial).acc = data(iTrial).resp_isSync == data(iTrial).isSync;

    
    if design.isFeedbackShow
        if data(iTrial).acc
            txt.text = msg.FeedbackCorrect;
        else
            txt.text = msg.FeedbackWrong;
        end
        txt.play();
        WaitSecs(1);
    end
    

    % ============================================================================ %
    %                            Response to next trial                            %
    % ============================================================================ %
    
    txt.draw();
    txt.text = sprintf(msg.RespToNextTrial, resp.keyNextTrial);
    txt.play();
    RestrictKeysForKbCheck(KbName(resp.keyNextTrial));  
    while ~KbCheck()
        GetMouse();
    end
    RestrictKeysForKbCheck([]);
     
    
    % ============================================================================ %
    %                                   Check HR                                   %
    % ============================================================================ %
    if (iTrial ~= nTrial) && (mod(iTrial, design.nTrialToCheckHR) == 0)
        [hr, ~, ~, ~, ~, ~] = heart.cal_info();
        if hr/hr_rest < design.HRchangeRate
            DoExerciseAndCheck(w, heart, hr_rest);
        end
    end
    
    
    % ============================================================================ %
    %                                 Data logging                                 %
    % ============================================================================ %
    data(iTrial).hr_rest = hr_rest;
    data(iTrial).nPulseTotalTime = tNextHist(end) - tNextHist(1);
    data(iTrial).nPulseAverageHR = data(iTrial).nPulseTotalTime / length(tNextHist);
    
    % Save to file
    Struct2File(datapath_CSV, data);
    save(datapath_mat, 'data', 'para');
end


% **************************************************************************** %
%                               Finish Experiment                              %
% **************************************************************************** %
session_acc = mean([data(iTrial).acc]);
session_RT = mean([data(iTrial).RT]);
str_final = sprintf(msg.EndOfExp, session_acc*100, session_RT*1000);
txt_prompt.text = str_final;
txt_prompt.allowKey = 'space';
txt_prompt.playTextAndWaitForKey();




