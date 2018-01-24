function dataStruct = BlockStruct(n)

% Byte 2
data.Disconnect = NaN;
data.Artifact = NaN;
data.OutOfTrack = NaN;
data.SensorAlarm = NaN;
data.RedPerfusion = NaN;
data.YellowPerfusion = NaN;
data.GreenPerfusion = NaN;
data.FrameSync = NaN;

% Byte 3
data.Pleth = NaN;

% Byte 4
data.WTFisThis = NaN;

% ----------------------------- Repeat structure ----------------------------- %
dataStruct = repmat(data, 1, n);


