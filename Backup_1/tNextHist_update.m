function tNextHist = tNextHist_update(tNext, tNextHist, tMinimal)
% add new value to history
% 1.0 - Acer 2018/01/23 01:37

n = sum(~isnan(tNextHist));
if n == 0
    tNextHist(1) = tNext;
else
    if (tNextHist(n)+tMinimal) < tNext
        tNextHist(n+1) = tNext;
    end
end
