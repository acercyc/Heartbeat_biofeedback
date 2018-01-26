function QuitPsych2(key) 
% Second version use RestrictKeysForKbCheck
% 1.0 - Acer 2018/01/26 16:36

old = RestrictKeysForKbCheck(KbName(key));
keyIsDown = KbCheck;
RestrictKeysForKbCheck(old);

if keyIsDown
    error('abort program');
end
