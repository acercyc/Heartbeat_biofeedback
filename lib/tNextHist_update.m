function tNextHist = tNextHist_update(tNext, tNextHist, tMinimal)
% add new value to history
% 1.0 - Acer 2018/01/23 01:37
% 2.0 - Acer 2018/03/27 19:53
%       Add runtime average

n = sum(~isnan(tNextHist));
if n == 0
    tNextHist(1) = tNext;
else
    if (tNextHist(n)+tMinimal) < tNext  % move to next pred time        
        tNextHist(n+1) = tNext;
    else
        tNextHist(n) = mean([tNextHist(n), tNext]);  % average new timing
    end
end
