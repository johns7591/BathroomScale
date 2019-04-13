function [f_measured, Cal_factor, Vout_zero] = Calculate_Measured_Load(Y,Z,f_applied,LoadCellProps,Comp_Err)
%CALCULATE_MEASURED_LOAD Calculate load measured by scale given position of
%load and resistance properties
%
%This function will first calculate the zero voltage of the scale
%It will then calculate the gain of the scale as calibrated at the factory
%Finally it will produce the weight measured by the scale
%
%INPUTS:
%======
%
%Y             - Y position of load (0-15")
%Z             - Z position of load (0-15")
%f_applied     - Force applied to scale
%LoadCellProps - Properties of load cells
%                Struct with first fields:
%                G1-G4
%                  R1-R2
%                    Zero (ohm), Gain (ohm/lbf)
%Comp_Err      - (Optional) Comprehensive 3-sigma error of loadcell
%
%OUTPUTS:
%=======
%
%f_measured    - Force as measured by scale

    % Defaults
    if nargin < 5
        Comp_Err = 0;
    end

    % Convert struct to more compact vars  =======================

    % Resistance at zero load
    G1R10    = LoadCellProps.G1.R1.Zero;
    G1R20    = LoadCellProps.G1.R2.Zero;
    G2R10    = LoadCellProps.G2.R1.Zero;
    G2R20    = LoadCellProps.G2.R2.Zero;
    G3R10    = LoadCellProps.G3.R1.Zero;
    G3R20    = LoadCellProps.G3.R2.Zero;
    G4R10    = LoadCellProps.G4.R1.Zero;
    G4R20    = LoadCellProps.G4.R2.Zero; 

    % Gains
    G1R1Gain = LoadCellProps.G1.R1.Gain;
    G1R2Gain = LoadCellProps.G1.R2.Gain;
    G2R1Gain = LoadCellProps.G2.R1.Gain;
    G2R2Gain = LoadCellProps.G2.R2.Gain;
    G3R1Gain = LoadCellProps.G3.R1.Gain;
    G3R2Gain = LoadCellProps.G3.R2.Gain;
    G4R1Gain = LoadCellProps.G4.R1.Gain;
    G4R2Gain = LoadCellProps.G4.R2.Gain;
    
    % Comprehensive variance
    Comp_Var = sqrt(Comp_Err/3);

    % Calculate Scale Zero =======================================

    % Uses mass properties of scale to find load cell forces at 0 load
    Yzero    =  7.5;  %in
    Zzero    =  7.5;  %in
    fzero    = 0.75;  %lb
    [fG1zero,fG2zero,fG3zero,fG4zero] = Reaction_From_Position(Yzero,Zzero,fzero);

    % Get gauge resistances
    [G1R1zero,G1R2zero] = Resistance_From_Load(G1R10,G1R20,G1R1Gain,G1R2Gain,fG1zero);
    [G2R1zero,G2R2zero] = Resistance_From_Load(G2R10,G2R20,G2R1Gain,G2R2Gain,fG2zero);
    [G3R1zero,G3R2zero] = Resistance_From_Load(G3R10,G3R20,G3R1Gain,G3R2Gain,fG3zero);
    [G4R1zero,G4R2zero] = Resistance_From_Load(G4R10,G4R20,G4R1Gain,G4R2Gain,fG4zero);
    
    % Factor in comprehensive error
    G1R1zero = randn * Comp_Var + G1R1zero;
    G1R2zero = randn * Comp_Var + G1R2zero;
    G2R1zero = randn * Comp_Var + G2R1zero;
    G2R2zero = randn * Comp_Var + G2R2zero;
    G3R1zero = randn * Comp_Var + G3R1zero;
    G3R2zero = randn * Comp_Var + G3R2zero;
    G4R1zero = randn * Comp_Var + G4R1zero;
    G4R2zero = randn * Comp_Var + G4R2zero;

    % Now calculate signal
    Vout_zero = Signal_From_Bridge(G1R1zero,G1R2zero,G2R1zero,G2R2zero,G3R1zero,G3R2zero,G4R1zero,G4R2zero);

    % Calculate Scale Gain =======================================

    % Uses factory cal procedure (200 lb @ geometric center of scale)
    Ycal    =  7.5;  %in
    Zcal    =  7.5;  %in
    fcal    =  200;  %lb
    [fG1cal,fG2cal,fG3cal,fG4cal] = Reaction_From_Position(Ycal,Zcal,fcal);

    % Add effects of zero
    fG1cal = fG1cal + fG1zero;
    fG2cal = fG2cal + fG2zero;
    fG3cal = fG3cal + fG3zero;
    fG4cal = fG4cal + fG4zero;

    % Get gauge resistances
    [G1R1cal,G1R2cal] = Resistance_From_Load(G1R10,G1R20,G1R1Gain,G1R2Gain,fG1cal);
    [G2R1cal,G2R2cal] = Resistance_From_Load(G2R10,G2R20,G2R1Gain,G2R2Gain,fG2cal);
    [G3R1cal,G3R2cal] = Resistance_From_Load(G3R10,G3R20,G3R1Gain,G3R2Gain,fG3cal);
    [G4R1cal,G4R2cal] = Resistance_From_Load(G4R10,G4R20,G4R1Gain,G4R2Gain,fG4cal);
    
    % Factor in comprehensive error
    G1R1cal = randn * Comp_Var + G1R1cal;
    G1R2cal = randn * Comp_Var + G1R2cal;
    G2R1cal = randn * Comp_Var + G2R1cal;
    G2R2cal = randn * Comp_Var + G2R2cal;
    G3R1cal = randn * Comp_Var + G3R1cal;
    G3R2cal = randn * Comp_Var + G3R2cal;
    G4R1cal = randn * Comp_Var + G4R1cal;
    G4R2cal = randn * Comp_Var + G4R2cal;

    % Now calculate signal
    Vout_cal = Signal_From_Bridge(G1R1cal,G1R2cal,G2R1cal,G2R2cal,G3R1cal,G3R2cal,G4R1cal,G4R2cal);

    % Scale calibration factor (V/lb)
    Cal_factor = (Vout_cal-Vout_zero) / fcal;


    % Calculate Measured Load ====================================

    % Reaction forces
    [fG1,fG2,fG3,fG4] = Reaction_From_Position(Y,Z,f_applied);

    % Add effects of zero
    fG1 = fG1 + fG1zero;
    fG2 = fG2 + fG2zero;
    fG3 = fG3 + fG3zero;
    fG4 = fG4 + fG4zero;

    % Get gauge resistances
    [G1R1,G1R2] = Resistance_From_Load(G1R10,G1R20,G1R1Gain,G1R2Gain,fG1);
    [G2R1,G2R2] = Resistance_From_Load(G2R10,G2R20,G2R1Gain,G2R2Gain,fG2);
    [G3R1,G3R2] = Resistance_From_Load(G3R10,G3R20,G3R1Gain,G3R2Gain,fG3);
    [G4R1,G4R2] = Resistance_From_Load(G4R10,G4R20,G4R1Gain,G4R2Gain,fG4);
    
    % Factor in comprehensive error
    G1R1 = randn * Comp_Var + G1R1;
    G1R2 = randn * Comp_Var + G1R2;
    G2R1 = randn * Comp_Var + G2R1;
    G2R2 = randn * Comp_Var + G2R2;
    G3R1 = randn * Comp_Var + G3R1;
    G3R2 = randn * Comp_Var + G3R2;
    G4R1 = randn * Comp_Var + G4R1;
    G4R2 = randn * Comp_Var + G4R2;

    % Now calculate signal
    Vout = Signal_From_Bridge(G1R1,G1R2,G2R1,G2R2,G3R1,G3R2,G4R1,G4R2);

    % Scale calibration factor (V/lb)
    f_measured = (Vout-Vout_zero) / Cal_factor;

end

