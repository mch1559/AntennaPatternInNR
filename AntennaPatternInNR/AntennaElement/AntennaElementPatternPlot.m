function [ ] = AntennaElementPatternPlot(AntennaElementGainH, AntennaElementGainV, AntennaElementGain3D, horizontal_granularity, vertical_granularity)
%AntennaElementPattern3DPlot: given the 3D antenna gain, plot the pattern as expected
%   In details


%% Plots
% Horizontal gain
figure(1);
plot(horizontal_granularity, AntennaElementGainH, 'b');
grid on;
xlabel('Horizontal degree');
ylabel('Antenna Gain in dB');
%ylim([-30, 10]);

% Vertical gain
figure(2);
plot(vertical_granularity, AntennaElementGainV, 'r');
grid on;
xlabel('Vertical degree');
ylabel('Antenna Gain in dBm');
%xlim([0, 180]);
%ylim([-60, 20]);

% 3D gain
figure(3);
mesh(horizontal_granularity, vertical_granularity, AntennaElementGain3D);
xlabel('Horizontal Degree');
ylabel('Vertical Degree');
zlabel('Antenna Gain in 3D');


%% Notes
% Note 1: when considering only one domain, either V or H, assume the gain from other domain is 0;

end

