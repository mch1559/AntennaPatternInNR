function [GAIN_3D, GAIN_3D_BEAM] = FullDimensionAntennaPattern(AntennaElementGain3D, W_CB, N1, O1)
%AntennaPattern3D: Calculate the antenna array pattern in 3D
%   In details


%% Define parameters
% % Antenna layout setting
global down_tilt_angle; % electrical down tile
global w_lambda; % Wavelength
%global num_vertical_codebook; % Num of vertical codebook
global num_vertical_antenna_element_in_TXRU; % Number of vertical antenna elements in each TXRU
global num_vertical_antenna_element_in_column; %Number of vertical antenna elements
global dh; % horizontal antenna element distance
global dv; % vertical antenna element distance
%global num_horizontal_codebook; % Num of horizontal codebook
global num_horizontal_antenna_element_in_TXRU; % Number of horizontal antenna elements in each TXRU
global num_horizontal_antenna_element_in_row; %Number of horizontal antenna elements
global vertical_granularity;
global horizontal_granularity;
global num_horizontal_codebook;
global num_vertical_codebook;
global num_co_phase;

% Initialize the antenna array gain
MatrixSizeTemp = size(AntennaElementGain3D);
GAIN_3D = zeros(size(AntennaElementGain3D));
GAIN_3D_BEAM = zeros(num_horizontal_codebook, num_vertical_codebook, num_co_phase, MatrixSizeTemp(1, 1), MatrixSizeTemp(1, 2));

%fd_codebook_format = 3;

%% Calculate the antenna pattern without codebook
for horizontal_angle_ = horizontal_granularity
    for vertical_angle_ = vertical_granularity
        % Set the temp gain
        temp = 0.0; 
        
        % Sum up the gain from all antenna elements
        for antenna_element_v_ = 0: num_vertical_antenna_element_in_column - 1 % Each vertical antenna element
            for antenna_element_h_ = 0: num_horizontal_antenna_element_in_row - 1 % Each horizontal antenna element
                temp_angle_v = exp(1j * 2 * pi / w_lambda * antenna_element_v_ * dv * cos(vertical_angle_ / 180 * pi));
                temp_angle_h = exp(1j * 2 * pi / w_lambda * antenna_element_h_ * dh * sin(horizontal_angle_ / 180 * pi));
                temp_etilt = 1 / sqrt(num_vertical_antenna_element_in_TXRU) * exp(-1j * 2 * pi / w_lambda * mod(antenna_element_v_, num_vertical_antenna_element_in_TXRU) * dv * cos(down_tilt_angle / 180 * pi));
                temp_codebook_v = 1 / sqrt(num_vertical_antenna_element_in_column / num_vertical_antenna_element_in_TXRU);
                temp_codebook_h = 1 / sqrt(num_horizontal_antenna_element_in_row / num_horizontal_antenna_element_in_TXRU);
                temp = temp + temp_angle_v * temp_angle_h * temp_etilt * temp_codebook_v * temp_codebook_h * sqrt(10.^(AntennaElementGain3D(horizontal_angle_ + abs(min(horizontal_granularity)) + 1, vertical_angle_ + abs(min(vertical_granularity)) + 1) / 10));
            end
        end;
        
        % Average over all antenna elements
        w_total = abs(temp)^2;
        
        % Calculate the gain without codebook
        GAIN_3D(horizontal_angle_ + abs(min(horizontal_granularity)) + 1, vertical_angle_ + abs(min(vertical_granularity)) + 1) = 10 * log10(w_total);
    end
end


%% Calculate the antenna pattern with codebook
CheckFullAntennaPatternON = 1; % Normally set the off for saving simulation time

if CheckFullAntennaPatternON == 1
%     for i_11 = 1: N1 * O1
%         for i_12 = 1: num_vertical_codebook
%             for i_2 = 1: num_co_phase
    for i_11 = 1: 1
        for i_12 = 1: 1
            for i_2 = 1: 1
                for horizontal_angle_ = horizontal_granularity
                    for vertical_angle_ = vertical_granularity
                        % Set the temp gain
                        temp = 0.0;
                        
                        % Sum up the gain from all antenna elements
                        for antenna_element_v_ = 0: num_vertical_antenna_element_in_column - 1 % Each vertical antenna element
                            for antenna_element_h_ = 0: num_horizontal_antenna_element_in_row - 1 % Each horizontal antenna element
                                temp_angle_v = exp(1j * 2 * pi / w_lambda * antenna_element_v_ * dv * cos(vertical_angle_ / 180 * pi));
                                temp_angle_h = exp(1j * 2 * pi / w_lambda * antenna_element_h_ * dh * sin(horizontal_angle_ / 180 * pi));
                                temp_etilt = 1 / sqrt(num_vertical_antenna_element_in_TXRU) * exp(-1j * 2 * pi / w_lambda * mod(antenna_element_v_, num_vertical_antenna_element_in_TXRU) * dv * cos(down_tilt_angle / 180 * pi));
                                temp_codebook = W_CB(i_11, i_12, i_2, antenna_element_h_ * (num_vertical_antenna_element_in_column / num_vertical_antenna_element_in_TXRU) + floor(antenna_element_v_ / num_vertical_antenna_element_in_TXRU) + 1);
                                temp_codebook_v = 1 / sqrt(num_vertical_antenna_element_in_column / num_vertical_antenna_element_in_TXRU);
                                temp_codebook_h = 1 / sqrt(num_horizontal_antenna_element_in_row / num_horizontal_antenna_element_in_TXRU);
                                temp = temp + temp_angle_v * temp_angle_h * temp_etilt * temp_codebook * temp_codebook_v * temp_codebook_h * sqrt(10.^(AntennaElementGain3D(horizontal_angle_ + abs(min(horizontal_granularity)) + 1, vertical_angle_ + abs(min(vertical_granularity)) + 1) / 10));
                            end
                        end;
                        
                        % Average over all antenna elements
                        w_total = abs(temp)^2;
                        
                        % Calculate the gain without codebook
                        GAIN_3D_BEAM(i_11, i_12, i_2, horizontal_angle_ + abs(min(horizontal_granularity)) + 1, vertical_angle_ + abs(min(vertical_granularity)) + 1) = 10 * log10(w_total);
                    end
                end
            end
        end
    end
end


end

