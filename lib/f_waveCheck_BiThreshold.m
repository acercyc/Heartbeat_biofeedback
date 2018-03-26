function [isPass, rate] = f_waveCheck_BiThreshold(amp, rangeRateThreshold)
rate = (sum(amp > 101.5) + sum(amp < 98.5)) / numel(amp);
isPass = rate > rangeRateThreshold;