%%
addpath(genpath('lib'));
commandwindow();
clc
clear all
close all
instrreset
clear classes




%%
w = PsyScreen(0);
w.openTest()


%%
% Screen('TextFont',  ndowPtr)
t = PsyText(w);
%%
t.textFont = 'Microsoft YaHei'


% enc = detect_encoding(bytes)
t.text = native2unicode('�Ђ�', 'Shift_JIS')
% t.text = unicode2native('�Ђ�', 'Shift_JIS')
t.text = '�Ђ�'
t.text = double((native2unicode('�Ђ�')))


% t.text = [26085, 26412, 35486, 12391, 12354, 12426, 12364, 12392, 12358, 12372, 12374, 12356, ...
%                     12414, 12375, 12383, 12290, 13, 10];
t.play()


%%
listfonts

%%
% Screen('TextFont', w.windowPtr)


%%
% slCharacterEncoding('UTF-8')