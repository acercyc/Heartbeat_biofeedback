s = serial('COM3');
set(s,'BaudRate', 9600);
fopen(s);
fprintf(s,'*IDN?')
out = fscanf(s);
fclose(s)
delete(s)
clear s

%%
out = fread(s, 512);
s