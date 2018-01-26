% 1.0 - Acer 2018/01/23 17:30
%%
if exist('s', 'var')
    fclose(s)
    delete(s)
    clear('s')
end

%% 
s = serial('COM3', 'BaudRate', 9600);
fopen(s);

%% collect data
nSample = 100000;
fread(s, 512);
stream = [];

while length(data) < nSample
    fprintf('%d\n', length(stream));
    stream = [stream, fread(s, 512)'];
end

%%
[body, prefix, suffix] = StreamSplit(stream, para.serial.nByteInBlock);
data = ParsingBlock(body, 5);
amp = [data.Pleth];
plot(amp);

%%
save('ModelDataCollector', 'amp');