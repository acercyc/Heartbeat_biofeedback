%======================================================================%
% 1.0 - Acer 2013/08/14 01:45
% 1.1 - Change the name of the object
% 1.1.1 - Acer 2013/10/17 16:01
% 1.1.2 - Acer 2015/06/18 10:14
%======================================================================%

classdef SubjInfObj < dynamicprops    
    
    
    properties
        SubjectID = 'test01'
        SubjectName = 'testName'
        Gender = 'm'
        Age = '30'
        Handedness = 'r'
    end
    
    
    
    
    
    
    
    methods
        
        
        
        
        function gui(obj)
            % 1.0 - Acer 2013/08/14 02:12    
            sInputPrompt = properties(obj);
            for ii = 1:length(sInputPrompt)
                sInputDefAns{ii} = obj.(sInputPrompt{ii}); %#ok<AGROW>
            end
            
            sInputAnswer = inputdlg(sInputPrompt,...
                'Subject Information', 1, sInputDefAns); 
            
            for ii = 1:length(sInputPrompt)
                obj.(sInputPrompt{ii}) = sInputAnswer{ii};
            end         
        end
        
        
        
        
        function commandLine(obj)
            % 1.0 - Acer 2013/08/14 02:16
            sInputPrompt = properties(obj);
            for ii = 1:length(sInputPrompt)
                obj.(sInputPrompt{ii}) = input([sInputPrompt{ii} ': '], 's');
            end            
        end
        
        
        
        
        function addField(obj, fieldname, defaultVal)     
            % 1.0 - Acer 2013/08/14 02:15
            % 1.1 - Acer 2013/10/17 15:59
            if ~exist('defaultVal', 'var'); defaultVal = ''; end
            obj.addprop(fieldname);
            obj.(fieldname) = defaultVal;
        end        
        
        
        
        
        function s = makeStructure(obj)
            % 1.0 - Acer 2013/08/14 02:22
            sInputPrompt = properties(obj);
            for ii = 1:length(sInputPrompt)
                s.(sInputPrompt{ii}) = obj.(sInputPrompt{ii});
            end            
        end
        
        
        
    end
        
    
    
end