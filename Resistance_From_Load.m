function [R1,R2] = Resistance_From_Load(R10,R20,R1Gain,R2Gain,fG)
%RESISTANCE_FROM_LOAD Calculate R1 and R2 from load cell given known
%properties of half-bridge load cell and input load
%
%INPUTS:
%======
%
%R10    - Resistance of 1st strain gauge, zero load
%R20    - Resistance of 2nd strain gauge, zero load
%R1Gain - Change in resistance per load, 1st gauge
%R2Gain - Change in resistance per load, 2nd gauge
%fG     - Input force
%
%OUTPUTS:
%=======
%
%R1     - Resistance of 1st gauge
%R2     - Resistance of 2nd gauge

    % Calculate outputs
    R1 = R10 + R1Gain * fG;
    R2 = R20 + R2Gain * fG;

end

