clear all
clear classes
clc
instrreset

% dd = FixLengthQueue(NaN, 10);
% dd = dd.push(1:4);
% dd = dd.push(1:7);
% dd.data
heart = Heart



%%

heart.open();

p = [];
while 1
    heart.plot2();
    p = [p heart.nextPulse()];
end


%%
figure
plot(diff(p))