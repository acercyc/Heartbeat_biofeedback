classdef Heart < handle
    % 10. - Acer 2018/01/23 14:41
    
    properties
        s        
        para
        f_HR = @f_HR_meanDiff
        f_pred = @f_pred_mean
    end
    
    
    methods
        
        function obj = Heart()
        end
        
        
        % ============================================================================ %
        %                                    Control                                   %
        % ============================================================================ %

        function open(obj)
            addpath(genpath('lib'));
            obj.para = parameters();
            instrreset();
            
            % ==================================== %
            % define serial port obj
            % ==================================== %
            obj.s = serial('COM3', 'BaudRate', 9600);
            obj.s.BytesAvailableFcn = @GetDataFromBF;
            obj.s.BytesAvailableFcnCount = obj.para.read.nByteToReadFromBF;
            obj.s.BytesAvailableFcnMode = 'byte';
            
            obj.s.UserData.data = [];
            obj.s.UserData.lastRequestTime = []; 
            
            fopen(obj.s);
        end
        
        
        function close(obj)
            fclose(obj.s);
            delete(obj.s);
            instrreset();
        end
        
        
        function delete(obj)
            fclose(obj.s);
            delete(obj.s);
            instrreset();            
        end
        
        
        % ============================================================================ %
        %                                  Information                                 %
        % ============================================================================ %
        function [hr, sd, pred, amp, t, peakInd] = cal_info(obj)
            hr = [];
            sd = [];
            pred = [];
            peakInd = [];
            [amp, t] = extractAmpAndTime(obj); 
            if isempty(amp), return, end
            
            [~, peakInd] = findpeaks2(amp, 30);
            if length(peakInd) < 2, return, end
            
            peakTime = t(peakInd);
            hr = obj.f_HR(peakTime);  
            sd = std(diff(peakTime));
            pred = obj.f_pred(peakTime, 1);            
        end
        
        function [amp, t] = extractAmpAndTime(obj)
            [body, ~, ~] = StreamSplit(obj.s.UserData.data, obj.para.serial.nByteInBlock);
            data = ParsingBlock(body, obj.para.serial.nByteInBlock);
            
            if isempty(data)
                amp = [];
                t = [];
            else
                amp = [data.Pleth];            
                t = calBackwardTiming(obj.s.UserData.lastRequestTime,...
                    length(amp), obj.para.device.fs);    
            end            
        end
        
        % ============================================================================ %
        %                                     Plot                                     %
        % ============================================================================ %
        function plot(obj)
            [amp, t] = obj.extractAmpAndTime();
            plot(t, amp);                    
        end
        
        
        function isPlot = plot2(obj)
        % plot with rich information 
            % compute data                     
            [hr, sd, ~, amp, t, peakInd] = cal_info(obj);
            if isempty(hr) 
                isPlot = 0; 
                return 
            end 
            
            pred = obj.f_pred(t(peakInd(1:end-1)), 1);
                 

            % =============== Plot =============== %
            % waveform 
            plot(t, amp);
            hold on

            % Peak points                               
            plot(t(peakInd), amp(peakInd), 'o');

            % prediction 
            vRange = [min(amp), max(amp)];
            plot([pred, pred], vRange, 'r');                

            % text
            txt = sprintf('HR: %.1f; SD: %.2f', hr, sd);
            title(txt);

            % draw
            hold off 
            % ==================================== %
            isPlot = 1;                        
        end
            
            
            
    end
    
end