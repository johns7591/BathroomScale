% This script runs a simulated QC test on 100 scales, assumes gauge
% repeatability within 2 ohms full scale

% Known magnitude and position of calibration load
Y = 7.5; % in
Z = 7.5; % in
f = 200; % lb

% Strain gauge repeatability
Gauge_Repeat = 0.2; % ohm

% Resistance at zero load
LoadCellProps.G1.R1.Zero =  1000; % Ohm
LoadCellProps.G1.R2.Zero =  1000; % Ohm
LoadCellProps.G2.R1.Zero =  1000; % Ohm
LoadCellProps.G2.R2.Zero =  1000; % Ohm
LoadCellProps.G3.R1.Zero =  1000; % Ohm
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

% Preallocation for loop
num_runs = 100;
meas_load = zeros(num_runs,1);

% Run loop
for i = 1:num_runs
    
    % Calculate cal factor and zero
    meas_load(i) = Calculate_Measured_Load(Y,Z,f,LoadCellProps,Gauge_Repeat);
    
end

% Plot cal factors
figure;
hist(meas_load,10);
grid('on');
xlabel('Measured Load');
ylabel('Occurances / 100 samples');
title('Measured Load Distribution (After Calibration)');

% Print
fprintf('\n');
Cal_mean = mean(meas_load);
Cal_std  = std(meas_load);
fprintf('Mean Measured Load:  %.1f lb\n',Cal_mean);
fprintf('3-sigma Loadr Range:     %.1f to %.1f lb\n',Cal_mean-3*Cal_std,Cal_mean+3*Cal_std);
