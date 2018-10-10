function [GAIN_CB, GAIN_WO_CB, GAIN_WO_CB_NP, GAIN_CB_BEAM] = HorizontalAntennaPattern(AntennaElementGainH, W_H, W_H_Xpol)
%HorizontalAntennaPattern: 
%   Calculate the horizontal anntenna pattern and draw figure for better understanding
%   A: Self-defined codebook (different from 3GPP Rel.13)
%   B: Rel.13 defined horizontal codebook
%
%Detailed explanation:
%    Output: antenna gain
%Note 1: 1D sub-array partition model (TXRU virtualization model option-1) in 3GPP TR.36.897
%Note 2: Remember there is also electric down-tile for every AE, however,
%let k = 1 in analogy precoder element, we notice that w_k = 1 and ignore it for brevity


%% Define parameters
% % Antenna layout setting
global num_horizontal_codebook; % Num of horizontal codebook
global num_horizontal_antenna_element_in_TXRU; % Number of horizontal antenna elements in each TXRU
global num_horizontal_antenna_element_in_row; %Number of horizontal antenna elements
%global down_tilt_angle; % electrical down tile
global w_lambda; % Wavelength
global dh; % horizontal antenna element distance
%global dv; % vertical antenna element distance
global horizontal_granularity;
global antenna_array_type;


% First, get the horizontal antenna element gain
GAIN_CB = zeros(size(AntennaElementGainH));
GAIN_WO_CB = zeros(size(AntennaElementGainH));
GAIN_WO_CB_NP = zeros(size(AntennaElementGainH));
GAIN_CB_BEAM = zeros(num_horizontal_codebook, length(AntennaElementGainH));


%% Calculate the horizontal antenna pattern with self-defined horizontal codebook
horizontal_codebook_format = 3;
angle_first = 0;
angle_last = 360;
if num_horizontal_codebook == 4
    horizontal_codebook_set = [60, 90, 125, 150]; % the length of this set should be num_horizontal_codebook
elseif num_horizontal_codebook == 8
    horizontal_codebook_set = [-45, -30, -15, 0, 15, 30, 45, 60];
end

for horizontal_angle_ = horizontal_granularity
    % Set the total gain 
    w_total = 0.0;
    
    % Each horizontal codeword
    for horizontal_codebook_ = 0: num_horizontal_codebook - 1 
        temp = 0.0; % Set the temp gain for each codebook
        
        % Get the angle associated with the horizontal codebook
        if horizontal_codebook_format == 1
            angle_codebook = angle_first + (angle_last - angle_first) / num_horizontal_codebook * horizontal_codebook_; 
        elseif horizontal_codebook_format == 2
            angle_codebook = horizontal_codebook_set(horizontal_codebook_ + 1);
        elseif horizontal_codebook_format == 3
            % Use the horizontal codebook from 3GPP
        end
        
        % Sum up the gain from all antenna elements
        for antenna_element_ = 0: num_horizontal_antenna_element_in_row - 1 % Each horizontal antenna element
            temp_angle = exp(1j * 2 * pi / w_lambda * antenna_element_ * dh * sin(horizontal_angle_ / 180 * pi));
            %temp_etilt = exp(-1j * 2 * pi / w_lambda  * dv * cos(down_tilt_angle / 180 * pi)); % Considering the 2nd (k=1) row of AE
            
            % Get the horizontal codebook
            if horizontal_codebook_format == 1 || horizontal_codebook_format == 2
                temp_codebook = exp(-1j * 2 * pi / w_lambda * antenna_element_ * dh * sin(angle_codebook / 180 * pi)); 
            elseif horizontal_codebook_format == 3                
                if strcmp(antenna_array_type, 'ULA') == 1
                    temp_codebook = W_H(horizontal_codebook_ + 1, antenna_element_ + 1);
                elseif strcmp(antenna_array_type, 'Xpol') == 1
                    temp_codebook = W_H_Xpol(horizontal_codebook_ + 1, antenna_element_ + 1);
                end                
            end
            
            temp_antenna_element_gain = sqrt(10.^(AntennaElementGainH(horizontal_angle_ + abs(min(horizontal_granularity)) + 1) / 10));
            %temp = temp + temp_angle * temp_codebook * temp_etilt * temp_antenna_element_gain;
            temp = temp + temp_angle * temp_codebook * temp_antenna_element_gain;
        end
        
        % Average over all antenna elements
        temp_total = abs(temp)^2 / num_horizontal_antenna_element_in_row;
        
        % Find the maximum antenna gain among horizontal codebook
        if (temp_total > w_total)
            w_total = temp_total;
        end;
    end;
    
    % Convert the gain in linear-scale to dB-scale
    GAIN_CB(horizontal_angle_ + abs(min(horizontal_granularity)) + 1) = 10 * log10(w_total);
end;
% Note: the same analog precoder of each AE has no effect over horizontal antenna pattern


