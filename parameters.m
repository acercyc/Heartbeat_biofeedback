function para = parameters()


% ============================================================================ %
%                                     Task                                     %
% ============================================================================ %

% ------------------------------ expeirment mode ----------------------------- %
para.design.isFeedbackShow = 1;
para.design.nTrialToCheckHR = 1;
para.design.startExpWithHighHR = 1;

para.design.HRchangeRate = 1.1;
para.design.nPulseInTrial = 10;
para.design.nTrialInBlock = 20;
para.design.nBlockInSession = 4;
para.design.modality = 'AV';    % 'A', 'V', or 'AV'
para.design.asyncOffset = 0.5;    % in second
para.design.asyncTrialRate = 0.5;


% ---------------------------------- Stimuli --------------------------------- %
% visual 
para.stim.v.size = 50;  % in pixel
para.stim.v.duration = 0.2;  % in seconds

% auditory
para.stim.a.freq = 1000;
para.stim.a.duration = 0.2;
para.stim.a.fs = 44100;

% intertrial central stimulus 
para.fix.tJitter = [1, 2];

% Response
para.resp.keySync = 'LeftArrow';
para.resp.keyAsync = 'RightArrow';
para.resp.keyNextTrial = 'space';




% ============================================================================ %
%                                  Calibration                                 %
% ============================================================================ %
para.calibration.sampleTime = 10;   % in second
para.calibration.variationThreshold = 0.1;
para.calibration.rangeRateThreshold = 0.87;
para.calibration.nStableWaveSampleCriterium = 7;
para.calibration.keyQuit = 'q';
para.calibration.keyStart = 's';


% ============================================================================ %
%                                  Equipment                                   %
% ============================================================================ %
% ---------------------------------- device ---------------------------------- %
para.device.fs = 75;
para.device.monitorID = 1;
para.device.testWindowSize = [];

% -------------------------------- serial port ------------------------------- %
para.serial.nByteInBlock = 5;
para.serial.COM = 'COM3';
para.serial.BaudRate = 9600;


% ------------------------------- reading data ------------------------------- %
para.read.nByteToReadFromBF = 75;
para.read.nDataHistoryBF = 75 * 10 * para.serial.nByteInBlock; % n recent byte to keep


% ---------------------------- heartbeat detection --------------------------- %
para.detect.windowSize = 5;



% --------------------------- heartbeat prediction --------------------------- %
para.pred.tMinimal = 0.3;
para.pred.tMinimalHrRatio = 0.7;



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

