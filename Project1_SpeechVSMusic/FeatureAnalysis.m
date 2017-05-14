%% Zero-Crossing-Rate Variation

clear;

avgZCRV = [1:25];

for k = 1:25
    filename = 'music';
    if (k < 10)
        filename = strcat(filename,'0',num2str(k));
    else
        filename = strcat(filename,num2str(k));
    end
    filename = strcat(filename,'.wav');
    %filename = strcat(filename,'music01.wav');
    
    %Zero-Crossings
    frame = 20; %msec
    avgZCRV(k) = CalculateZCRV(filename, frame);
    
end

figure('Name', 'Zero Crossing Rate Variation');
p = plot(avgZCRV, 'o', 'Linewidth', 3);
title('Zero-Crossing-Rate Variation in Speech Samples'); %(20msec)
axis([1 25 0 100]);
%p.Color = [1 0.44 0.521];
p.Color = [.769 0.165 0.686];
xlabel('Audio Sample (k)');
ylabel('Variation Zero-Crossing-Rate');

figure('Name', 'Histogram');
h = histogram(avgZCRV, 20);
title('Zero-Crossing-Rate Variation in Speech Samples');
h.FaceColor = [1 0.81 0];
h.EdgeColor = [.769 0.165 0.686];
h.LineWidth = 1;
xlabel('Estimated Variation');
ylabel('Frequency in Samples (k)');

single = avgZCRV(3)

mean = mean(avgZCRV)
standardDeviation = std(avgZCRV)

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
    %filename = strcat(filename,'music01.wav');
    
    % Local Average Power per Frame (1 sec interval)
    frameLength = 20; %msec
    rateLowPower(k) = CalculateLPF(filename, frameLength);
    
end

mean = mean(rateLowPower)
standardDeviation = std(rateLowPower)

single = rateLowPower(3)

figure('Name', 'Low-Power Frames');
p = plot(rateLowPower, 'o', 'Linewidth', 3);
title('Rate of Low-Power Frames in Music Samples'); %(20msec)
axis([1 25 0 100]);
p.Color = [1 0.44 0.521];
xlabel('Audio Sample (k)');
ylabel('Percentage LPF (%)');

figure('Name', 'Histogram');
h = histogram(rateLowPower, 20);
title('Rate of Low-Power Frames in Music Samples'); %(20msec)
h.FaceColor = [1 0.81 0];
h.EdgeColor = [1 0.44 0.521];
h.LineWidth = 1;
xlabel('Percentage LPF (%)');
ylabel('Frequency in Samples (k)');


%% Signal Classification Test Known

clear;

decision = [1:25];

for k = 1:25
    filename = 'music';
    if (k < 10)
        filename = strcat(filename,'0',num2str(k));
    else
        filename = strcat(filename,num2str(k));
    end
    filename = strcat(filename,'.wav');
    
    decision(k) = SoundClassifier(filename);
    
end

accuracy = mean(decision)

plot(decision, 'og', 'Linewidth', 2);

%% Signal Classification Test Unknown

clear;

decision = SoundClassifier('test_10.wav')