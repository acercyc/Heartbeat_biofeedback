function para = parameters()
% 1.0 - Acer 2018/01/29 12:25


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
para.stim.v.duration = 0.2;  % duration of visual stimuli in seconds

% auditory
para.stim.a.freq     = 1000;   % the frequency of auditory tone
para.stim.a.duration = 0.2;    % duration of auditory stimulus
para.stim.a.fs       = 44100;  % the playback frequency of auditory stimulus

% intertrial central stimulus 
para.fix.tJitter = [1, 2];  % random interval between trial [min, max] (in second)

% Response
para.resp.keySync      = 'LeftArrow';   % response key based on KbName in Psychtoolbox
para.resp.keyAsync     = 'RightArrow';  % response key based on KbName in Psychtoolbox
para.resp.keyNextTrial = 'space';       % response key based on KbName in Psychtoolbox


% ============================================================================ %
%                                  Calibration                                 %
% ============================================================================ %
para.calibration.sampleTime = 30;   % duration to sample HR in Calibration stage (in second)
para.calibration.keyQuit    = 'q';  % key to quit Calibration mode
para.calibration.keyStart   = 's';  % key to start HR sampling

% ------------------------ Good signal check parameter ----------------------- %
para.calibration.variationThreshold         = 0.1;   
para.calibration.rangeRateThreshold         = 0.87;  
para.calibration.nStableWaveSampleCriterium = 7;     % n stable sample to wait for enter next stage



% ============================================================================ %
%                                  Equipment                                   %
% ============================================================================ %
% ---------------------------------- device ---------------------------------- %
para.device.monitorID      = 0;   % presentation monitor ID
para.device.testWindowSize = [];  % if not empty, open a testing window
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
para.log.trial.HR = NaN;
para.log.trial.isSync = NaN;
para.log.trial.resp = NaN;
para.log.trial.acc = NaN;
para.log.trial.RT = NaN;

