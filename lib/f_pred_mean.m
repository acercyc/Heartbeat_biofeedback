function pred = f_pred_mean(peakTime, nPred)
pt_m = mean(diff(peakTime));
pred = peakTime(end) + pt_m * (1:nPred); 