%% Jianfei (Jeffrey) CAO 
% Wireless Network Research Department (WNRD) 
% Sony China Research Lab. (SCRL)
% Sony (China) Ltd.
% July 7th 2016


%% Main lunch function for antenna patterns
close all;
clc;

opengl hardwarebasic; % Open GL for figures

%% Set the parameters
% (M, N, P, Q) = (8, 8, 2, 16)
global antenna_array_type; % antenna array type to either 'ULA' or 'Xpol'
global num_vertical_codebook; % Num of vertical codebook
global num_vertical_antenna_element_in_TXRU; % Number of vertical antenna elements in each TXRU
global num_vertical_antenna_element_in_column; %Number of vertical antenna elements
global num_horizontal_codebook; % Num of horizontal codebook
global num_horizontal_antenna_element_in_TXRU; % Number of horizontal antenna elements in each TXRU
global num_horizontal_antenna_element_in_row; %Number of horizontal antenna elements
global down_tilt_angle;
global w_lambda;
global dv;
global dh;
global vertical_granularity;
global horizontal_granularity;
global num_co_phase; 


%% Antenna layout: 2D antenna layout
% Note: Assume phisical tile 90 degree? Thus don't need to care
% Note: The antenna array is layout in the Y-Z plan in 3D coordinate
antenna_array_type = 'Xpol'; % Set the antenna array type to either 'ULA' or 'Xpol'

num_vertical_codebook = 8; % Num of vertical codebook
num_vertical_antenna_element_in_TXRU = 4; % Number of vertical antenna elements in each TXRU
num_vertical_antenna_element_in_column = 8; % Number of vertical antenna elements

num_horizontal_antenna_element_in_TXRU = 1; % Number of horizontal antenna elements in each TXRU
if strcmp(antenna_array_type, 'ULA') == 1
    num_horizontal_codebook = 16; % Num of horizontal codebook
    num_horizontal_antenna_element_in_row = 4; % Number of horizontal antenna elements
elseif strcmp(antenna_array_type, 'Xpol') == 1
    num_horizontal_codebook = 16 * 4; % Num of horizontal codebook * # of co-phase
    num_horizontal_antenna_element_in_row = 8; % Number of horizontal antenna elements
else
    disp('Error on antenna array setting in AntennaPatternLaunchMain( )');
end

num_co_phase = 4; % According to Codebook Configuration defined in 36.213
down_tilt_angle = 60.0; % Electrical antenna down tile 
w_lambda = 3e8 / 2e9; % Wavelength
dv = 0.8 * w_lambda; % Vertical antenna element distance
dh = 0.5 * w_lambda; % Horizontal antenna element distance

% Set the observation range
vertical_granularity = -90: 1: 270;
horizontal_granularity = -180: 1: 180;


%% DFT vector based Codebook
[W_V, W_H, W_H_Xpol, W_CB, N1, O1] = DFTCodebook( );

%% Calculate single antenna element pattern in: H/V/3D
[AntennaElementGainH, AntennaElementGainV, AntennaElementGain3D] = AntennaElementPattern(horizontal_granularity, vertical_granularity);

%% Calculate mutlple antenna element pattern in: H/V/3D
AntennaArrayPattern(AntennaElementGainH, AntennaElementGainV, AntennaElementGain3D, W_V, W_H, W_H_Xpol, W_CB, N1, O1);

%% What is next?
% A. 3D channel model?
% B. Other complicated codebook configuration to be considered
% C. ...

%% The end of this main function
% By Jeffrey CAO 

