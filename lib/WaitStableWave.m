function WaitStableWave(heart, para)
% 1.0 - Acer 2018/01/24 21:05

cValid = 0;
while cValid < para.calibration.nStableWaveSampleCriterium
    GetMouse();
    [~, sd, ~, amp, ~, ~] = heart.cal_info();
    if f_waveCheck_BiThreshold_SD(sd, amp, ...
            para.calibration.variationThreshold, ...
            para.calibration.rangeRateThreshold)
        cValid = cValid + 1;
    else
        cValid = 0;
    end   
    
    QuitPsych2('ESCAPE');
end