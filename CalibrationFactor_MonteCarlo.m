% This script runs a Monte Carlo simulation to understand the distribution
% of zero voltage and calibration factor for manufactured scales.

% Known magnitude and position of calibration load
Y = 7.5; % in
Z = 7.5; % in
f = 100; % lb

% 3-sigma deviation in resistance from nominal (per data sheet)
Zero_nom    = 1000; % Ohm;
Zero_3sigma = 20;   % Ohm

% 3-sigma deviation in output sensitivity (per data sheet)
Gain_nom    = 5.0; % Ohm
Gain_3sigma = 0.5; % Ohm / lbf

% Calculate variance for each
Zero_var = sqrt(Zero_3sigma/3);
Gain_var = sqrt(Gain_3sigma/3);

% Preallocation for loop
num_runs = 10000;
LoadCellProps = struct;
Cal_factors = zeros(num_runs,1);
VZeros = zeros(num_runs,1);

% Run loop
for i = 1:num_runs
    
    % Zeros
    LoadCellProps(i).G1.R1.Zero = randn * Zero_var + Zero_nom;
    LoadCellProps(i).G1.R2.Zero = randn * Zero_var + Zero_nom;
    LoadCellProps(i).G2.R1.Zero = randn * Zero_var + Zero_nom;
    LoadCellProps(i).G2.R2.Zero = randn * Zero_var + Zero_nom;
    LoadCellProps(i).G3.R1.Zero = randn * Zero_var + Zero_nom;
    LoadCellProps(i).G3.R2.Zero = randn * Zero_var + Zero_nom;
    LoadCellProps(i).G4.R1.Zero = randn * Zero_var + Zero_nom;
    LoadCellProps(i).G4.R2.Zero = randn * Zero_var + Zero_nom;
    
    % Gains
    LoadCellProps(i).G1.R1.Gain = randn * Gain_var + Gain_nom;
    LoadCellProps(i).G1.R2.Gain = randn * Gain_var - Gain_nom;
    LoadCellProps(i).G2.R1.Gain = randn * Gain_var + Gain_nom;
    LoadCellProps(i).G2.R2.Gain = randn * Gain_var - Gain_nom;
    LoadCellProps(i).G3.R1.Gain = randn * Gain_var + Gain_nom;
    LoadCellProps(i).G3.R2.Gain = randn * Gain_var - Gain_nom;
    LoadCellProps(i).G4.R1.Gain = randn * Gain_var + Gain_nom;
    LoadCellProps(i).G4.R2.Gain = randn * Gain_var - Gain_nom;
    
    % Calculate cal factor and zero
    [~,Cal_factors(i),VZeros(i)] = Calculate_Measured_Load(Y,Z,f,LoadCellProps(i));
    
end

% Convert factors to mV before plotting
VZeros = VZeros * 1000;
Cal_factors = Cal_factors * 1000;

% Plot Zero distribution
figure;
hist(VZeros,20);
grid('on');
xlabel('Zero Value (mV)');
ylabel('Occurances / 10,000 samples');
title('Zero Voltage Distribution');

% Plot cal factors
figure;
hist(Cal_factors,20);
grid('on');
xlabel('Calibration Factor (mV/lbf)');
ylabel('Occurances / 10,000 samples');
title('Calibration Factor Distribution');

% Print
fprintf('\n');
VZero_mean = mean(VZeros);
VZero_std  = std(VZeros);
fprintf('Mean Zero:                %.3f mV\n',VZero_mean);
fprintf('3-sigma Zero Range:      %.3f to %.3f mV\n',VZero_mean-3*VZero_std,VZero_mean+3*VZero_std);
Cal_mean = mean(Cal_factors);
Cal_std  = std(Cal_factors);
fprintf('Mean Calibration Factor:  %.3f mV\n',Cal_mean);
fprintf('3-sigma Factor Range:     %.3f to %.3f mV\n',Cal_mean-3*Cal_std,Cal_mean+3*Cal_std);
