


bf = [];
nByteInBlock = 5;


%%

while 1
    % read
    stream = fread(s, 512);
    % [body, prefix, suffix] = StreamSplit(stream, nByteInBlock);


    % plot
    [body, prefix, suffix] = StreamSplit(stream, nByteInBlock);

    % write to bf
    bf = [bf; body];
    
    if length(bf) > 3000
        [bf, prefix, suffix] = StreamSplit(bf(end-2000:end), nByteInBlock);
    end

    data = parsing(bf, nByteInBlock);

    d = [data.Pleth];
    

    plot(d)
    pause(0.1)
end