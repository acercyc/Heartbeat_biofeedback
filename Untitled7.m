clc
clear all
close all
clear classes
instrreset

addpath(genpath('lib'));


%% load parameters


%% Initialise 
init = PsyInitialize();
w = PsyScreen(1);
w.openTest([1 1 600 600]);

heart = Heart();
heart.open();
hr_mean = Calibration(w, heart)

