function ts = calBackwardTiming(tNow, n, fs)
ts = tNow - ((n - (1:n)) * 1/fs);
