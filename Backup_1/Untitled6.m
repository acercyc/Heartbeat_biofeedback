clear all
clear classes
close all
% clc
instrreset


%%
para = parameters();
heart = Heart


heart.open();

%% 
% fix.play();
% cValid = 0;
% while cValid < para.calibration.nStableSampleCriterium    
%     [hr, sd, tNext, amp, t, peakInd] = heart.cal_info();
%     fprintf('%f\n', sd);
%     if sd <= para.calibration.variationThreshold
%         cValid = cValid + 1;
%     else
%         cValid = 0;
%     end   
% end
while 1
    [hr, sd, tNext, amp, t, peakInd] = heart.cal_info();
    [isPass, rate] = f_waveCheck_BiThreshold(amp);
    heart.plot();    
    title(sprintf('SD=%f, rate=%f', sd, rate));
    drawnow();
end
%%
% while 1
%     heart.plot2();
% end
%%
% while 1
%     [hr, sd, pred] = heart.cal_info();
%     fprintf('%f, %f, %f\n', hr, sd, pred);
% end
%% 
% while 1
%     [amp, t] = heart.extractAmpAndTime();
%     plot(t, amp);
%     drawnow(); 
%     
% end


% stream = heart.s.UserData.data;

