function [ ] = AntennaArrayPatternHPlot(GAIN_CB, GAIN_WO_CB, GAIN_WO_CB_NP, GAIN_CB_BEAM, AntennaElementGainH)
%AntennaArrayPatternHPlot: Plot the antenna array pattern in the horizontal domain
%   In details


%% Set the global variables
global horizontal_granularity;
global num_horizontal_codebook;


%% Plots
figure;
plot(horizontal_granularity, GAIN_WO_CB, 'b');
hold on;
grid on;
plot(horizontal_granularity, GAIN_CB, 'g');
plot(horizontal_granularity, GAIN_WO_CB_NP, 'bo');
plot(horizontal_granularity, AntennaElementGainH, 'k');

xlabel('Horizontal Degree');
ylabel('Horizontal Antenna Gain');
ylim([-10, 20]);
legend({'Without HCB', 'With Best HCB', 'Without HCB, Power Norm', 'Single AE'}, 'Location', 'NorthWest');

%%
figure;
% Get the color for plot
color = get(gca, 'ColorOrder');
color(8, :, :) = [0, 0, 1]; % Get the 8th color
color(9: 15, :, :) = get(gca, 'ColorOrder');
color(16, :, :) = [0, 0, 1]; % Get the 16th color

for horizontal_codebook_ = 1: num_horizontal_codebook
    if horizontal_codebook_ <= 16
        plot(horizontal_granularity, GAIN_CB_BEAM(horizontal_codebook_, :), 'color', color(horizontal_codebook_, :));
    else
        plot(horizontal_granularity, GAIN_CB_BEAM(horizontal_codebook_, :));   
    end
    hold on;
    grid on;
end

xlabel('Horizontal degree');
ylabel('Antenna Gain of Different HCB');
xlim([-180, 180]);
ylim([-60, 20]);
legend({'HCB 1', 'HCB 2', 'HCB 3', 'HCB 4'}, 'Location', 'NorthWest');


%%
figure;
PositiveGainWCB = find(GAIN_CB > 0);
PositiveGainWOCB = find(GAIN_WO_CB > 0);
PositiveGainWOCBNP = find(GAIN_WO_CB_NP > 0);
PositiveGainH = find(AntennaElementGainH > 0);

polar(horizontal_granularity(PositiveGainWCB)/180*pi, GAIN_CB(PositiveGainWCB), 'g');
hold on;
polar(horizontal_granularity(PositiveGainWOCB)/180*pi, GAIN_WO_CB(PositiveGainWOCB), 'b');
polar(horizontal_granularity(PositiveGainWOCBNP)/180*pi, GAIN_WO_CB_NP(PositiveGainWOCBNP), 'bo');
polar(horizontal_granularity(PositiveGainH)/180*pi, AntennaElementGainH(PositiveGainH), 'k');
legend({'With Best HCB', 'Without HCB', 'Without HCB, With Power Normalization', 'Single AE'}, 'Location', 'SouthWest');


%%
figure;
for horizontal_codebook_ = 1: num_horizontal_codebook
    PositiveGainCBBeam = find(GAIN_CB_BEAM(horizontal_codebook_, :) > 0);
    polar(horizontal_granularity(PositiveGainCBBeam)/180*pi, GAIN_CB_BEAM(horizontal_codebook_, PositiveGainCBBeam), 'k');
    hold on;
end
legend({'Antenna Gain with Numerous Horizontal Beams'}, 'Location', 'South');


end

