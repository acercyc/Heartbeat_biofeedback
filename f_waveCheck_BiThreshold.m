function [isPass, rate] = f_waveCheck_BiThreshold(amp, rangeRateThreshold)
rate = (sum(amp > 102) + sum(amp < 98)) / numel(amp);
isPass = rate > rangeRateThreshold;