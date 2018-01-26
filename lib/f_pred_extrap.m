function pred = f_pred_extrap(peakTime, nPred)
n = length(peakTime);
pred = interp1(1:n, peakTime, n+1:n+nPred, 'linear', 'extrap');
