function WaitStableWave(heart, para, w)
% 1.0 - Acer 2018/01/24 21:05
% 1.1 - Acer 2018/03/26 09:31
%       Add animation

if exist('w', 'var')
    txt = PsyText(w);
end

cValid = 0;
while cValid < para.calibration.nStableWaveSampleCriterium
    GetMouse();
    [~, sd, ~, amp, ~, ~] = heart.cal_info();
    if f_waveCheck_BiThreshold_SD(sd, amp, ...
            para.calibration.variationThreshold, ...
            para.calibration.rangeRateThreshold)
        cValid = cValid + 1;
    else
        cValid = 0;
    end
    
    
    % ------------------------------- Show message ------------------------------- %
    if exist('w', 'var')                
        [~, rate] = f_waveCheck_BiThreshold(amp, para.calibration.rangeRateThreshold);
        ampVal = (para.calibration.rangeRateThreshold - rate) * 20;
        if ampVal < 0
            ampVal = 0;
        end        
        
        sdVal = (sd / para.calibration.variationThreshold - 1) * 10;
        if sdVal < 0
            sdVal = 0;
        end
        
        txt.text = [para.msg.WaitStableSignal, ...
                    '\n\n', ...
                    repmat('==', 1, 1 + ceil(ampVal) + ceil(sdVal))];         
        
%         txt.text = [para.msg.WaitStableSignal, ...
%                     '\n\nAmp:', ...
%                     repmat('==', 1, round(ampVal)),...
%                     '\n\nSD: ',...
%                     repmat('==', 1, round(sdVal))];
                
%         txt.text = [para.msg.WaitStableSignal, ...
%                     '\n\n', ...
%                     repmat('==', 1, para.calibration.nStableWaveSampleCriterium - cValid)];                
        txt.play();
    end
    
    QuitPsych2('ESCAPE');
end