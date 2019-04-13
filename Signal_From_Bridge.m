function Vout = Signal_From_Bridge(G1R1,G1R2,G2R1,G2R2,G3R1,G3R2,G4R1,G4R2)
%SIGNAL_FROM_BRIDGE Calculate output voltage given current resistance
%values
%
%Suited to 2.5V excitation
%
%INPUTS:
%======
%
%G1R1 - 1st load cell, 1st resistor
%G1R2 - 1st load cell, 2nd resistor
%G2R1 - 2nd load cell, 1st resistor
%G2R2 - 2nd load cell, 2nd resistor
%G3R1 - 3rd load cell, 1st resistor
%G3R2 - 3rd load cell, 2nd resistor
%G4R1 - 4th load cell, 1st resistor
%G4R2 - 4th load cell, 2nd resistor
%
%OUTPUTS:
%=======
%
%Vout - Output voltage from bridge

    % Calculate output voltage of bridge
    Vout = 2.5 * ((G3R1+G4R1)/(G3R1+G4R1+G4R2+G1R2)...
                - (G2R2+G3R2)/(G2R2+G3R2+G2R1+G1R1));

end

