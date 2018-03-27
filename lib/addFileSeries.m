function filename = addFileSeries(filename)
% 1.0 - Acer 2018/03/27 09:52

if exist(filename, 'file')
    [pathstr, name, ext] = fileparts(filename);
    dstr = datestr(now, '_Vyyyymmdd_HHMMSS');
    name = [name, dstr, ext];
    filename = fullfile(pathstr, name);
end
