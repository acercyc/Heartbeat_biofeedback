clc
clear all
close all
instrreset
%%
s = serial('COM6', 'BaudRate', 19200);
fopen(s);

%%
while 1
    if s.bytesavailable >= 1
    end
    t = fread(s, 2);
    fprintf('%d\n', t);
end




