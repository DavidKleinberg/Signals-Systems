%% Local Average Power Function
% Computes the average power of the frames in a given interval
% that precede each subsequent frame.
% 
% Returns lowPowerFrames: 1 if the frame is low power, 0 otherwise

function[lowPowerFrames] = LocalAveragePower(y, Fs, frameSize, powerPerFrame, fig)

    precedingTimeInterval = 1; %sec
    
    samplesPerFrame = frameSize*Fs;
    overlap = OverlapFunction(frameSize,precedingTimeInterval);
    samplesPerOverlap = overlap*Fs;
    framesPerInterval = int16((precedingTimeInterval - overlap)/(frameSize-overlap));
    
    totalFrames = length(powerPerFrame);
    numIntervals = int16(totalFrames - framesPerInterval);
    
    lowPowerFrames = zeros([1 length(powerPerFrame)]);
    
    for i = 1:numIntervals
        
        Pprec = mean(powerPerFrame(i:framesPerInterval+i-1));
        
        if (powerPerFrame(framesPerInterval+i) < .5*Pprec)

            lowPowerFrames(i+framesPerInterval-1) = 1; 
        end
    end
    
    if (fig ~= 0) 
        subplot(313);
        plot(lowPowerFrames,'.m');
        %axis([framesPerInterval numIntervals 0 1]);
        title('Low-Power Frames');
        ylabel('Is Low Power (boolean)');
        xlabel('Frame (k)');
    end
end