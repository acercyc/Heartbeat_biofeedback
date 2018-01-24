classdef FixLengthQueue
    
    properties
        capacity 
        data
        ind = 0
    end
    
    
    methods
        function obj = FixLengthQueue(dataElement, capacity)
            obj.capacity = capacity;
            obj.data = repmat(dataElement, 1, capacity);
        end
        
        function obj = push(obj, d)
            l = length(d);
            l = obj.ind + l;
            
            if obj.ind < obj.capacity
                
                if obj.ind == 0
                else
                    dNew = obj.data(1:obj.ind)
                end
            end
            
            if l > obj.capacity
                dNew = [obj.data, d];
                obj.data = dNew(end-obj.capacity+1:end);
                obj.ind = obj.capacity;
            elseif l <= obj.capacity
                if obj.ind == 0
                    obj.data(1:l) = d;
                else
                    obj.data(obj.ind+1:l) = d;
                end
                obj.ind = l;
            end
        end
        
    end
    
    
end