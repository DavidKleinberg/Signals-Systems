%% Estimated Variation Function
% Computes the average power of the frames in a given interval
% that precede each subsequent frame.

% Parameter frameSize:
% Parameter zeroCrossings:
% Parameter fig: number of the figure to graph, 0 for graph to be repressed
% 
% Returns variation: 

function[variation] = EstimatedVariation(y, Fs, frameSize, zeroCrossings, fig)

    time = 1; %sec
    samplesPerFrame = frameSize*Fs;
    
    overlap = OverlapFunction(frameSize,time);
    samplesPerOverlap = overlap*Fs;
    
    framesPerAggregate = int16((time - overlap)/(frameSize-overlap));
    numAggregates = length(y)/Fs/time;
    
    if (overlap == 0)
        numAggregates = length(zeroCrossings)/framesPerAggregate;
    end
    
    variation = [1:numAggregates];
    
    for i = 1:numAggregates
        
        if (overlap == 0)
            x = zeroCrossings((i-1)*framesPerAggregate + 1:i*framesPerAggregate-1);
        else
            x = zeroCrossings(i:i+framesPerAggregate-1);
        end
        variation(i) = var(x);
    end
    
    if (fig ~= 0)
        subplot(313);
        p = plot(variation, '.', 'markersize', 15);
        axis([0 10 -inf inf]);
        p.Color = [1 .635 0];
        title('Variation of Zero-Crossings per Interval (1.0 sec)');
        xlabel('Interval Number (k)');
        ylabel('Variation');
        grid on;
    end
end