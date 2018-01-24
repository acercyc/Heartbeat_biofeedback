function [pks,locs] = findpeaks(ecg_m, no_use, blank)
% function [pks,locs] = findpeaks(ecg_m,no_use,blank)
% ecg_m : window moving averaging ECG, WMI
% blank : refractory period, in samples
% no_use: MINPEAKDISTANCE
% % Author : Dahai Gou
% email: goudh@126.com
% last revised : 2016/9/26
% Any direct or indirect use of this code should be referenced
% Copyright September 2016
%%

%% References :
%[1]PAN.J, TOMPKINS. W.J,"A Real-Time QRS Detection Algorithm" IEEE
%TRANSACTIONS ON BIOMEDICAL ENGINEERING, VOL. BME-32, NO. 3, MARCH 1985.
%% function [qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(ecg,fs)
% Complete implementation of Pan-Tompkins algorithm
%% by Hooman Sedghamiz

% local maxima detection
peak_i = [];
peak_c = [];

up_down = 'up';   % rising slope
base_point = 0;
max_p = [];
max_v = [];
for n = 2:length(ecg_m)
    x  = ecg_m(n);
    x0 = ecg_m(n-1);
    switch up_down
        case 'up'
            if x > x0
                up_down = 'down'; % down slope
                base_point = n-1;
                max_p = n;
                max_v = x;
            end
        case 'down'
            % update maximum position and level
            if x > max_v
                max_p = n;
                max_v = x;
            end
            % change direction or time past too long
            if x < x0  %| n - base_point > rp
                up_down = 'up';
                peak_c = [peak_c max_v];
                peak_i = [peak_i max_p];
            end
        otherwise
            'do nothing';
    end
end

% if successive peaks too closed, removing lower one

while 1

    n = 2;
    while n <= length(peak_i) & peak_i(n)-peak_i(n-1) > blank
        n=n + 1;
    end

    if n > length(peak_i)
        break;
    end
    
    if peak_c(n) <= peak_c(n-1)
        peak_c(n) = [];
        peak_i(n) = [];
    else
        peak_c(n-1) = [];
        peak_i(n-1) = [];
    end

end

locs = peak_i;
pks = peak_c;

