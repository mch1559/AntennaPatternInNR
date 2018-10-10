function [W_V, W_H, W_H_Xpol, W_CB, N1, O1] = DFTCodebook( )
%DFTCodebook()
%   Generate the DFT-based codebook of Rel.13
%Details
%   For reference, please check Samsung's CR on R1-160536 (84bis)
%   W_V: vertical codebook
%   W_H: half of horizontal codebook
%   W_CB: total 3D codebook


%% First set necessary parameters
% Regarding to 36.213 Table 7.2.4.-9 Supported configuration of (O1, O2) and (N1, N2)
global num_co_phase;

[N1, N2, O1, O2, P] = AntennaArrayConfig( );
AntennaArrayCheck(N1, N2, O1, O2);

% Set the codebook configuration
Codebook_Config = 1; 


%% Generate the components
switch Codebook_Config
    case 1
        % Initialize the value
        phi_n = zeros(num_co_phase, 1);
        u_m = zeros(O2 * N2, N2);
        v_lm_temp = zeros(O1 * N1, N1);
        v_lm_xpol = zeros(O1 * N1 * num_co_phase, 2 * N1);
        v_lm = zeros(O1 * N1, O2 * N2, N1 * N2);
        W_CB_R1 = zeros(O1 * N1, O2 * N2, num_co_phase, P);
        
        % Get the co-phase part
        for n_ = 0: num_co_phase - 1
            phi_n(n_ + 1) = exp(1j * pi * n_ / 2); 
        end
        
        % Generate u_m for vertical domain
        for m_ = 0: O2 * N2 - 1
            for n2_ = 0: N2 - 1
                u_m(m_ + 1, n2_ + 1) = exp(1j * 2 *pi * m_ * n2_ / (O2 * N2));
            end
        end
        
        % Generate the v_lm_temp for horizontal domain
        for l_ = 0: O1 * N1 - 1
            for n1_ = 0: N1 - 1
                v_lm_temp(l_ + 1, n1_ + 1) = exp(1j * 2 * pi * l_ * n1_ / (O1 * N1));
            end
        end
        
        % Generate the horizontal codebook with co-phase
        for l_ = 0: O1 * N1 - 1
            for n_ = 0: num_co_phase - 1
                v_lm_xpol(l_ * num_co_phase + n_ + 1, :) = [v_lm_temp(l_ + 1, :) phi_n(n_ + 1) * v_lm_temp(l_ + 1, :)];
            end
        end
        
        % Generate the v_lm using Kronecker Product (KP)
        for l_ = 0: O1 * N1 - 1
            for m_ = 0: O2 * N2 - 1 
                v_lm(l_ + 1, m_ + 1, :) = kron(v_lm_temp(l_ + 1, :), u_m(m_ + 1, :));
            end
        end
    
end
% Note: DFT vectors are not mutual orthogonal; Give it a further check.
 

%% Generate the codebook
switch Codebook_Config
    case 1
        for l_ = 1: O1 * N1
            for m_ = 1: O2 * N2
                for n_ = 1: num_co_phase
                    for cb_ = 1: P
                        if cb_ <= P / 2   
                            W_CB_R1(l_, m_, n_, cb_) = 1 / sqrt(P) * v_lm(l_, m_, cb_); 
                        else
                            W_CB_R1(l_, m_, n_, cb_) = 1 / sqrt(P) * phi_n(n_) * v_lm(l_, m_, cb_ - P / 2);
                        end
                    end
                end
            end
        end
end


%% Transfer the codebook out
W_V = u_m;
W_H = v_lm_temp;
W_H_Xpol = v_lm_xpol;
W_CB = W_CB_R1;


end

