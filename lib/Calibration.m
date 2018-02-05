function hr_mean = Calibration(w, heart)
% 1.0 - Acer 2018/01/24 19:17

%% initialise
% parameters
para = parameters();
calibration = para.calibration;
msg = para.msg;

% Message obj
txt = PsyText(w);

% Key constrain
% enablekeys = [KbName(calibration.keyQuit), KbName(calibration.keyStart)];
enablekeys = [KbName('q'), KbName('w'), KbName('s')];
RestrictKeysForKbCheck(enablekeys);
    
%% start calibration
hr_mean = 0;
iMode = 'showInfo';
while 1
    switch iMode
        
        % ============================================================================ %
        %                                   Show info                                  %
        % ============================================================================ %        
        case 'showInfo'
            KbReleaseWait();
            while 1
                [hr, sd, ~, ~, ~, peakInd] = heart.cal_info();
                if length(peakInd) < 2
                    txt.text = 'Waiting...';
                else
                    instText = msg.CaliStartScreen;
                    s = sprintf('Heart rate: %.1f\n\nVariation: %.3f', hr, sd);
                    txt.text = [instText, s];        
                end

                txt.play();
                
                % Goto by key
                [keyIsDown, ~, keyCode] = KbCheck();
                if keyIsDown
                    switch KbName(keyCode)
                        case 'q'
                            iMode = 'quit';
                            break                            
                        case 's'
                            iMode = 'HR_estimation';
                            break

                    end
                    
                end
                
                QuitPsych2('ESCAPE');
            end
            
        % ============================================================================ %
        %                                 HR Estimation                                %
        % ============================================================================ %            
        case 'HR_estimation'
            KbReleaseWait();
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
                s = sprintf(msg.CaliEstimating, GetSecs()-t0, calibration.sampleTime);
                txt.text = s;
                txt.play();
                
                % Goto by key
                [keyIsDown, ~, keyCode] = KbCheck();
                if keyIsDown
                    switch KbName(keyCode)
                        case 'q'
                            iMode = 'showInfo';
                            break
                    end
                    KbReleaseWait();
                end
                
                QuitPsych2('ESCAPE');
            end
            
            % compute final heartbeat average
            if ~isempty(hr_hist)
                hr_mean = mean(hr_hist);
            end
            
            
            % ---------------------------------------------------------------------------- %
            % show result 
            % ---------------------------------------------------------------------------- %
            KbReleaseWait();
            instText = msg.CaliChoice;        
            s = sprintf(msg.CaliResult, hr_mean);
            txt.text = [s, instText];
            txt.play();
            
            while 1
                [keyIsDown, ~, keyCode] = KbCheck();
                if keyIsDown
                    switch KbName(keyCode)
                        case 'w'
                            iMode = 'showInfo';
                            break
                        case 's'
                            iMode = 'HR_estimation';
                            break                            
                        case 'q'
                            iMode = 'quit';
                            break
                    end                    
                end
                
                QuitPsych2('ESCAPE');
            end
            KbReleaseWait();
            
        % ============================================================================ %
        %                                     Quit                                     %
        % ============================================================================ %
        case 'quit'
            return                        
    end
end

%% End calibration mode
RestrictKeysForKbCheck();


