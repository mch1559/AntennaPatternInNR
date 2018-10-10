function [ AntennaElementHorizontalGain ] = AntennaElementHorizontalPattern(phi)
% AntennaPatternHorizontalGain: Get the antenna gain in horizontal domain
%   In details

%% Set the fixed parameters
theta_3dB_3D = 65.0;
%SLAv = 30.0;
Am_3D = 30.0;

%% Calculate the antenna gain when given theta and phi
% According to 36.897

% When considering Horizontal domain gain, assuming zero vertical domain gain
%A_EV_theta = -min(12 * ((theta - 90) / theta_3dB_3D )^2, SLAv);
A_EV_theta = 0;

A_EH_phi = -min(12 * (phi / theta_3dB_3D)^2, Am_3D);
A_theta_phi = -min(-(A_EV_theta + A_EH_phi), Am_3D);
AntennaElementHorizontalGain = A_theta_phi + 8;

end



