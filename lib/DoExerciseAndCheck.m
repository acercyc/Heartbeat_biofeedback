function hr_mean = DoExerciseAndCheck(w, heart, hr_rest)
para = parameters();
design = para.design;
msg = para.msg;

txt_prompt = PsyText_Prompt(w);

    while 1
        % start measure
        txt_prompt.text = msg.ExciDoIt;
        txt_prompt.allowKey = 'space';    
        txt_prompt.playTextAndWaitForKey();
        
        % wait for stable HR
        txt_prompt.text = msg.ExciWait;
        txt_prompt.play();
        WaitStableWave(heart, para);

        % start measure
        hr_mean = HR_estimation(w, heart);        
        hr_increaseRate = hr_mean/hr_rest;
        
        % check whether the result pass criteria     
        if hr_increaseRate >= design.HRchangeRate
            sDisplay = sprintf(msg.ExciPass,...
                hr_mean, hr_increaseRate * 100);                        
            txt_prompt.text = sDisplay;
            txt_prompt.allowKey = 'space';
            txt_prompt.playTextAndWaitForKey();
            break
            
        else
            sDisplay = sprintf(msg.ExciNoPass, hr_mean, hr_increaseRate * 100);  
            txt_prompt.text = sDisplay;
            txt_prompt.allowKey = {'space', 'q'};
            [~, keyCode, ~] = txt_prompt.playTextAndWaitForKey();
            if strcmp(KbName(keyCode), 'q')
                break
            end
        end
        
    end