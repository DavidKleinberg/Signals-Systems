%% Signal Power Function
% Computes the signal power
% 
% Returns signalPower:

function[signalPower] = SignalPower(y, Fs, frameSize, fig)

    time = length(y)/Fs;

    overlap = OverlapFunction(frameSize,time);
    samplesPerOverlap = overlap*Fs;
    samplesPerFrame = frameSize*Fs;
    
    numFrames = (length(y)-samplesPerOverlap)/(samplesPerFrame-samplesPerOverlap);
    
    if (overlap == 0)
        numFrames = numFrames - 1;
    end

%samplesPerFrame = frameSize*Fs;
%numFrames = length(y)/samplesPerFrame;

    signalPower = [1:numFrames];

    for i = 1:numFrames
        start = (i-1)*(samplesPerFrame-samplesPerOverlap) + 1;
        x = y(start:start+samplesPerFrame-1);
        
        sum = 0;
        for j = 1:samplesPerFrame
            sum = sum + 1/samplesPerFrame*abs(x(j))^2;
        end
        
        signalPower(i) = sum;
    end
    
    if (fig ~= 0)
        figure(fig);
        
        time = linspace(0, length(y)/Fs, length(y));
        
        subplot(311);
        p1 = plot(time, y, '-');
        p1.Color = [0 .851 0];
        title(strcat('Audio Signal (speech', num2str(fig), '.wav)'));
        xlabel('time (sec)');
        ylabel('x(t)');
        grid on;

        subplot(312);
        plot(signalPower,'xr');
        title(strcat(['Power per Frame (', num2str(frameSize), ' sec Frame, ', num2str(overlap), ' sec Overlap)']));
        xlabel('Frame Number (k)');
        ylabel('Power per Frame');
        grid on;
        
    end
end