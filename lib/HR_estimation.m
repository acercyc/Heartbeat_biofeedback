function hr_mean = HR_estimation(w, heart)
% parameters
para = parameters();
calibration = para.calibration;

% Message obj
txt = PsyText(w);

hr_hist = [];
hr_mean = 0;

t0 = GetSecs();
while GetSecs() < t0 + calibration.sampleTime

    % calculate HR
    [hr, sd, ~, ~, ~, ~] = heart.cal_info();
    if sd < calibration.variationThreshold
        hr_hist = [hr_hist hr];
    end   

    % show the current state
    s = sprintf(['Estimate...\t%.1fs/%gs',...
                '\n\n\n',...
                'Press Q to interrupt'], GetSecs()-t0, calibration.sampleTime);
    txt.text = s;
    txt.play();

    % Goto by key
    [keyIsDown, ~, keyCode] = KbCheck();
    if keyIsDown
        if strcmp(KbName(keyCode), 'q')            
            break           
        end        
    end
end

% compute final heartbeat average
if ~isempty(hr_hist)
    hr_mean = mean(hr_hist);
end

KbReleaseWait();