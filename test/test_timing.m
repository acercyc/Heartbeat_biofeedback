% 1.0 - Acer 2018/01/23 17:30
%%
if exist('s', 'var')
    fclose(s)
    delete(s)
    clear('s')
end
instrreset

%% 
s = serial('COM3', 'BaudRate', 9600);
fopen(s);

nSample = 10000;
fread(s, 512);
stream = [];
t = [];
t0 = [];

while length(stream) < nSample
    t0 = [t0 GetSecs];
    stream = [stream, fread(s, 512)'];
    t = [t GetSecs];
    fprintf('%d\n', length(stream));
end

%%
mean((512/5) ./ diff(t))