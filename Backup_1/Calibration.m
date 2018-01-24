clc
clear all
close all
clear classes

addpath(genpath('lib'));


%% load parameters
para = parameters();
calibration = para.calibration;



%% Initialise 
init = PsyInitialize();
w = PsyScreen(1);
w.openTest();


%% Message
txt = PsyText(w);


%% Key
enablekeys = [KbName(calibration.keyQuit)];
RestrictKeysForKbCheck(enablekeys);
    
    
%% start calibration
heart = SimHeart(100);


while 1
    HR = heart.HR;
    variation = heart.variation;
    
    s = sprintf('Heart beat rate: %.1f\n\n\nVariation: %.1f', HR, variation);
    txt.text = s;
    txt.play();
    
    [keyIsDown, secs, keyCode] = KbCheck();
    if keyIsDown
        switch KbName(keyCode)
            case 'q'
                break
                
        end
        
    end
    
    
    
    
end




