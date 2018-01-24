function data = ParsingBlock(stream, nByteInBlock)
% 1.0 - Acer 2018/01/18 10:20

if numel(stream) > nByteInBlock
    blocks = reshape(stream, nByteInBlock, [])';
    
elseif numel(stream) == nByteInBlock
    if size(stream, 2) ~= nByteInBlock
        blocks = stream';
    end
else
    data = [];
    return
end


data = BlockStruct(size(blocks, 1));
for i = 1:size(blocks, 1)
    block = blocks(i, :);
    
    % Byte 2
    byte2 = dec2binvec(block(2), 8);
    data(i).Disconnect = byte2(1);
    data(i).Artifact = byte2(2);
    data(i).OutOfTrack = byte2(3);
    data(i).SensorAlarm = byte2(4);
    data(i).RedPerfusion = byte2(5);
    data(i).YellowPerfusion = byte2(6);
    data(i).GreenPerfusion = byte2(7);
    data(i).FrameSync = byte2(8);

    % Byte 3
    data(i).Pleth = block(3);

    % Byte 4
    data(i).WTFisThis = block(4);
end

