classdef SimHeart < handle
% 1.0 - Acer 2018/02/05 16:05
    
    properties
        HR = 75
        s
        para
        initPulse
    end
        
        
    methods
        function obj = SimHeart()
            addpath(genpath('lib'));
        end
        
        function open(obj)
            obj.para = parameters();
            obj.initPulse = GetSecs();
        end
        
        function close(obj)
        end
        
        function [hr, sd, pred, amp, t, peakInd] = cal_info(obj)
            hr = 75;
            sd = 0.001;
            pred = obj.nextPulse();
            amp = [110, 110, 110, 110];
            t = NaN;
            peakInd = 1:10;
            
        end        
        
        function tPred = nextPulse(self)            
            interval = 60 / self.HR;
            tPred = ceil((GetSecs() - self.initPulse) / interval) * interval + self.initPulse;
        end
        
    end
    
    
end