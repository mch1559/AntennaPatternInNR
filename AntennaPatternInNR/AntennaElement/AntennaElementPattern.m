function [AntennaElementGainH, AntennaElementGainV, AntennaElementGain3D] = AntennaElementPattern(horizontal_granularity, vertical_granularity)
%AntennaElementPattern3DPlot: given the 3D antenna gain, plot the pattern as expected
%   In details


%% Get the parameters
length_of_vertical = length(vertical_granularity);
length_of_horizontal = length(horizontal_granularity);


%% Get the antenna element gain in Horizontal and Vertical domain
AntennaElementGainH = zeros(1, length_of_horizontal);
for phi_ = horizontal_granularity
    AntennaElementGainH(phi_+ abs(min(horizontal_granularity)) + 1) = AntennaElementHorizontalPattern(phi_);
end

AntennaElementGainV = zeros(1, length_of_vertical);
for theta_ = vertical_granularity
    AntennaElementGainV(theta_+ abs(min(vertical_granularity)) + 1) = AntennaElementVerticalPattern(theta_);
end


%% Get the antenna element gain in 3D
AntennaElementGain3D = zeros(length_of_vertical, length_of_horizontal);
for theta_ = vertical_granularity
    for phi_ = horizontal_granularity
        AntennaElementGain3D(theta_ + abs(min(vertical_granularity)) + 1, phi_ + abs(min(horizontal_granularity)) + 1) = AntennaElement3DPattern(theta_, phi_);
    end
end


%% Plot antenna pattern of AE for observation purpose
antenna_element_pattern_plot = 0;
if antenna_element_pattern_plot == 1
    AntennaElementPatternPlot(AntennaElementGainH, AntennaElementGainV, AntennaElementGain3D, horizontal_granularity, vertical_granularity);
end


end