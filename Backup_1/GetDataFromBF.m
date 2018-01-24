function GetDataFromBF(obj, event)
% 1.0 - Acer 2018/01/18 17:19
para = parameters();


% if obj.BytesAvailable < para.read.nByteToReadFromBF
%     return
% end


%% Read from buffer
stream = fread(obj, para.read.nByteToReadFromBF);
t = GetSecs();

% obj.UserData.t = [obj.UserData.t t];
% obj.UserData.stream = [obj.UserData.stream stream];


%% post processing 
stream = [obj.UserData.tail; stream];
[body, prefix, suffix] = StreamSplit(stream, para.serial.nByteInBlock);
data = ParsingBlock([prefix; body], para.serial.nByteInBlock);

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
obj.UserData.data = [obj.UserData.data, data];
obj.UserData.tail = suffix;
obj.UserData.tLast = t;



%% 

% display(obj.BytesAvailable)

% display(obj)
% display(event)