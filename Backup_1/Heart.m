classdef Heart < handle
    % 10. - Acer 2018/01/23 14:41
    
    properties
        s        
    end
    
    
    methods
        
        function obj = Heart()
        end
        
        
        % ============================================================================ %
        %                                    Control                                   %
        % ============================================================================ %

        function open(obj)
            addpath(genpath('lib'));
            para = parameters();
            instrreset();
            
            % ==================================== %
            % define serial port obj
            % ==================================== %
            obj.s = serial('COM3', 'BaudRate', 9600);
            obj.s.BytesAvailableFcn = @GetDataFromBF2;
            obj.s.BytesAvailableFcnCount = para.read.nByteToReadFromBF;
            obj.s.BytesAvailableFcnMode = 'byte';
            
            obj.s.UserData.data = []; %BlockStruct(para.read.nDataHistoryBF);
            obj.s.UserData.tail = [];
            obj.s.UserData.tLast = []; 
            
            fopen(obj.s);
        end
        
        
        function close(obj)
            fclose(obj.s);
            delete(obj.s);
            instrreset();
        end
        
        
        
        % ============================================================================ %
        %                                  Information                                 %
        % ============================================================================ %
        function hr = HR(obj)
            [amp, t] = extractAmpAndTime(obj);
            if isempty(amp)
                hr = [];
            else
                [~, locs] = findpeaks2(amp, 30);
                peakTime = t(locs);
                hr = f_HR_meanDiff(peakTime);                
            end
        end
        
        
        function sd = SD(obj)
            [amp, t] = extractAmpAndTime(obj);
            if isempty(amp)
                sd = [];
            else
                [~, locs] = findpeaks2(amp, 30);
                peakTime = t(locs);
                sd = std(diff(peakTime));
            end
        end        
        
        
        function pred = nextPulse(obj)
            [amp, t] = extractAmpAndTime(obj);
            if isempty(amp)
                pred = [];
            else
                [~, locs] = findpeaks2(amp, 30);
                if length(locs) <2
                    pred = [];
                else
                    peakTime = t(locs);
                    pred = f_pred_mean(peakTime, 1);
                end
            end            
        end
        
        
        function [amp, t] = extractAmpAndTime(obj)
            data = obj.s.UserData.data;
            if isempty(data)
                amp = [];
                t = [];
            else
                amp = [data.Pleth];
                t = [data.time];    
            end            
        end
        
        % ============================================================================ %
        %                                     Plot                                     %
        % ============================================================================ %
        function plot(obj)        
            while 1
                data = obj.s.UserData.data;
                if isempty(data)
                    continue
                end
                
                amp = [data.Pleth];
                t = [data.time];
                plot(t, amp);
                txt = sprintf('HR: %.1f', obj.HR());
                title(txt);
                drawnow();
                
                [keyIsDown, ~, keyCode] = KbCheck();
                if keyIsDown
                    if  strcmp('q', KbName(keyCode))
                        break
                    end
                end
            end            
        end           
        
        
        function isPlot = plot2(obj)
        % plot with rich information 
                data = obj.s.UserData.data;
                if isempty(data)
                    isPlot = 0;
                    return
                end
                
                % compute data
                [amp, t] = extractAmpAndTime(obj);
                [peak, locs] = findpeaks2(amp, 30);
                if length(peak) < 2
                    isPlot = 0;
                    return
                end
                peakTime = t(locs);
                pred = f_pred_mean(peakTime(1:end-1), 1);
                
                
                % =============== Plot =============== %
                % waveform 
                plot(t, amp);
                hold on
                
                % Peak points                               
                plot(t(locs), peak, 'o');
                
                % prediction 
                vRange = [min(amp), max(amp)];
                plot([pred, pred], vRange, 'r');                
                
                % text
                txt = sprintf('HR: %.1f', obj.HR());
                title(txt);
                
                % draw
                drawnow();                
                hold off 
                % ==================================== %
                isPlot = 1;                        
        end
            
            
            
    end
    
end