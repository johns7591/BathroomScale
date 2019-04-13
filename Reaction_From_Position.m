function [fG1,fG2,fG3,fG4] = Reaction_From_Position(Y,Z,fin)
%REACTION_FROM_POSITION Calculate reaction loads based on YZ position of
%input load
%
%Suited to 15" square spacing of sensors in arrangement below
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
%
%INPUTS:
%======
%
%Y   - Y position of force
%Z   - Z position of force
%fin - Force magnitude
%
%OUTPUTS:
%=======
%
%fGx - Force at load cell x

    % Known constants
    Ymax = 15;
    Zmax = 15;

    % Calculate outputs
    fG1 = fin * ((Ymax-Y)/Ymax) * ((Zmax-Z)/Zmax);
    fG2 = fin * ((Ymax-Y)/Ymax) *        (Z/Zmax);
    fG3 = fin *        (Y/Ymax) * ((Zmax-Z)/Zmax);
    fG4 = fin *        (Y/Ymax) *        (Z/Zmax);
    
end

