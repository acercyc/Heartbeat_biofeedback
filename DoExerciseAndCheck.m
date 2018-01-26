function hr_mean = DoExerciseAndCheck(w, heart, hr_rest)
para = parameters();
design = para.design;
txt_prompt = PsyText_Prompt(w);

    while 1
        % start measure
        txt_prompt.text = ['Do Exercise and Rise Your Heart Rate\n\n'...
                           'Press Space to Measure Heart Rate After Exercise'];
        txt_prompt.allowKey = 'space';    
        txt_prompt.playTextAndWaitForKey();
        
        % wait for stable HR
        txt_prompt.text = 'Wait for heartbeat stabilized...';
        txt_prompt.play();
        WaitStableWave(heart, para);

        % start measure
        hr_mean = HR_estimation(w, heart);        
        hr_increaseRate = hr_mean/hr_rest;
        
        % check whether the result pass criteria     
        if hr_increaseRate >= design.HRchangeRate
            sDisplay = sprintf(['Your heart rate is %.1f, ',...
                ' and %.1f%% of your resting heart rate.\n\n', ...
                'Well done\n\n\n',...
                'Press Space to continue'],...
                hr_mean, hr_increaseRate * 100);                        
            txt_prompt.text = sDisplay;
            txt_prompt.allowKey = 'space';
            txt_prompt.playTextAndWaitForKey();
            break
            
        else
            sDisplay = sprintf(['Your heart rate is %.1f,'...
                'and %.1f%% of your resting heart rate.\n\n', ...
                'Please try again\n\n\n',...
                'Press Space to continue'],... 
                hr_mean, hr_increaseRate * 100);  
            txt_prompt.text = sDisplay;
            txt_prompt.allowKey = 'space';
            txt_prompt.playTextAndWaitForKey();            
        end
        
    end