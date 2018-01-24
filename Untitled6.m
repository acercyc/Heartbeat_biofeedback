clear all
clear classes
% clc
instrreset


%%
para = parameters();
heart = Heart


heart.open();
%%
while 1
    heart.plot2();
end
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

