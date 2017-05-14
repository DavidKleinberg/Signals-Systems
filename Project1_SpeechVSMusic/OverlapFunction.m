%% Calculate Overlap
% Computes the average power of the frames in a given interval
% that precede each subsequent frame.

% Parameter frameSize:
% Parameter interval:
% 
% Returns overlap:

function overlap = overlap(frameSize, interval) %sampleLength)
    
    frameSize = frameSize * 1000;
    interval = interval * 1000;
    overlap = 0;
    modulus = 0;
    
    %while (mod(interval,frameSize) ~= 0)
    %    overlap = overlap + mod(interval,frameSize);
    %    frameSize = frameSize - mod(interval,frameSize);
    %end
%{   
    while (mod(interval-overlap,frameSize - overlap) ~= 0)
        overlap = overlap + mod(interval-overlap,frameSize-overlap);
        frameSize = frameSize - mod(interval-overlap,frameSize-overlap);
    end
%}
%{
    while (mod(interval,frameSize) ~= 0)
        %overlap = mod(interval,frameSize);
        frameSize = mod(interval,frameSize);
    end
%}
%{    
    while (mod(interval-overlap,frameSize) ~= 0)
        frameSize = frameSize - mod(interval-overlap,frameSize);
    end
    
    overlap = frameSize/1000;
%}
    interval = interval - frameSize;
    while (mod(interval,frameSize-modulus) ~= 0)
        interval = interval - frameSize;

        frameSize = frameSize - modulus;
        
        
        
        modulus = mod(interval,frameSize);
        
        
        overlap = overlap + modulus;
    end
    
    overlap = overlap/1000;
end