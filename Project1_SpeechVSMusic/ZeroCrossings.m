%% Zero Crossings Function
% Computes the average power of the frames in a given interval
% that precede each subsequent frame.

% It does NOT include instances where the  =0 but thats not crossing.
% Because it does not cross (ie changes sign from + to ?)
% 
% Returns lowPowerFrames: 1 if the frame is low power, 0 otherwise

function[zeroCrossings] = ZeroCrossings(y, Fs, frameSize, fig)

    time = length(y)/Fs;

    overlap = OverlapFunction(frameSize,time);
    samplesPerOverlap = overlap*Fs;
    samplesPerFrame = frameSize*Fs;
    
    numFrames = (length(y)-samplesPerOverlap)/(samplesPerFrame-samplesPerOverlap);
    
    if (overlap == 0)
        numFrames = numFrames - 1;
    end

    zeroCrossings = [1:numFrames];

    for i = 1:numFrames
        start = (i-1)*(samplesPerFrame-samplesPerOverlap) + 1;
        x = y(start:start+samplesPerFrame-1);
        count = 0;
        for j = 1:samplesPerFrame - 1
            %if (x(j)*x(j+1) < 0)
            if (x(j) > 0 & x(j+1) < 0)
                count = count + 1;
            end
        end
    
        zeroCrossings(i) = count;
    end
    
    if (fig ~= 0)
        figure(fig);
        
        time = linspace(0, length(y)/Fs, length(y));
        %frames = linspace(0, length(y)/length(zeroCrossings), length(zeroCrossings));
        
        subplot(311);
        p1 = plot(time, y, '-');
        p1.Color = [0 .851 0];
        title(strcat('Audio Signal (music', num2str(fig), '.wav)'));
        xlabel('time (sec)');
        ylabel('x(t)');
        grid on;
    
        subplot(312);
        p2 = plot(zeroCrossings,'x');
        p2.Color = [0 .69 .941];
        title(strcat(['Zero-Crossings (', num2str(frameSize), ' sec Frame, ', num2str(overlap), ' sec Overlap)']));
        axis([0 500 0 80]);
        xlabel('Frame Number (k)');
        ylabel('Zero-Crossings per Frame');
        grid on;
    end
end
