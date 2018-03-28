function tNextHist = WaitAndUpdateUntil(toT, heart, tNextHist, para)
% 1.0 - Acer 2018/01/25 17:00

while GetSecs() < toT
    [~, ~, tNext, ~, ~, ~] = heart.cal_info();
    tNextHist = tNextHist_update(tNext, tNextHist, para.pred.tMinimal);
    QuitPsych2('ESCAPE');
end
