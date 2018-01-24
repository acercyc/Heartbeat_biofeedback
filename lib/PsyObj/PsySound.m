classdef PsySound < handle
% 1.0 - Acer 2012/10/31 10:47
% 1.1 - Acer 2018/01/22 22:34

    properties
        soundArray
        freq = 44100
        nrchannels
        pahandle
        startTime
        endTime
    end
    
    methods
        function obj = PsySound(freq)
            InitializePsychSound;
            if exist('freq', 'var')
                obj.freq = freq;
            end            
        end
        
        function set.soundArray(obj, soundArray)
            obj.soundArray = soundArray;
            obj.open();
            obj.bufferLoading();
            
        end
                
        function open(obj)
             obj.pahandle = PsychPortAudio('Open', [], 1, 3, obj.freq, min(size(obj.soundArray)));
        end
        
        function close(obj)
            PsychPortAudio('Close', obj.pahandle);
        end
        
        function play(obj)
            obj.startTime  = PsychPortAudio('Start', obj.pahandle);
        end
        
        function playAtTime(obj, when)
            obj.startTime  = PsychPortAudio('Start', obj.pahandle, 1, when);
        end        
        
        function stop(obj)
            obj.endTime = PsychPortAudio('Stop', obj.pahandle);
        end

        function bufferLoading(obj)
            PsychPortAudio('FillBuffer', obj.pahandle, obj.soundArray);    
        end
        
        function delete(obj)
            obj.close();
        end        
    end
    
end