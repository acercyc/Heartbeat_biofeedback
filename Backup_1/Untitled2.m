%%

addpath(genpath('lib'))
para = parameters();


%%
fclose(s)
delete(s)
clear s

%%
s = serial('COM3', 'BaudRate', 9600);

s.BytesAvailableFcn = @GetDataFromBF;
s.BytesAvailableFcnCount = para.read.nByteToReadFromBF;
s.BytesAvailableFcnMode = 'byte';

% UserData.t = [];
% UserData.stream = [];
UserData.data = [];
UserData.tail = [];

s.UserData = UserData;


%%
fopen(s);
% out = fread(s, 512);


% fclose(s)
% delete(s)
% clear s


%%
wSize = para.detect.windowSize;

figure()
while 1
    d = getDataByWindow(s, wSize, 1);
    if ~isempty(d)
        dd = [d.Pleth];
        tt = GetSecs() - [d.time];
        plot(tt, dd)
    end
    pause(0.1)
end

%%
% ecg_ecglab_detect(dd, 75, 2)
beat_idx = ecg_beat_detect(dd, 75, 0.1, 0, 0.1)


figure()
% [pks,locs] = findpeaks(dd, [], 20)
plot(tt, dd)
hold on
plot(tt(beat_idx), dd(beat_idx), 'o')

 
%%
[ qrs, sqi ] = detect_matlab(dd', {'wtf'}, 75)
%%
[xNew, tNew] = resample(dd, t, 250)
peakdetect(xNew, 250, 7)

%%
[xNew, tNew] = resample(dd, t, 200)
plot(tNew, xNew)
hold on
plot(t, dd+1)
%%
% ECG_w.ECGtaskHandle = 'QRS_detection';
ECGt_QRSd = ECGtask_QRS_detection();
ECGt_QRSd.detectors = 'wavedet'; % Wavedet algorithm based on
% ECGt_QRSd.detectors = 'pantom';  % Pan-Tompkins alg.
% ECGt_QRSd.detectors = 'gqrs';    % WFDB gqrs algorithm.
% ECG_w.ECGtaskHandle= ECGt_QRSd; % set the ECG task

ECG_w = ECGwrapper('ECGtaskHandle', ECGt_QRSd)
ECG_w.Run();

%% detectEcgWithAngle
rPeakIds = detectEcgWithAngle(dd', 75, [], [], 1)

%% pan_tompkin


[qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(dd-50, 200, 1)


%%
[avgHR,meanRR,rmssd,nn50,pNN50,sd_RR,sd_HR,se,pse,average_hrv,hrv]= getECGFeatures(dd)


%% this is better
figure()
[pks,locs] = findpeaks(dd, [], 20)
plot(tt, dd)
hold on
plot(tt(locs), pks, 'o')


%%

autocorr(dd, 100)

%%
while 1
    d = s.UserData.data;
    if ~isempty(d)
        dd = [d.Pleth];
        tt = GetSecs() - [d.time];
        plot(tt, dd)

        s.UserData.data = [];
    end
    pause(0.1)
end


%%
figure()
plot(diff(tt))

%%
while 1
    out = fread(s, 512);
    sum(out==1)
    s
end


%%
nByteInBlock = 5;

% split stream
[out, prefix, suffix] = StreamSplit(out, para.serial.nByteInBlock);

% parsing data
data = parsing(out, nByteInBlock)


%%

while 1
    try
    if s.BytesAvailable == 512
        out = fread(s, 512);
        
        % split stream
        [out, prefix, suffix] = StreamSplit(out, nByteInBlock);

        % parsing data
        data = parsing(out, nByteInBlock)


        d = [data.Pleth];
        plot(d)
    end
    pause(0.1)
    catch
    end
    
end

%%

while 1
%     out = fread(s, 512);
    readasync(s)
    out = fread(s, 512);
    s.BytesAvailable
end

%%
a = fscanf(s)
a = int8(a)


%%
% readasync(s)
s.ReadAsyncMode = 'continuous'
out = fread(s, 512);




