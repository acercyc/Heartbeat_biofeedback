function blockStartInd = FindBlockStart(stream, nByteInBlock)
% block start with 1
% 1.0 - Acer 2018/01/18 14:24

tail = mod(length(stream), nByteInBlock);
dataMat = reshape(stream(1:end-tail), nByteInBlock, []);
blockStartInd = find(all(dataMat == 1, 2));
if isempty(blockStartInd)
    warning('not all blocks have 5 bytes');
end
