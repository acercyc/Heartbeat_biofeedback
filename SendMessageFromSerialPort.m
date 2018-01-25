%% initialise 
clear all
clc
instrreset

%% parameters
messages = 51:53;
interval = 1;    % in secs

%% Open port
s = serial('COM7', 'BaudRate', 19200);
fopen(s);


%% send message
 
while 1
    rInd = randperm(length(messages));
    output = messages(rInd(1)); 
    fprintf(s, char(output));
    fprintf('%d\n', char(output));
    pause(interval);
end
