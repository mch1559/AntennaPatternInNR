function [FullConnectionGain, FullConnectionGain2, FullConnectionCombineGain, SubConnectionGain] = FullConnectionVerticalAntennaPattern(AntennaElementGainV)
%VerticalAntennaPattern: 
%   Calculate the vertical anntenna pattern 
%Detailed explanation:
%    Output: antenna pattern
%Note 1: 1D sub-array partition model (TXRU virtualization model option-1) in 3GPP TR.36.897
%Note 2: 1D full-connection 1D partition model (TXRU virtualization model) in 3GPP TR.36.897


%% Define parameters: antenna layout setting
%global num_vertical_antenna_element_in_TXRU; % Number of vertical antenna elements in each TXRU
global num_vertical_antenna_element_in_TXRU_sub_connection; % Number of vertical antenna elements in each TXRU
global num_vertical_antenna_element_in_column; % Number of vertical antenna elements
global w_lambda; % Wavelength
global dv; % vertical antenna element distance
global vertical_granularity;
global analog_beam_angle_1;
global analog_beam_angle_2;

% Initialize the vertical antenna array gain
FullConnectionGain = zeros(size(AntennaElementGainV));
FullConnectionGain2 = zeros(size(AntennaElementGainV));
FullConnectionCombineGain = zeros(size(AntennaElementGainV));
SubConnectionGain = zeros(size(AntennaElementGainV));


%% Calculate the vertical antenna pattern of one analog beam
for vertical_angle_ = vertical_granularity 
    temp = 0.0; % Set the temp gain
    
    % Sum up the gain from all antenna elements
    for antenna_element_ = 0: num_vertical_antenna_element_in_column - 1 % Each vertical antenna element
        temp_angle = exp(1j * 2 * pi / w_lambda * antenna_element_ * dv * cos(vertical_angle_ / 180 * pi));
        temp_etilt = exp(-1j * 2 * pi / w_lambda * antenna_element_ * dv * cos(analog_beam_angle_1 / 180 * pi)); % Use one analog beam angle
        temp = temp + temp_angle * temp_etilt * sqrt(10.^(AntennaElementGainV(vertical_angle_ + abs(min(vertical_granularity)) + 1) / 10));
    end;
    
    % Average over all antenna elements
    w_total = abs(temp)^2 / num_vertical_antenna_element_in_column;
    
    % Calculate the gain without codebook
    FullConnectionGain(vertical_angle_ + abs(min(vertical_granularity)) + 1) = 10 * log10(w_total);
end


%% Calculate the vertical antenna pattern of another analog beam
for vertical_angle_ = vertical_granularity 
    temp = 0.0; % Set the temp gain
    
    % Sum up the gain from all antenna elements
    for antenna_element_ = 0: num_vertical_antenna_element_in_column - 1 % Each vertical antenna element
        temp_angle = exp(1j * 2 * pi / w_lambda * antenna_element_ * dv * cos(vertical_angle_ / 180 * pi));
        temp_etilt = exp(-1j * 2 * pi / w_lambda * antenna_element_ * dv * cos(analog_beam_angle_2 / 180 * pi)); % Use another analog beam angle
        temp = temp + temp_angle * temp_etilt * sqrt(10.^(AntennaElementGainV(vertical_angle_ + abs(min(vertical_granularity)) + 1) / 10));
    end;
    
    % Average over all antenna elements
    w_total = abs(temp)^2 / num_vertical_antenna_element_in_column;
    
    % Calculate the gain without codebook
    FullConnectionGain2(vertical_angle_ + abs(min(vertical_granularity)) + 1) = 10 * log10(w_total);
end


%% Calculate the vertical antenna pattern of the combined analog beams
for vertical_angle_ = vertical_granularity 
    temp = 0.0; % Set the temp gain
    
    % Sum up the gain from all antenna elements
    for antenna_element_ = 0: num_vertical_antenna_element_in_column - 1 % Each vertical antenna element
        temp_angle = exp(1j * 2 * pi / w_lambda * antenna_element_ * dv * cos(vertical_angle_ / 180 * pi));
        % Linar combine two analog beams at each antenna element 
        temp_etilt = exp(-1j * 2 * pi / w_lambda * antenna_element_ * dv * cos(analog_beam_angle_1 / 180 * pi)) + exp(-1j * 2 * pi / w_lambda * antenna_element_ * dv * cos(analog_beam_angle_2 / 180 * pi)); 
        % Don't forget to normalize the Tx power
        temp_etilt = temp_etilt / abs(temp_etilt);
        temp = temp + temp_angle * temp_etilt * sqrt(10.^(AntennaElementGainV(vertical_angle_ + abs(min(vertical_granularity)) + 1) / 10));
    end;
    
    % Average over all antenna elements
    w_total = abs(temp)^2 / num_vertical_antenna_element_in_column;
    
    % Calculate the gain without codebook
    FullConnectionCombineGain(vertical_angle_ + abs(min(vertical_granularity)) + 1) = 10 * log10(w_total);
end

%% Calculate the vertical antenna pattern of sub-connection mode
for vertical_angle_ = vertical_granularity 
    temp = 0.0; % Set the temp gain
    
    % Sum up the gain from all antenna elements
    for antenna_element_ = 0: num_vertical_antenna_element_in_column - 1 % Each vertical antenna element
        temp_angle = exp(1j * 2 * pi / w_lambda * antenna_element_ * dv * cos(vertical_angle_ / 180 * pi));
        temp_etilt = exp(-1j * 2 * pi / w_lambda * mod(antenna_element_, num_vertical_antenna_element_in_TXRU_sub_connection) * dv * cos(analog_beam_angle_1 / 180 * pi)); % Use one analog beam angle
        temp = temp + temp_angle * temp_etilt * sqrt(10.^(AntennaElementGainV(vertical_angle_ + abs(min(vertical_granularity)) + 1) / 10));
    end;
    
    % Average over all antenna elements
    w_total = abs(temp)^2 / num_vertical_antenna_element_in_column;
    
    % Calculate the gain without codebook
    SubConnectionGain(vertical_angle_ + abs(min(vertical_granularity)) + 1) = 10 * log10(w_total);
end


%% The end of this script
% Jeffrey && William

