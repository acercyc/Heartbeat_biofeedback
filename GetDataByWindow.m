function data = GetDataByWindow(s, wSize, isCleanBF)
% isCleanBF
%     0: no action
%     1: clean buffer
%     2: delete data outside the window
%
% 1.0 - Acer 2018/01/19 11:28

if ~exist('isCleanBF', 'var')
    isCleanBF = true;
end

data = s.UserData.data;

if ~isempty(data)
    data = data( (GetSecs - [data.time]) < wSize );
end

switch isCleanBF
    case 1
        s.UserData.data = data;    
    case 2
        s.UserData.data = [];
end
