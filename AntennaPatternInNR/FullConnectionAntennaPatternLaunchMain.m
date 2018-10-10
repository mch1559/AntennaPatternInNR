%% Jianfei (Jeffrey) CAO 
% Wireless Network Research Department (WNRD) 
% Sony China Research Lab. (SCRL)
% Sony (China) Ltd.
% Jan. 13rd 2017


%% Main lunch function for full-connection in 1D antenna patterns
% The purpose of this code lies in two ways
%       A: Check the 2 analog beams in full-connection model
%       B: Compare the beamforming gain between sub-connection and full-connection model
% Note 1: in this code, we only consider the vertical domain with single
% column of antenna elements
% Note 2: in this code, we only consider analog beam, thereby no vertical
% codebook is in need
close all;
clc;
opengl hardwarebasic; % Open GL for figures


%% Set the parameters
% Full connection: (M, N, P, Q) = (8, 1, 1, 1); 
% Sub connection: (M, N, P, Q) = (8, 1, 1, 2); 
global antenna_array_type; % antenna array type to either 'ULA' or 'Xpol'
global num_vertical_antenna_element_in_TXRU; % Number of vertical antenna elements in each TXRU
global num_vertical_antenna_element_in_TXRU_sub_connection; % Number of vertical antenna elements in each TXRU
global num_vertical_antenna_element_in_column; % Number of vertical antenna elements
global w_lambda;
global dv;
global vertical_granularity;
global analog_beam_angle_1;
global analog_beam_angle_2;


%% Antenna layout: 2D antenna layout
% Note: Assume phisical tile 90 degree? Thus don't need to care
% Note: The antenna array is layout in the Y-Z plan in 3D coordinate
antenna_array_type = 'ULA'; % Set the antenna array type to either 'ULA' or 'Xpol'

% Consider the full-connection model, we set 8 AEs in column and 8 AEs in TXRU
num_vertical_antenna_element_in_TXRU = 8; % Number of vertical antenna elements in each TXRU
num_vertical_antenna_element_in_column = 8; % Number of vertical antenna elements
num_vertical_antenna_element_in_TXRU_sub_connection = 4; % Number of vertical antenna elements in each TXRU for sub-connection

w_lambda = 3e8 / 2e9; % Wavelength
dv = 0.8 * w_lambda; % Vertical antenna element distance
vertical_granularity = -90: 1: 270; % Set the observation range

% Set two analog beam angle
analog_beam_angle_1 = 120;
analog_beam_angle_2 = 60;

% Error check on full-connection setting
if num_vertical_antenna_element_in_column ~= num_vertical_antenna_element_in_TXRU
    disp('Error on antenna array setting in FullConnectionAntennaPatternLaunchMain( )');
end

%% Calculate single antenna element pattern in: V
length_of_vertical = length(vertical_granularity);
AntennaElementGainV = zeros(1, length_of_vertical);
for theta_ = vertical_granularity
    AntennaElementGainV(theta_+ abs(min(vertical_granularity)) + 1) = AntennaElementVerticalPattern(theta_);
end

%% Calculate mutlple antenna element pattern in: V
[FullConnectionGain, FullConnectionGain2, FullConnectionCombineGain, SubConnectionGain] = FullConnectionVerticalAntennaPattern(AntennaElementGainV);

% Plot V-domain figures
antenna_array_pattern_v_plot = 1;
if antenna_array_pattern_v_plot == 1
    FullConnectionAntennaArrayPatternVPlot(FullConnectionGain, FullConnectionGain2, FullConnectionCombineGain, SubConnectionGain, AntennaElementGainV);
end


%% Observations and notes
% Obs. 1: In fact, full-connection mode is not able to output multiple independent beams
%       simultaneously, since the combined-beam sidelobe performance is worse than
%       independent-beam sidelobe. That could be the reason why
%       multiple-beam-sweeping-in-one-symbol cannot be done;
% Obs. 2: full-connection mode outperforms sub-connection model at non-90 degree


%% The end of this main function
% By Jeffrey and William

