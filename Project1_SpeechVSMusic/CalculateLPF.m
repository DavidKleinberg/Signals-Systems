%% Calculate Low Power Frames
% The function calculates the percentage of Low-Power Frames
%
% Parameter filePath: a string containing the full path name of an audio file
% Parameter L: the length of the frame window (expressed in msec)
%
% Return LPF: a single value using the output argument LPF

function[LPF] = CalculateLPF(filePath, L)
    
    [y,Fs] = audioread(filePath);
    
    % Power per Frame
    frameLength = L/1000; %convert to seconds
    p = SignalPower(y, Fs, frameLength, 0);
    
    % Local Average Power per Frame (1 sec interval)
    lowPowerFrames = LocalAveragePower(y, Fs, frameLength, p, 0);
    
    % Percentage of Low-Power Frames per Signal
    LPF = mean(lowPowerFrames) * 100;

end