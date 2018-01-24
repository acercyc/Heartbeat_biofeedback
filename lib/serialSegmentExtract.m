function d = serialSegmentExtract(v, winSize)
% v: vector
% winSize: how many elements to be selected
%
% example:
%
% v = 1:10
% winSize = 4
% 
% d = 
%     1	2	3	4
%     2	3	4	5
%     3	4	5	6
%     4	5	6	7
%     5	6	7	8
%     6	7	8	9
%     7	8	9	10

% 1.0 - Acer 2016/06/17 13:27

nv = length(v);
nRow = nv - winSize + 1;
d = NaN(nRow, winSize);
for ii = 1:nRow
    d(ii, 1:winSize) = v( ii:(ii+winSize-1) );
    
end