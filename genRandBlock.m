function isSync = genRandBlock(nTrialInBlock, asyncTrialRate)
% 1.0 - Acer 2018/01/22 13:29

nAsync = floor(nTrialInBlock * asyncTrialRate);
nSync = nTrialInBlock - nAsync;
isSync = [ones(nSync, 1); zeros(nAsync, 1)];
isSync = isSync(randperm(nTrialInBlock));