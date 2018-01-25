clear all
close all
clear classes
clc
instrreset

%% 
heart = Heart;
heart.open();


%%
figure()
while 1
    heart.plot2();
    drawnow();         
end
