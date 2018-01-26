function [xNew, tNew] = Resample(x, t, fs)
% 1.0 - Acer 2018/01/19 14:44

nPoint = (t(end) - t(1)) * fs;
tNew = linspace(t(1), t(end), nPoint);
xNew = interp1(t, x, tNew);
