function [pks, locs] = findpeaks2(ecg_m, blank)
% modified version from findpeak
% 1.0 - Acer 2018/01/23 18:22

[pks, locs] = findpeaks(ecg_m, [], blank);
threshold = (min(ecg_m) + max(ecg_m)) / 3;
ind = pks > threshold;
pks = pks(ind);
locs = locs(ind);
