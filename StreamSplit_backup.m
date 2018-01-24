function [out, prefix, suffix] = StreamSplit(out, nByteInBlock)
% 1.0 - Acer 2018/01/17 19:25

blockInd = find(out == 1);

prefixInd = [];
suffixInd = [];

prefix = [];
suffix = [];


if blockInd(1) ~= 1
    prefixInd = 1:blockInd(1)-1;
    prefix = out(prefixInd);
end

if blockInd(end-nByteInBlock+1) ~= 1
    suffixInd = blockInd(end):length(out);
    suffix = out(suffixInd);
end

out([prefixInd, suffixInd]) = [];