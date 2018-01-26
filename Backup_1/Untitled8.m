clc
clear all
close all
clear classes
instrreset

addpath(genpath('lib'));
%%
s = serial('COM3', 'BaudRate', 9600);
fopen(s);


while 1
%     t = fread(s, 400);
%     readasync(s, 300);
    t = fread(s, 1);
    fprintf('%d\n', length(t));
end
