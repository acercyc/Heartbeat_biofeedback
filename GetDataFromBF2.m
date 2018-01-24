function GetDataFromBF2(obj, event)
% 1.0 - Acer 2018/01/18 17:19
% this one keep recent n sample in a fixed size data buffer 
% n = para.read.nDataHistoryBF

para = parameters();



%% Read from buffer
stream = fread(obj, para.read.nByteToReadFromBF);
t = GetSecs();
fprintf('%f\n', GetSecs());


if length(stream) < para.read.nByteToReadFromBF
    return
end



%% post processing 
stream = [obj.UserData.tail; stream];
[body, ~, suffix] = StreamSplit(stream, para.serial.nByteInBlock);
data = ParsingBlock(body, para.serial.nByteInBlock);

% ------------------------------- indexing time ------------------------------ %

if isempty(obj.UserData.tLast)  % if this is the first recording stream
    ts = t - (0:length(data)-1) * 1/para.device.fs;
    ts = fliplr(ts);
else
    ts = linspace(obj.UserData.tLast, t, length(data));
    ts = ts(1:end);
end

for i = 1:length(data)
    data(i).time = ts(i);
end

% --------------------------------- save data -------------------------------- %
dNew = [obj.UserData.data, data];
if length(dNew) > para.read.nDataHistoryBF
    dNew = dNew(end-para.read.nDataHistoryBF+1:end);
end

obj.UserData.data = dNew;
obj.UserData.tail = suffix;
obj.UserData.tLast = t;



%% 

% display(obj.BytesAvailable)

% display(obj)
% display(event)