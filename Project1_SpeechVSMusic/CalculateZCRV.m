%% Calculate Zero Crossing Rate Variation
% The function calculates the estimated Zero Crossing Rate Variation
%
% Parameter filePath: the full path name of an audio file
% Parameter L: the length of the frame window (expressed in msec)
%
% Return ZCRV: a single value using the output argument ZCRV

function ZCRV = CalculateZCRV(filePath, L)
    
    [y,Fs] = audioread(filePath);
    
    %Zero-Crossings
    frameLength = L/1000; %convert to seconds
    z = ZeroCrossings(y, Fs, frameLength, 0);
    
    % Variation of Zero-Crossings
    v = EstimatedVariation(y, Fs, frameLength, z, 0);
    ZCRV = mean(v);
end