function [ ] = FullConnectionAntennaArrayPatternVPlot(FullConnectionGain, FullConnectionGain2, FullConnectionCombineGain, SubConnectionGain, AntennaElementGainV)
%AntennaArrayPatternVPlot: Plot the antenna array pattern in vertical domain
%   In details

%% Set global variables
global vertical_granularity;

%% Plot figures
figure;
plot(vertical_granularity, FullConnectionGain, 'go-');
hold on;
grid on;
plot(vertical_granularity, FullConnectionGain2, 'r');
plot(vertical_granularity, FullConnectionCombineGain, 'b');
plot(vertical_granularity, SubConnectionGain, 'y');
plot(vertical_granularity, AntennaElementGainV, 'k');

xlabel('Vertical degree');
ylabel('Vertical Antenna Gain');
ylim([-10, 20]);
legend({'FullConnectionGain', 'FullConnectionGain2', 'FullConnectionCombineGain', 'SubConnectionGain', 'Single AE'}, 'Location', 'NorthWest');


%% Polar figures
figure;
PositiveFullConnectionGain = find(FullConnectionGain > 0);
PositiveFullConnectionGain2 = find(FullConnectionGain2 > 0);
PositiveFullConnectionCombineGain = find(FullConnectionCombineGain > 0);
PositiveVerticalGain = find(AntennaElementGainV > 0);
PositiveSubConnectionGain = find(SubConnectionGain > 0);

polar(vertical_granularity(PositiveFullConnectionGain)/180*pi, FullConnectionGain(PositiveFullConnectionGain), 'g');
hold on;
polar(vertical_granularity(PositiveFullConnectionGain2)/180*pi, FullConnectionGain2(PositiveFullConnectionGain2), 'r');
polar(vertical_granularity(PositiveFullConnectionCombineGain)/180*pi, FullConnectionCombineGain(PositiveFullConnectionCombineGain), 'b');
polar(vertical_granularity(PositiveSubConnectionGain)/180*pi, SubConnectionGain(PositiveSubConnectionGain), 'y');
polar(vertical_granularity(PositiveVerticalGain)/180*pi, AntennaElementGainV(PositiveVerticalGain), 'k');

legend({'FullConnectionGain', 'FullConnectionGain2', 'FullConnectionCombineGain', 'SubConnectionGain', 'Single AE'}, 'Location', 'SouthWest');

end

