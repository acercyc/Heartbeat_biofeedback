% 1.0 - Acer 2018/01/29 15:21
%% initialisation
addpath(genpath('lib'));
clear all
close all
clear classes
clc
instrreset
 


%% open port
heart = Heart;
heart.open();


%% plot 
figure()
while 1
    heart.plot2();
    drawnow();         
end
