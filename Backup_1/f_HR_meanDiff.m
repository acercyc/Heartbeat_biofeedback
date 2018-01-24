function HR = f_HR_meanDiff(peakTime)
% 1.0 - Acer 2018/01/23 18:28

peakTimeDiff = diff(peakTime);
HR = 1 / mean(peakTimeDiff) * 60;
