function[speech] = SpectralDenoising(filepath, Tw, alpha, beta)
    
    [mixedSignal, Fs] = audioread(filepath);
    
    frame = Tw/1000;
    samplesPerSegment = frame * Fs;

    numSamples = length(mixedSignal);
    numSegments = ceil(numSamples/samplesPerSegment);
    
    segmented_signal = SegmentSignal(mixedSignal, samplesPerSegment);
    %[noise] = NoiseEstimate(segmented_signal, Fs, samplesPerSegment);
    noiseSegments = floor(Fs/samplesPerSegment);
    noise = mean(segmented_signal(1:noiseSegments,:),1);
    
    %SNR = CalculateSNR(segmented_signal((noiseSegments+1):end,:), noise, frame);
    SNR = 0;
    for k = 1:(numSegments-noiseSegments)
        SNR = SNR + CalculateSNR(segmented_signal((noiseSegments+k),:), noise, frame);
    end
    SNR = SNR/numSegments
    
    %SNR = CalculateSNR1(segmented_signal((noiseSegments+1):end,:), noise)
    
    noise = abs(fft(noise));
    noise = noise./length(noise);

    fourierSegments = zeros(numSegments, samplesPerSegment);
    for i = 1:numSegments
        fourierSegments(i,:) = fft(segmented_signal(i,:));
        fourierSegments(i,:) = fourierSegments(i,:)./length(fourierSegments(i,:));
    end

    fourierMag = abs(fourierSegments);
    fourierPhase = angle(fourierSegments);
    denoised = zeros(numSegments, samplesPerSegment);
    
    for i = 1:numSegments
        for k = 1:length(fourierMag(i,:))
            %if (fourierMag(i,:) > alpha*noise(k))
            if (fourierMag(i,k) > alpha*noise(k))
                subtraction = max(fourierMag(i,:) - alpha*noise, 0);
            else
                denoised(i,:) = beta*noise;
            end
        end
        inverse = ifft(subtraction.*exp(1j*fourierPhase(i,:)), 'symmetric');
        inverse = inverse * length(inverse);
        denoised(i,:) = inverse;
    end
    speech = ReconstructSignal(denoised, Fs);
end

function[segments] = SegmentSignal(inputSignal, samplesPerSegment)

    numSamples = length(inputSignal);
    numSegments = ceil(numSamples/samplesPerSegment);
    segments = zeros(numSegments, samplesPerSegment);
    
    for i = 1:numSegments-1
        nextSeg = inputSignal((i-1)*samplesPerSegment+1:i*samplesPerSegment)';
        segments(i,:) = nextSeg;
    end
end

function SNR = CalculateSNR(speech_segment, avg_noise_segment,Tw)

    SNR = 10*log10(1/Tw*sum(abs(speech_segment).^2)) - 10*log10(1/Tw*sum(abs(avg_noise_segment).^2));
    SNR(find(SNR<0))=0;
%{
    [numSegments, samplesPerSegment] = size(segmented_speech);
    %SNRmatrix = zeros(numSegments, samplesPerSegment);
    SNRmatrix = zeros(1, numSegments-1);
   
    %size(segmented_speech(1,:))
    %size(avg_noise_segment)
    
    SNR = 0;
    
    for i = 1:numSegments-1
        %SNRmatrix(i,:) = snr(segmented_speech(i,:), avg_noise_segment);
        %SNRmatrix(1,i) = snr(segmented_speech(i,:), avg_noise_segment);
        SNR = SNR + snr(segmented_speech(i,:), avg_noise_segment);

    end
    
    %SNR = mean(SNRmatrix(:,:),1);
    %SNR = mean(SNRmatrix)
    SNR = SNR/(numSegments-1)
%}
end

function[reconstructed] = ReconstructSignal(segmented_signal, Fs)

    [rows, columns] = size(segmented_signal);
    
    reconstructed = zeros(1, rows*columns);
    
    for i = 1:rows
        reconstructed((i-1)*columns+1:i*columns) = segmented_signal(i,:);
    end
    
    reconstructed(1:Fs) = 0;
    
end