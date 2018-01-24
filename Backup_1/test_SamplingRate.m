

fread(s, 512);
n = 100;

nByte = NaN(1, n);
ts = NaN(1, n);

for i = 1:n
    i
    t(i) = GetSecs();
    stream = fread(s, 375);
    nByte(i) = numel(stream);
end

%%
mean(diff(t))

