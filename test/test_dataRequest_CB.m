function test_dataRequest_CB(obj, event)
% 1.0 - Acer 2018/01/18 17:19
% this one keep recent n sample in a fixed size data buffer 
% n = para.read.nDataHistoryBF




%% Read from buffer
stream = fread(obj, obj.UserData.fs);
fprintf('%f\n', GetSecs());