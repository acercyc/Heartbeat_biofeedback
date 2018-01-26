function tNextHist = tNextHist_update_byRatio(tNext, tNextHist, HR, minRatio)
% limit update value diff by HR ration 
% 1.0 - Acer 2018/01/23 01:37

tMinimal = 60/HR * minRatio;
tNextHist = tNextHist_update(tNext, tNextHist, tMinimal);
