function instrreset()
% 1.0 - Acer 2018/01/29 14:28

ss = instrfindall();
if isempty(ss)
    return
end

for i = 1:length(ss)
    fclose(ss(i));
    delete(ss(i));   
end