function [GAIN_CB, GAIN_WO_CB, GAIN_WO_CB_NP, GAIN_CB_BEAM] = VerticalAntennaPattern(AntennaElementGainV, W_V)
%VerticalAntennaPattern: 
%   Calculate the vertical anntenna pattern and draw figure for better understanding
%   A: Self-defined codebook (different from 3GPP Rel.13)
%   B: Rel.13 defined vertical codebook
%
%Detailed explanation:
%    Output: antenna gain
%Note 1: 1D sub-array partition model (TXRU virtualization model option-1) in 3GPP TR.36.897


%% Define parameters
% % Antenna layout setting
global num_vertical_codebook; % Num of vertical codebook
global num_vertical_antenna_element_in_TXRU; % Number of vertical antenna elements in each TXRU
global num_vertical_antenna_element_in_column; %Number of vertical antenna elements
global down_tilt_angle; % electrical down tile
global w_lambda; % Wavelength
global dv; % vertical antenna element distance
global vertical_granularity;

% Initialize the vertical antenna array gain
GAIN_CB = zeros(size(AntennaElementGainV));
GAIN_WO_CB = zeros(size(AntennaElementGainV));
GAIN_WO_CB_NP = zeros(size(AntennaElementGainV));
GAIN_CB_BEAM = zeros(num_vertical_codebook, length(AntennaElementGainV));


%% Calculate the vertical antenna pattern with self-defined vertical codebook
vertical_codebook_format = 3;
angle_first = 60;
angle_last = 120;
vertical_codebook_set = [60, 90, 120, 150]; % the length of this set should be num_vertical_codebook

for vertical_angle_ = vertical_granularity 
    % Set the total gain 
    w_total = 0.0;
    
    % Each vertical codeword
    for vertical_codebook_ = 0: num_vertical_codebook - 1 
        temp = 0.0; % Set the temp gain for each codebook
        
        % Get the angle associated with the vertical codebook
        if vertical_codebook_format == 1
            angle_codebook = angle_first + (angle_last - angle_first) / num_vertical_codebook * vertical_codebook_; 
        elseif vertical_codebook_format == 2
            angle_codebook = vertical_codebook_set(vertical_codebook_ + 1);
        elseif vertical_codebook_format == 3
            % Use the codebook from 3GPP vertical codebook
        end
        
        % Sum up the gain from all antenna elements
        for antenna_element_ = 0: num_vertical_antenna_element_in_column - 1 % Each vertical antenna element
            temp_angle = exp(1j * 2 * pi / w_lambda * antenna_element_ * dv * cos(vertical_angle_ / 180 * pi));
            temp_etilt = exp(-1j * 2 * pi / w_lambda * mod(antenna_element_, num_vertical_antenna_element_in_TXRU) * dv * cos(down_tilt_angle / 180 * pi));
            
            % Choose the vertical codebook
            if vertical_codebook_format == 1 || vertical_codebook_format == 2
                temp_codebook = exp(-1j * 2 * pi / w_lambda * floor(antenna_element_ / num_vertical_antenna_element_in_TXRU) * num_vertical_antenna_element_in_TXRU * dv * cos(angle_codebook / 180 * pi));
            elseif vertical_codebook_format == 3
                temp_codebook = W_V(vertical_codebook_ + 1, floor(antenna_element_ / num_vertical_antenna_element_in_TXRU) + 1);
            end 
            
            temp_antenna_element_gain = sqrt(10.^(AntennaElementGainV(vertical_angle_ + abs(min(vertical_granularity)) + 1) / 10));
            temp = temp + temp_angle * temp_etilt * temp_codebook * temp_antenna_element_gain;
        end;
        
        % Average over all antenna elements
        temp_total = abs(temp)^2 / num_vertical_antenna_element_in_column;
        
        % Find the maximum antenna gain among vertical codebook
        if (temp_total > w_total)
            w_total = temp_total;
        end;
    end;
    
    % Convert the gain in linear-scale to dB-scale
    % GAIN(vertical_angle_ + abs(min(vertical_granularity)) + 1) = GAIN(vertical_angle_ + abs(min(vertical_granularity)) + 1) + 10 * log10(w_total);
    GAIN_CB(vertical_angle_ + abs(min(vertical_granularity)) + 1) = 10 * log10(w_total);
end;


