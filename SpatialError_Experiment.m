%Calculate error at different positions on scale
%
%Sensor arrangement detailed below:
%
% Z
% 15" G2             G4
% |
% |
% |
% |
% |
% 0"  G1             G3
%  Y  0" ----------- 15"

% Resistance at zero load
LoadCellProps.G1.R1.Zero =  1000; % Ohm
LoadCellProps.G1.R2.Zero =  1000;  % Ohm
LoadCellProps.G2.R1.Zero =  1000; % Ohm
LoadCellProps.G2.R2.Zero =  1000; % Ohm
LoadCellProps.G3.R1.Zero =  1000;  % Ohm
LoadCellProps.G3.R2.Zero =  1000; % Ohm
LoadCellProps.G4.R1.Zero =  1000; % Ohm
LoadCellProps.G4.R2.Zero =  1000; % Ohm

% Gains
LoadCellProps.G1.R1.Gain =  5.00; % Ohm/lbf
LoadCellProps.G1.R2.Gain = -5.00; % Ohm/lbf
LoadCellProps.G2.R1.Gain =  5.00; % Ohm/lbf
LoadCellProps.G2.R2.Gain = -5.00; % Ohm/lbf
LoadCellProps.G3.R1.Gain =  5.00; % Ohm/lbf
LoadCellProps.G3.R2.Gain = -5.00; % Ohm/lbf
LoadCellProps.G4.R1.Gain =  5.00; % Ohm/lbf
LoadCellProps.G4.R2.Gain = -5.00; % Ohm/lbf

% Load (max for single sensor)
f_applied = 110; %lb

% Preallocation
num_vals  = 16*16;
coords    = zeros(num_vals,2);
error_val = zeros(num_vals,1);

% Loop through all possible positions in 0.5" increments
iter      = 1;
for Y = 0:0.5:15
    for Z = 0:0.5:15
        coords(iter,1) = Y;
        coords(iter,2) = Z;
        error_val(iter) = (Calculate_Measured_Load(Y,Z,f_applied,LoadCellProps)-f_applied)/f_applied;
        iter = iter + 1;
    end
end

% Create figure to display error spatially
figure;
scatter3(coords(:,1),coords(:,2),100*abs(error_val),'MarkerEdgeColor','r');
hold('on');
zero_inds = abs(error_val) < 1e-4;
accept_inds = abs(error_val) < 1e-3;
scatter3(coords(accept_inds,1),coords(accept_inds,2),100*abs(error_val(accept_inds)),'MarkerEdgeColor','y');
scatter3(coords(zero_inds,1),coords(zero_inds,2),100*abs(error_val(zero_inds)),'MarkerEdgeColor','g');
xlabel('Y left-right (in)');
ylabel('Z fore-aft (in)');
zlabel('% Error');
title('Scale Measurement Error, Resolved to Position');
legend('Unacceptable Error (> 0.1%)','Acceptable Error','Zero Error');

