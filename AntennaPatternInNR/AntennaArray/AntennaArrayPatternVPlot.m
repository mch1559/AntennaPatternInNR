function [ ] = AntennaArrayPatternVPlot(GAIN_CB, GAIN_WO_CB, GAIN_WO_CB_NP, GAIN_CB_BEAM, AntennaElementGainV)
%AntennaArrayPatternVPlot: Plot the antenna array pattern in vertical domain
%   In details


%% Set global variables
global vertical_granularity;
global num_vertical_codebook;


%% Plots
figure;
plot(vertical_granularity, GAIN_CB, 'g');
hold on;
grid on;
plot(vertical_granularity, GAIN_WO_CB, 'b');
plot(vertical_granularity, GAIN_WO_CB_NP, 'bo');
plot(vertical_granularity, AntennaElementGainV, 'k');
xlabel('Vertical degree');
ylabel('Vertical Antenna Gain');
ylim([-10, 20]);
legend({'With Best VCB', 'Without VCB', 'Without VCB, With Power Normalization', 'Single AE'}, 'Location', 'NorthWest');


%%
figure;
% Get the color for plot
color = get(gca, 'ColorOrder');
color(8, :, :) = [0, 0, 1]; % Get the 8th color

for vertical_codebook_ = 1: num_vertical_codebook
    plot(vertical_granularity, GAIN_CB_BEAM(vertical_codebook_, :), 'color', color(vertical_codebook_, :));
    hold on;
    grid on;
end
xlabel('Vertical degree');
ylabel('Antenna Gain of Different VCB');
xlim([-90, 270]);
ylim([-60, 20]);
legend({'VCB 1', 'VCB 2', 'VCB 3', 'VCB 4'}, 'Location', 'NorthWest');


%%
figure;
PositiveGainWCB = find(GAIN_CB > 0);
PositiveGainWOCB = find(GAIN_WO_CB > 0);
PositiveGainWOCBNP = find(GAIN_WO_CB_NP > 0);
PositiveGainV = find(AntennaElementGainV > 0);

polar(vertical_granularity(PositiveGainWCB)/180*pi, GAIN_CB(PositiveGainWCB), 'g');
hold on;
polar(vertical_granularity(PositiveGainWOCB)/180*pi, GAIN_WO_CB(PositiveGainWOCB), 'b');
polar(vertical_granularity(PositiveGainWOCBNP)/180*pi, GAIN_WO_CB_NP(PositiveGainWOCBNP), 'bo');
polar(vertical_granularity(PositiveGainV)/180*pi, AntennaElementGainV(PositiveGainV), 'k');
legend({'With Best VCB', 'Without VCB', 'Without VCB, With Power Normalization', 'Single AE'}, 'Location', 'SouthWest');


%%
figure;
for vertical_codebook_ = 1: num_vertical_codebook
    PositiveGainCBBeam = find(GAIN_CB_BEAM(vertical_codebook_, :) > 0);
    polar(vertical_granularity(PositiveGainCBBeam)/180*pi, GAIN_CB_BEAM(vertical_codebook_, PositiveGainCBBeam), 'k');
    hold on;
end
legend({'Antenna Gain with Numerous Vertical Beams'}, 'Location', 'South');


end

