%% Zero-Crossing-Rate Variation

clear;

avgVariations = [1:25];
avgZeroCross = [1:25];

for k = 1:25
    filename = 'music';
    if (k < 10)
        filename = strcat(filename,'0',num2str(k));
    else
        filename = strcat(filename,num2str(k));
    end
    %filename = strcat(filename,'.wav');
    filename = 'music01.wav';
    
    [y,Fs] = audioread(filename);
    
    %Zero-Crossings
    frame = .02; %20 msec
    %z = ZCrossings1(y, Fs, frame, k);
    z = ZeroCrossings(y, Fs, frame, k);
    avgZeroCross(k) = mean(z);
    
    % Variation of Zero-Crossings
    %v = EVariation1(frame, z, k);
    v = EstimatedVariation(y, Fs, frame, z, k);
    avgVariations(k) = mean(v);
    
end

%{
%Plot the average Zero-Crossings per sample
    figure(26);
    p = plot(avgZeroCross, 'o', 'LineWidth', 2);
    %p.Color = [.655 .678 1];
    p.Color = [1 .678 1];
    title('Average Number of Zero-Crossings for Individual Audio Samples');
    legend('music', 'speech');
    ylabel('Avg Zero-Crossings per Frame');
    xlabel('Sample Number (k)');
    hold on;
    grid on;
%}

%% Percentage of Low-Power Frames

clear;

rateLowPower = [1:25];

for k = 1:25
    filename = 'music';
    if (k < 10)
        filename = strcat(filename,'0',num2str(k));
    else
        filename = strcat(filename,num2str(k));
    end
    filename = strcat(filename,'.wav');
    
    [y,Fs] = audioread(filename);
    
    % Power per Frame
    frame = .02; %20 msec
    p = SignalPower(y, Fs, frame, k);
    
    % Local Average Power per Frame (1 sec interval)
    timeInterval = 1; %second
    lowPowerFrames = LocalAveragePower(y, Fs, frame, p, 1);
    
    % Percentage of Low-Power Frames per Signal
    percentageLowPowerFrames = mean(lowPowerFrames);
    
    rateLowPower(k) = percentageLowPowerFrames;
    
end
