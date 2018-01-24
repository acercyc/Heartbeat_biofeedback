% ---------------------------------------------------------------------------- %
%                                                                              %
%                         Video Maker for Psychtoolbox                         %
%                                                                              %
% ---------------------------------------------------------------------------- %
% 1.0 - Acer 2016/11/18 20:52

classdef PsyVideoMaker < handle

    properties
        filename = []
        wPtr = []
        videoObj = []
        isOpen = 0
    end
    
    
    
    methods
        
        function obj = PsyVideoMaker(w, filename)
            obj.filename = filename;
            obj.wPtr = w.windowPtr;
            obj.videoObj = VideoWriter(filename);
            
        end
        
        
        function addFrame(obj)
            if ~obj.isOpen
                open(obj.videoObj);
            end
            imageArray = Screen('GetImage', obj.wPtr);
            writeVideo(obj.videoObj, imageArray);
        end
        
        
        function close(obj)
            close(obj.videoObj);
        end
        
        
        function delete(obj)
            obj.close;
        end        
        
    end
    
end

