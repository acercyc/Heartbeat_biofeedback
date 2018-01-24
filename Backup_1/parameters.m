function para = parameters()

% ---------------------------------- device ---------------------------------- %
para.device.fs = 75;

% -------------------------------- serial port ------------------------------- %
para.serial.nByteInBlock = 5;


% ------------------------------- reading data ------------------------------- %
para.read.nByteToReadFromBF = 100;
para.read.nDataHistoryBF = 75 * 10; % n recent samples to keep


% ---------------------------- heartbeat detection --------------------------- %
para.detect.windowSize = 5;


% --------------------------- heartbeat prediction --------------------------- %
para.pred.tMinimal = 0.3;


% ============================================================================ %
%                                  Calibration                                 %
% ============================================================================ %
para.calibration.keyQuit = 'q';



% ============================================================================ %
%                                     Task                                     %
% ============================================================================ %

para.design.HRchangeRate = 1.1;
para.design.nTrialInBlock = 20;
para.design.nBlockInSession = 4;
para.design.modality = 'AV';    % 'A', 'V', or 'AV'
para.design.nPulseInTrial = 10;
para.design.asyncOffset = 0.5;    % in second
para.design.asyncTrialRate = 0.5;
para.design.isFeedbackShow = 1;

para.stim.v.size = 50;  % in pixel
para.stim.v.duration = 0.2;  % in seconds

para.stim.a.freq = 1000;
para.stim.a.duration = 0.2;
para.stim.a.fs = 44100;

para.resp.keySync = 'LeftArrow';
para.resp.keyAsync = 'RightArrow';
para.resp.keyNextTrial = 'DownArrow';

para.log.calibrationHR = NaN;
para.log.trial.session = NaN;
para.log.trial.trial = NaN;
para.log.trial.totalTime = NaN;
para.log.trial.HR = NaN;
para.log.trial.isSync = NaN;
para.log.trial.resp = NaN;
para.log.trial.acc = NaN;
para.log.trial.RT = NaN;

