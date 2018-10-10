function [ ] = AntennaArrayPattern3DPlot(GAIN_3D, GAIN_3D_BEAM, AntennaElementGain3D)
%AntennaArrayPattern3DPlot: Plot antenna array pattern in 3D
%   In details


%% Set variables for plot
global horizontal_granularity;
global vertical_granularity;


%% 3D gain
figure;
mesh(horizontal_granularity, vertical_granularity, AntennaElementGain3D);
xlabel('Horizontal Degree');
ylabel('Vertical Degree');
zlabel('Antenna Gain in 3D');

figure;
mesh(horizontal_granularity, vertical_granularity, GAIN_3D);
xlabel('Horizontal Degree');
ylabel('Vertical Degree');
zlabel('Antenna Gain in 3D');
zlim([-25, 25]);

figure;
for n_ = 1: 1
    mesh(horizontal_granularity, vertical_granularity, squeeze(GAIN_3D_BEAM(1, 1, n_, :, :)));
end
xlabel('Horizontal Degree');
ylabel('Vertical Degree');
zlabel('Antenna Gain in 3D');
zlim([-25, 25]);

% Plot antenna pattern in spherical-polar coordinates
% Permute the antenna pattern matrix
GAIN_3D_Short = GAIN_3D(:, 1: 181);
GAIN_3D_Short_Tran = GAIN_3D_Short.';
%Unit = 'db';
AntResp = phased.internal.DirectivityPattern3D('Pattern', GAIN_3D_Short_Tran, 'AzAngle', horizontal_granularity.', 'ElAngle', vertical_granularity(1: 181).');
figure;
polar(AntResp, 'Units', 'db', 'NormalizeResp', false);


end