%% Calculate the horizontal antenna gain with numerous beams
for horizontal_codebook_ = 0: num_horizontal_codebook - 1 
%for horizontal_codebook_ = [(0: 3) (20: 23)] % Let us check the first beam group including num_co_phase beams
    % Get the angle associated with the horizontal codebook
    if horizontal_codebook_format == 1
        angle_codebook = angle_first + (angle_last - angle_first) / num_horizontal_codebook * horizontal_codebook_;
    elseif horizontal_codebook_format == 2
        angle_codebook = horizontal_codebook_set(horizontal_codebook_ + 1);
    elseif horizontal_codebook_format == 3
        % Use the horizontal antenna codebook from 3GPP
    end
    
    for horizontal_angle_ = horizontal_granularity
        % Each horizontal codeword
        temp = 0.0; % Set the temp gain for each codebook
        
        % Sum up the gain from all antenna elements
        for antenna_element_ = 0: num_horizontal_antenna_element_in_row - 1 % Each horizontal antenna element
            temp_angle = exp(1j * 2 * pi / w_lambda * antenna_element_ * dh * sin(horizontal_angle_ / 180 * pi));
            % temp_etilt = exp(-1j * 2 * pi / w_lambda  * dh * cos(down_tilt_angle / 180 * pi));  % Same analog precoder in H-domain, thus has no impact over H-domain 
            
            % Get the horizontal codebook
            if horizontal_codebook_format == 1 || horizontal_codebook_format == 2
                temp_codebook = exp(-1j * 2 * pi / w_lambda * antenna_element_ * dh * sin(angle_codebook / 180 * pi)); % Considering the 2nd (k=1) row of AE
            elseif horizontal_codebook_format == 3
                if strcmp(antenna_array_type, 'ULA') == 1
                    temp_codebook = W_H(horizontal_codebook_ + 1, antenna_element_ + 1);
                elseif strcmp(antenna_array_type, 'Xpol') == 1
                    temp_codebook = W_H_Xpol(horizontal_codebook_ + 1, antenna_element_ + 1);
                end
            end
            
            temp_antenna_element_gain = sqrt(10.^(AntennaElementGainH(horizontal_angle_ + abs(min(horizontal_granularity)) + 1) / 10));
            temp = temp + temp_angle * temp_codebook * temp_antenna_element_gain;
        end
        
        % Average over all antenna elements
        w_total = abs(temp)^2 / num_horizontal_antenna_element_in_row;
        
        % Convert the gain in linear-scale to dB-scale
        GAIN_CB_BEAM(horizontal_codebook_ + 1, horizontal_angle_ + abs(min(horizontal_granularity)) + 1) = 10 * log10(w_total);
    end;
end;
% Note that the W2 feedback of co-phase part do select one beam of the beam group


%% Calculate the horizontal antenna pattern without horizontal codebook
for horizontal_angle_ = horizontal_granularity
    temp = 0.0; % Set the temp gain
    
    % Sum up the gain from all antenna elements
    for antenna_element_ = 0: num_horizontal_antenna_element_in_row - 1 % Each horizontal antenna element
        temp_angle = exp(1j * 2 * pi / w_lambda * antenna_element_ * dh * sin(horizontal_angle_ / 180 * pi));
        %temp_etilt = exp(-1j * 2 * pi / w_lambda * mod(antenna_element_, num_vertical_antenna_element_in_TXRU) * dv * cos(down_tilt_angle / 180 * pi));
        temp = temp + temp_angle * sqrt(10.^(AntennaElementGainH(horizontal_angle_ + abs(min(horizontal_granularity)) + 1) / 10));
    end;
    
    % Average over all antenna elements
    w_total = abs(temp)^2 / num_horizontal_antenna_element_in_row;
    
    % Calculate the gain without codebook
    GAIN_WO_CB(horizontal_angle_ + abs(min(horizontal_granularity)) + 1) = 10 * log10(w_total);
end;


%% Calculate the horizontal antenna pattern without horizontal codebook
% Considering the normalized power
for horizontal_angle_ = horizontal_granularity
    temp = 0.0; % Set the temp gain
    
    % Sum up the gain from all antenna elements
    for antenna_element_ = 0: num_horizontal_antenna_element_in_row - 1 % Each horizontal antenna element
        temp_angle = exp(1j * 2 * pi / w_lambda * antenna_element_ * dh * sin(horizontal_angle_ / 180 * pi));
        temp_etilt = 1 / sqrt(num_horizontal_antenna_element_in_TXRU);
        temp_codebook = 1 / sqrt(num_horizontal_antenna_element_in_row / num_horizontal_antenna_element_in_TXRU);
        temp = temp + temp_angle * temp_codebook * temp_etilt * sqrt(10.^(AntennaElementGainH(horizontal_angle_ + abs(min(horizontal_granularity)) + 1) / 10));
    end;
    
    % Average over all antenna elements
    w_total = abs(temp)^2;
    
    % Calculate the gain without codebook
    GAIN_WO_CB_NP(horizontal_angle_ + abs(min(horizontal_granularity)) + 1) = 10 * log10(w_total);
end;

% Note: horizontal codebook with unit power; and analog precoder, i.e.
% e-tilt with unit power, which is then equivalent to the original antenna pattern

end

%% The end of this script
% Jeffrey % William

