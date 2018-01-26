function GetDataFromBF(obj, event)
% 1.0 - Acer 2018/01/18 17:19
para = parameters();


% if obj.BytesAvailable < para.read.nByteToReadFromBF
%     return
% end


%% Read from buffer
stream = fread(obj, para.read.nByteToReadFromBF);
% fprintf('%d\n', length(stream));
obj.UserData.lastRequestTime = GetSecs();

stream = [obj.UserData.data; stream];

if length(stream) > para.read.nDataHistoryBF
    stream = stream(end-para.read.nDataHistoryBF+1:end);
end

obj.UserData.data = stream;

% fprintf('%f\n', GetSecs());