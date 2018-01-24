classdef SimHeart
    
    properties
        initPulse = GetSecs();
        HR
    end
        
        
    methods
        function obj = SimHeart(HR)
            obj.HR = HR;
        end
        
        function tPred = nextPulse(self)            
            interval = 60 / self.HR;
            tPred = ceil((GetSecs() - self.initPulse) / interval) * interval + self.initPulse;
        end
        
        function v = variation(self)    
            v = self.HR * rand();     
        end        
        
    end
    
    
end