function tNextHist = WaitAndUpdateUntil(toT, heart, tNextHist, para)
% 1.0 - Acer 2018/01/25 17:00

% test
fprintf('WaitAndUpdateUntil: %f\n', toT - GetSecs())
% test

while GetSecs() < toT
    [hr, ~, tNext, ~, ~, ~] = heart.cal_info();
    tNextHist = tNextHist_update_byRatio(tNext, tNextHist, hr, para.pred.tMinimalHrRatio);
    QuitPsych2('ESCAPE');
end
