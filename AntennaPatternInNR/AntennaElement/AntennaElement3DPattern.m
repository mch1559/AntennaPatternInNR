function [ AntennaElementGain3D ] = AntennaElement3DPattern(theta, phi)
% AntennaPattern3D: Get the antenna gain in 3D
%   In details

%% Set the fixed parameters
theta_3dB_3D = 65.0;
SLAv = 30.0;
Am_3D = 30.0;

%% Calculate the antenna gain when given theta and phi
% According to 36.897
A_EV_theta = -min(12 * ((theta - 90) / theta_3dB_3D )^2, SLAv);
A_EH_phi = -min(12 * (phi / theta_3dB_3D)^2, Am_3D);
A_theta_phi = -min(-(A_EV_theta + A_EH_phi), Am_3D);
AntennaElementGain3D = A_theta_phi + 8;

end

