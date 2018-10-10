function [N1, N2, O1, O2, P] = AntennaArrayConfig( )
%AntennaArrayConfig: As its name inidates
%   Details
% N1 = 4; % codebook-Config-N1: # of horizontal antenna port
% N2 = 2; % codebook-Config-N2: # of vertical antenna port
% O1 = 4; % codebook-Over-Sampling-RateConfig-O1
% O2 = 4; % codebook-Over-Sampling-RateConfig-O2

% Notes for example
% # of vertical code book = O2 * N2 = 8 and length 2 (N2);
% # of horizontal code book = O1 * N1 = 16 and length 4 (N1);
% Total ports layout P = 2 * 4 * 4 = 16;


%% Set the case
num_antenna_port = 16;
Port8OverSamplingFactor = 1;
Port16AntennaCase = 2;
Port16OverSamplingFactor = 2;


%% Set the number
if num_antenna_port == 8
    N1 = 2; 
    N2 = 2;
    if Port8OverSamplingFactor == 1
        O1 = 4;
        O2 = 4;
    elseif Port8OverSamplingFactor == 2
        O1 = 8; 
        O2 = 8;
    end
elseif num_antenna_port == 12
    % Not coded yet
    disp('Not implemented yet for 12 CSI-RS ports');
    pause;
elseif num_antenna_port == 16
    if Port16AntennaCase == 1
        N1 = 2;
        N2 = 4;
        if Port16OverSamplingFactor == 1
            O1 = 8;
            O2 = 4;
        elseif Port16OverSamplingFactor == 2
            O1 = 8;
            O2 = 8;
        end
    elseif Port16AntennaCase == 2
        N1 = 4;
        N2 = 2;
        if Port16OverSamplingFactor == 1
            O1 = 8;
            O2 = 4;
        elseif Port16OverSamplingFactor == 2
            O1 = 4;
            O2 = 4;
        end
    elseif Port16AntennaCase == 3
        N1 = 8;
        N2 = 1;
        if Port16OverSamplingFactor == 1
            O1 = 4;
        elseif Port16OverSamplingFactor == 2
            O1 = 8;
        end
    end
end

% # of total antenna ports
P = 2 * N1 * N2; 


%% Abnormal check
if (P ~= num_antenna_port)
    disp('Error 0001 on antenna port number setting in AntennaArrayConfig()');
    pause;
end

end

