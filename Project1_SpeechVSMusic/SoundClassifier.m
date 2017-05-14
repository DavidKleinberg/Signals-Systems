%% Calculate Low Power Frames
% The function determines the type of the signal (speech or music)
% from unknown audio files
%
% Parameter filePath: the full path name of an audio file
%
% Return decision: a boolean
%                  ?true=1? if the decision is music
%                  ?false=0? if the decision is speech
% What do you expect to happen if the test file is neither music nor speech?

function decision = SoundClassifier(filePath)

    frameLength = 20; %msec

    LPF = CalculateLPF(filePath, 20);

    ZCRV = CalculateZCRV(filePath, 20);
    
    if (ZCRV > 70 || LPF > 45)
        decision = 0;
    else if (32 < LPF && LPF < 63.5)
        decision = 0;
    else
        decision = 1;
    end
    
    if (ZCRV < 9.9)
        decision = 1;
    end
    
end