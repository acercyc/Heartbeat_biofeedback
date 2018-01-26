classdef PsyData < handle
% 1.0 - Acer 2011/06/21_22:38
    properties
        path
        expStartTime;
        dataFilename;
    end
    
    properties (Dependent)  
        dataFilename_temp;
    end

%% constructor    
    methods 
        function obj = PsyData(path)
            obj.expStartTime = datestr(now);
            
            % ------------- make dir ------------- %
            if ~exist('path', 'var')
                path = 'data';
            end
            
            if ~exist(path, 'dir')
                mkdir(path);
            end                        
        end
        
    end

    methods (Static = true)
        
        function addNewField(a, b)
            
        end
    end
    
    
    
%% Regular Function   
    methods 
        function enterSubjID(obj)
            obj.subjID = input('SubjectID = ', 's');
        end 
    end

%% get Function   
    methods 
        function value = get.dataFilename(obj)
            if isempty(obj.dataFilename)
                obj.dataFilename = sprintf('s%s', obj.subjID);
            end
            value = obj.dataFilename;            
        end
        
        function value = get.dataFilename_temp(obj)
            value = sprintf('%s_temp', name);         
        end              
    end
    
    %% output function
    methods (Static = true)
        ExpDataAppend(filename, data)
        Struct2File(file_name,input_struct,delimiter,precision)
    end
end