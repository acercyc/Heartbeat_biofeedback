function beep = SoundFade(beep, samplingRate, fadeTime)
% 1.0 - Acer 2018/03/28 12:19

if fadeTime ~= 0
    np = fadeTime * samplingRate;
    w1 = linspace(0, 1, np);
    w2 = linspace(1, 0, np);

    beep(1:np) = beep(1:np) .* w1;
    beep(end-np+1:end) = beep(end-np+1:end) .* w2;
end