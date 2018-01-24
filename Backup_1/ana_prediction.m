load data
addpath(genpath('lib'))
%%

[pks, locs] = findpeaks(amp, [], 20);
ind = pks > 100;
pks = pks(ind);
locs = locs(ind);

%% plot
plot(amp);
hold on
plot(locs, pks, 'o');
hold off


%%
d_train = amp

%%
d = serialSegmentExtract(diff(locs), 6);


%%


plot(d);
hold on
plot(locs, pks, 'o');
hold off
