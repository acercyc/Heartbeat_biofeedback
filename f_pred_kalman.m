function [pred, m, v] = f_pred_kalman(peakTime, nPred, m, v)
% 1.0 - Acer 2018/01/19 18:22

% Parameters
varLimit = 0.2;

% Evidence 
mEvi = mean(diff(peakTime));
vEvi = var(diff(peakTime));
w = (1/vEvi) / (1/v + 1/vEvi);

% Update
m = m + (mEvi-m) * w;
v = v*vEvi / (v+vEvi);

if v/m < varLimit
    v = m * varLimit;
end

% if v < 0.01
%     v = 0.01;
% end

% predict
pred = peakTime(end) + m * (1:nPred); 


