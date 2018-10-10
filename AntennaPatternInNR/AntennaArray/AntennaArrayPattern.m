function [ ] = AntennaArrayPattern(AntennaElementGainH, AntennaElementGainV, AntennaElementGain3D, W_V, W_H, W_H_Xpol, W_CB, N1, O1)
%AntennaArrayPattern: calculate the antenna pattern in H/V/3D of an antenna array  
%   In details


%% Horizontal antenna pattern
[GAIN_CB_H, GAIN_WO_CB_H, GAIN_WO_CB_NP_H, GAIN_CB_BEAM_H] = HorizontalAntennaPattern(AntennaElementGainH, W_H, W_H_Xpol);

% Plot H-domain figures
antenna_array_pattern_h_plot = 1;
if antenna_array_pattern_h_plot == 1
    AntennaArrayPatternHPlot(GAIN_CB_H, GAIN_WO_CB_H, GAIN_WO_CB_NP_H, GAIN_CB_BEAM_H, AntennaElementGainH);
end


%% Vertical antenna pattern
[GAIN_CB_V, GAIN_WO_CB_V, GAIN_WO_CB_NP_V, GAIN_CB_BEAM_V] = VerticalAntennaPattern(AntennaElementGainV, W_V);

% Plot V-domain figures
antenna_array_pattern_v_plot = 1;
if antenna_array_pattern_v_plot == 1
    AntennaArrayPatternVPlot(GAIN_CB_V, GAIN_WO_CB_V, GAIN_WO_CB_NP_V, GAIN_CB_BEAM_V, AntennaElementGainV);
end


%% 3D antenna pattern
[GAIN_3D, GAIN_3D_BEAM] = FullDimensionAntennaPattern(AntennaElementGain3D, W_CB, N1, O1);

% Plot full demension figure
antenna_array_pattern_3d_plot = 1;
if antenna_array_pattern_3d_plot == 1
    AntennaArrayPattern3DPlot(GAIN_3D, GAIN_3D_BEAM, AntennaElementGain3D);
end


end

