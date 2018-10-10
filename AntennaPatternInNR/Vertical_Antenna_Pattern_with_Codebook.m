%% All right, let us start from antenna pattern
%close all;
clc;

%% Define parameters
quan_num = 8; %Num of vertical codebook

angle_first = 80;
angle_last = 120;
ant_K = 4; % Number of vertical antenna elements in each TXRU

theta_3dB_2D = 70.0;
ver_3dB_2D = 15.0;
SLAv_2D = 20.0;
Am_2D = 20.0;
tilt_v_2D = 12.0;

theta_3dB_3D = 65.0;
SLAv = 30.0;
Am_3D = 30.0;

K_factor = 8; %Number of vertical antenna elements
down_tilt_angle = 100.0;

w_lambda = 3e8 / 2e9;
dv = 0.8 * w_lambda;

%Set the initial value
GAIN = zeros(180, 1);
Antenna_Gain_without_Codebook = zeros(180, 1);

%% Calculate the 3D antenna pattern
for angle_UE = 1: 180 %Check the vertical angle from 1 to 180 degree
    w_total = 0.0;
    gain_v = max(-12.0 * ((angle_UE - 90) / theta_3dB_3D)^2.0, -SLAv); %Vertical antenna gain w/o beamforming
    GAIN(angle_UE) = max(gain_v, -Am_3D) + 8;
    Antenna_Gain_without_Codebook(angle_UE) = GAIN(angle_UE);
    
    for Num_VCB = 0: quan_num - 1 %Each vertical codeword
        temp = 0.0;
        angle = angle_first + (angle_last - angle_first) / quan_num * Num_VCB; %Get the angle associated with the vertical codebook
        
        for wid = 0: K_factor - 1 %Each vertical antenna element 
            temp = temp + exp(1j * (2 * pi * (wid * dv * cos(angle_UE / 180 * pi) - mod(wid, ant_K) *  dv  * cos(down_tilt_angle / 180 * pi) - floor(wid / ant_K) * ant_K * dv * cos(angle / 180 * pi)) / w_lambda));
        end
        
        %Antenna gain
        temp_total = abs(temp)^2 / K_factor;
        
        %Find the maximum antenna gain among vertical codebook
        if (temp_total > w_total)
            w_total = temp_total;
        end
    end
    
    GAIN(angle_UE) = GAIN(angle_UE) + 10 * log10(w_total);
end


%% Plots
ANGLE_UE = 1: 180;

plot(ANGLE_UE, GAIN, 'r');
hold on;
grid on;

plot(ANGLE_UE, Antenna_Gain_without_Codebook, 'b');

xlabel('Vertical degree');
ylabel('Tx power in dBm');
ylim([-60, 20]);


%% The end of this script
% Jeffrey Cao in SCRL