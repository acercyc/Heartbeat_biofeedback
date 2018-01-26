clear all
clear classes
close all
clc
instrreset

% dd = FixLengthQueue(NaN, 10);
% dd = dd.push(1:4);
% dd = dd.push(1:7);
% dd.data
heart = Heart;



%%

heart.open();

figure()

%%
p = [];
while 1
    heart.plot2();
    drawnow();         
end


%%
figure
plot(diff(p))