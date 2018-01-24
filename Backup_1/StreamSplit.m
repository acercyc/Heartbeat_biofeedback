function [body, prefix, suffix] = StreamSplit(stream, nByteInBlock)
% 1.0 - Acer 2018/01/18 14:26
body = [];
prefix = [];
suffix = [];
    
ind = FindBlockStart(stream, nByteInBlock);
if isempty(ind)
    return
end

tail = mod(length(stream) - ind + 1, nByteInBlock);

if ind > 1
    prefix = stream(1:ind-1);
end

if tail > 0
    suffix = stream(end-tail+1:end);
end

body = stream(ind:end-tail);