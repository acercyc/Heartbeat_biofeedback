
addpath(genpath('lib'))
para = parameters();

%%
if exist('s', 'var')
    fclose(s)
    delete(s)
    clear('s')
end
instrreset

%%
s = serial('COM3', 'BaudRate', 9600);

s.BytesAvailableFcn = @GetDataFromBF;
s.BytesAvailableFcnCount = para.read.nByteToReadFromBF;
s.BytesAvailableFcnMode = 'byte';

% UserData.t = [];
% UserData.stream = [];
UserData.data = [];
UserData.tail = [];
UserData.tLast = [];

s.UserData = UserData;


%%
fopen(s);




%% Plot
wSize = para.detect.windowSize;

figure()
m = 72/60;
v = 1;

while 1
    data = GetDataByWindow(s, wSize, 1);
    fprintf('%d\n', s.BytesAvailable)
    if ~isempty(data)
        d = [data.Pleth];
        t = [data.time];
        plot(t, d)
        [pks, locs] = findpeaks(d, [], 20);
        hold on
        plot(t(locs), pks, 'o');        
        hold off
        
        if length(locs) > 5
            locs_train = locs(1:end-3);
            locs_test = locs(end-2:end);
            
%             pred = f_pred_extrap(t(locs_train), 3);
            [pred, m, v] = f_pred_kalman(t(locs_train), 3, m, v);
            
            loss = sqrt(mean((pred - t(locs_test)) .^ 2));
            title(sprintf('%f %f', loss, v));

            
            vRange = [min(d), max(d)];
            hold on
            for i = 1:length(pred)
                plot([pred(i), pred(i)], vRange, 'r')
            end
            hold off
                    
        end
        
        
        
        

        
    end
    drawnow()
end



%%


