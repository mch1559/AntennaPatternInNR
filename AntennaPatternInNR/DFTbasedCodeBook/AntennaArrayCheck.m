function [ ] = AntennaArrayCheck(N1, N2, O1, O2)
%AntennaArrayCheck: Check the antenna array setting
%   Details


%% Get the global variables
global num_vertical_codebook; % Num of vertical codebook
global num_vertical_antenna_element_in_TXRU; % Number of vertical antenna elements in each TXRU
global num_vertical_antenna_element_in_column; %Number of vertical antenna elements
global num_horizontal_codebook; % Num of horizontal codebook
global num_horizontal_antenna_element_in_TXRU; % Number of horizontal antenna elements in each TXRU
global num_horizontal_antenna_element_in_row; %Number of horizontal antenna elements
global antenna_array_type;
global num_co_phase;


%% Check item-by-item
if num_vertical_codebook ~= O2 * N2
    disp('Error on # of vertical codebook');
    pause;
end

if strcmp(antenna_array_type, 'ULA') == 1
    if num_horizontal_codebook ~= O1 * N1
        disp('Error on # of horizontal codebook for ULA');
        pause;
    end
elseif strcmp(antenna_array_type, 'Xpol') == 1
    if num_horizontal_codebook ~= O1 * N1 * num_co_phase
        disp('Error on # of horizontal codebook for Xpol');
        pause;
    end    
end

if num_vertical_antenna_element_in_column / num_vertical_antenna_element_in_TXRU ~= N2
    disp('Error on # of vertical antenna port');
    pause;
end

if strcmp(antenna_array_type, 'ULA') == 1
    if num_horizontal_antenna_element_in_row / num_horizontal_antenna_element_in_TXRU ~= N1
        disp('Error on # of horizontal antenna port');
        pause;
    end
elseif strcmp(antenna_array_type, 'Xpol') == 1
    if num_horizontal_antenna_element_in_row / num_horizontal_antenna_element_in_TXRU ~= 2 * N1 % Consider the co-phase part in horizontal domain
        disp('Error on # of horizontal antenna port');
        pause;
    end
end

end

