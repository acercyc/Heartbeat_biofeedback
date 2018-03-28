function para = parameters()
% 1.0 - Acer 2018/01/29 12:25
% 1.1 - Acer 2018/03/27 17:48


% ============================================================================ %
%                                     Task                                     %
% ============================================================================ %

% ------------------------------ expeirment mode ----------------------------- %
% para.design.isFeedbackShow
%     1: Show feedback
%     0: no feedback 
% 
% para.design.nTrialToCheckHR
%     Determine after how many trials to check whether the heart rate now is higher than baseline heart rate
% 
% para.design.startExpWithHighHR
%     Determine whether to start experiment with a higher-than-resting heart rate

para.design.isFeedbackShow     = 1;  
para.design.nTrialToCheckHR    = 1;  
para.design.startExpWithHighHR = 1;  

para.design.HRchangeRate    = 1.1;   % the HR threshold to continue experiment
para.design.nPulseInTrial   = 10;    % num of heartbeat pulse presented in a trial
para.design.nTrialInBlock   = 20;    % num of trial in a experimental block
para.design.nBlockInSession = 4;     % num of block in a whole session
para.design.modality        = 'AV';  % 'A', 'V', or 'AV' (A: auditory, V: visual stimulus)
para.design.asyncOffset     = 0.5;   % asyncrony trial heartbeat time shift (in second)
para.design.asyncTrialRate  = 0.5;   % ration of asyncrony trials in all trials


% ---------------------------------- Stimuli --------------------------------- %
% visual 
para.stim.v.size     = 50;   % size of visual stimulus (in pixel)
para.stim.v.duration = 0.15;  % duration of visual stimuli in seconds

% auditory
para.stim.a.freq     = 1000;   % the frequency of auditory tone
para.stim.a.duration = 0.15;    % duration of auditory stimulus
para.stim.a.fs       = 44100;  % the playback frequency of auditory stimulus
para.stim.a.fadeTime = 0.04;

% intertrial central stimulus 
para.fix.tJitter = [1, 2];  % random interval between trial [min, max] (in second)

% Response
para.resp.keySync      = 'LeftArrow';   % response key based on KbName in Psychtoolbox
para.resp.keyAsync     = 'RightArrow';  % response key based on KbName in Psychtoolbox
para.resp.keyNextTrial = 'space';       % response key based on KbName in Psychtoolbox


% ============================================================================ %
%                                   Messages                                   %
% ============================================================================ %
% Notice that, \n represent "new line" 
% Caution!!! %s, %f determine presented values of variables. Don't delete them. 

para.msg.Welcome = 'Welcome to this experiment\n\nPress SPACE to start';

para.msg.RestingCalibrationStart = '--- Resting State Calibration ---\n\n\nPress Space to Continue';
para.msg.ExpStart = 'Experiment Start\n\nPress Space to Continue';
para.msg.WaitStableSignal = 'Wait for heartbeat signal stabilized...';
para.msg.RespChoice = 'Sync  or  Async';
para.msg.FeedbackCorrect = 'correct';
para.msg.FeedbackWrong = 'wrong';
para.msg.RespToNextTrial = '\n\n\n\n\nPress %s key to continue';
para.msg.EndOfExp = ['The end of this session\n\n',...
                     'Your accuracy is %.1f%%, and response time is %.1fms',...
                     '\n\n\nPress space to end the program'];

% -------------------------------- Calibration ------------------------------- %
para.msg.CaliStartScreen = ['Calibration mode\n\n\n', ...
                            's: Start estimate heart rate\n\n', ...
                            'q: Quit calibration mode', ...
                            '\n\n\n'];                 
para.msg.CaliEstimating = ['Estimate...\t%.1fs/%gs',...
                           '\n\n\n',...
                           'Press Q to interrupt'];

para.msg.CaliChoice = ['w: Go back to welcome screen\n\n', ...
                       's: Start estimate heart rate again\n\n', ...
                       'q: Quit calibration mode'];
                    
para.msg.CaliResult = 'Average Heart Rate = %.1f\n\n\n';

% --------------------------------- Exercise --------------------------------- %
para.msg.ExciDoIt = ['Do Exercise and Rise Your Heart Rate\n\n'...
                     'Press Space to Measure Heart Rate After Exercise'];
para.msg.ExciWait = 'Wait for heartbeat signal stabilized...';
para.msg.ExciPass = ['Your heart rate is %.1f, ',...
                     'and %.1f%% of your resting heart rate.\n\n', ...
                     'Well done\n\n\n',...
                     'Press Space to continue'];
para.msg.ExciNoPass = ['Your heart rate is %.1f,'...
                       'and %.1f%% of your resting heart rate.\n\n', ...
                       'Please do exercise and try again\n\n\n',...
                       'Press Space to continue\n\n',...
                       '(Or press Q to skip)'];                 
                 
% ============================================================================ %
%                                  Calibration                                 %
% ============================================================================ %
para.calibration.sampleTime = 30;   % duration to sample HR in Calibration stage (in second)
para.calibration.keyQuit    = 'q';  % key to quit Calibration mode
para.calibration.keyStart   = 's';  % key to start HR sampling

% ------------------------ Good signal check parameter ----------------------- %
para.calibration.variationThreshold         = 0.07;   
para.calibration.rangeRateThreshold         = 0.87;  
para.calibration.nStableWaveSampleCriterium = 7;     % n stable sample to wait for enter next stage



% ============================================================================ %
%                                  Equipment                                   %
% ============================================================================ %
% ---------------------------------- device ---------------------------------- %
para.device.monitorID      = 0;   % presentation monitor ID
para.device.testWindowSize = [];  % [0, 0, 500, 500];  % if not empty, open a testing window
para.device.fs             = 75;  % in HZ

% -------------------------------- serial port ------------------------------- %
para.serial.nByteInBlock = 5;       % num of Bytes in Xpod serial port protocal
para.serial.COM          = 'COM3';  
para.serial.BaudRate     = 9600;    

% ------------------------------- reading data ------------------------------- %
para.read.nByteToReadFromBF = 75;                                  % num of bytes to read from serial port buffer
para.read.nDataHistoryBF    = 75 * 10 * para.serial.nByteInBlock;  % num of recent byte to keep in data buffer


% ---------------------------- heartbeat detection --------------------------- %
para.detect.windowSize = 5;     % window size to compute heartbeat information in some testing scripts



% --------------------------- heartbeat prediction --------------------------- %
para.pred.tMinimal        = 0.3;  % minimal duration between heartbeat (in second)
para.pred.tMinimalHrRatio = 0.7;  % minimal heartbear interval based on the ration of current heartbeat estimatoin



% ============================================================================ %
%                                      Log                                     %
% ============================================================================ %
para.log.datapath = 'data';
para.log.trial.hr_rest = NaN;
para.log.trial.iTrial = NaN;
para.log.trial.nPulseTotalTime = NaN;
para.log.trial.nPulseAverageHR = NaN;
% para.log.trial.HR = NaN;
para.log.trial.isSync = NaN;
para.log.trial.resp = NaN;
para.log.trial.acc = NaN;
para.log.trial.RT = NaN;