%% Calculate the vertical beam pattern with self-defined vertical codebook
fixed_vertical_etilt_flag = 1;
for vertical_codebook_ = 0: num_vertical_codebook - 1 % Each vertical codeword
    % Get the angle associated with the vertical codebook
    if vertical_codebook_format == 1
        angle_codebook = angle_first + (angle_last - angle_first) / num_vertical_codebook * vertical_codebook_;
    elseif vertical_codebook_format == 2
        angle_codebook = vertical_codebook_set(vertical_codebook_ + 1);
    elseif vertical_codebook_format == 3
        % Use the codebook from 3GPP vertical codebook
    end
    
    for vertical_angle_ = vertical_granularity  
        % Set the temp gain of each antenna element
        temp = 0.0; 
                
        % Sum up the gain from all antenna elements
        for antenna_element_ = 0: num_vertical_antenna_element_in_column - 1 % Each vertical antenna element
            temp_angle = exp(1j * 2 * pi / w_lambda * antenna_element_ * dv * cos(vertical_angle_ / 180 * pi));
            if fixed_vertical_etilt_flag == 1
                temp_etilt = exp(-1j * 2 * pi / w_lambda * mod(antenna_element_, num_vertical_antenna_element_in_TXRU) * dv * cos(down_tilt_angle / 180 * pi));
            else
                temp_etilt = exp(-1j * 2 * pi / w_lambda * mod(antenna_element_, num_vertical_antenna_element_in_TXRU) * dv * cos(angle_codebook / 180 * pi));
            end
            
            % Choose the vertical codebook 
            if vertical_codebook_format == 1 || vertical_codebook_format == 2
                temp_codebook = exp(-1j * 2 * pi / w_lambda * floor(antenna_element_ / num_vertical_antenna_element_in_TXRU) * num_vertical_antenna_element_in_TXRU * dv * cos(angle_codebook / 180 * pi));
            elseif vertical_codebook_format == 3
                 temp_codebook = W_V(vertical_codebook_ + 1, floor(antenna_element_ / num_vertical_antenna_element_in_TXRU) + 1);
            end 
            
            temp_antenna_element_gain = sqrt(10.^(AntennaElementGainV(vertical_angle_ + abs(min(vertical_granularity)) + 1) / 10));
            temp = temp + temp_angle * temp_etilt * temp_codebook * temp_antenna_element_gain;
        end;
        
        % Average over all antenna elements
        w_total = abs(temp)^2 / num_vertical_antenna_element_in_column;
        
        % Convert the gain in linear-scale to dB-scale
        GAIN_CB_BEAM(vertical_codebook_ + 1, vertical_angle_ + abs(min(vertical_granularity)) + 1) = 10 * log10(w_total);
    end;
end;

% Note 1: given the analog precoder 100 degree there, the impact of vertical codebook is not strong; 
% However, in the horizontal domain, there is no such 100 degree, so the impact of codebook is expected to be obvious
% Note 2: as we modify the vertical e-tile to vertical codebook angle, the antenan pattern can be changed accordingly


%% Calculate the vertical antenna pattern without vertical codebook
for vertical_angle_ = vertical_granularity 
    temp = 0.0; % Set the temp gain
    
    % Sum up the gain from all antenna elements
    for antenna_element_ = 0: num_vertical_antenna_element_in_column - 1 % Each vertical antenna element
        temp_angle = exp(1j * 2 * pi / w_lambda * antenna_element_ * dv * cos(vertical_angle_ / 180 * pi));
        temp_etilt = exp(-1j * 2 * pi / w_lambda * mod(antenna_element_, num_vertical_antenna_element_in_TXRU) * dv * cos(down_tilt_angle / 180 * pi));
        temp = temp + temp_angle * temp_etilt * sqrt(10.^(AntennaElementGainV(vertical_angle_ + abs(min(vertical_granularity)) + 1) / 10));
    end;
    
    % Average over all antenna elements
    w_total = abs(temp)^2 / num_vertical_antenna_element_in_column;
    
    % Calculate the gain without codebook
    GAIN_WO_CB(vertical_angle_ + abs(min(vertical_granularity)) + 1) = 10 * log10(w_total);
end;


%% Calculate the vertical antenna pattern without vertical codebook
% Considering the normalized power
for vertical_angle_ = vertical_granularity 
    temp = 0.0; % Set the temp gain
    
    % Sum up the gain from all antenna elements
    for antenna_element_ = 0: num_vertical_antenna_element_in_column - 1 % Each vertical antenna element
        temp_angle = exp(1j * 2 * pi / w_lambda * antenna_element_ * dv * cos(vertical_angle_ / 180 * pi));
        temp_etilt = 1 / sqrt(num_vertical_antenna_element_in_TXRU) * exp(-1j * 2 * pi / w_lambda * mod(antenna_element_, num_vertical_antenna_element_in_TXRU) * dv * cos(down_tilt_angle / 180 * pi));
        temp_codebook = 1 / sqrt(num_vertical_antenna_element_in_column / num_vertical_antenna_element_in_TXRU);
        temp = temp + temp_angle * temp_etilt * temp_codebook * sqrt(10.^(AntennaElementGainV(vertical_angle_ + abs(min(vertical_granularity)) + 1) / 10));
    end;
    
    % Average over all antenna elements
    w_total = abs(temp)^2;
    
    % Calculate the gain without codebook
    GAIN_WO_CB_NP(vertical_angle_ + abs(min(vertical_granularity)) + 1) = 10 * log10(w_total);
end;
% Note: vertical codebook with unit power; and analog precoder, i.e.
% e-tilt with unit power, which is then equivalent to the original antenna pattern


%% The end of this script
% Jeffrey && William

