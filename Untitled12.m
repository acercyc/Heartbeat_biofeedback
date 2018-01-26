%         function addNewField(a, b)
%             
%         end
        
        
para = parameters();
        
a = para.design;
b = para.read;


if length(a) == length(b)
    if isstruct(b)
    end
    
    
end

%%
catstruct([a a], b)