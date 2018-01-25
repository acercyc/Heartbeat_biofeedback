kfunction [keyIsDown, secs, keyCode] = SerialPortCheck(s)

secs = GetSecs();
if s.bytesavailable > 1
    txt = fread(s, 2);
    keyCode = txt(1);
    keyIsDown = 1;
else 
    keyIsDown = 0;
    keyCode = 0;
end