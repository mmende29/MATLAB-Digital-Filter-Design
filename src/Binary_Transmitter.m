function [SignalTX,BitsTX] = Binary_Transmitter(NTotBit,Ns)
    % This function simulates a binary transmitter that uses
    % rectangles with NS samples as basic tranmission pulses
    % filter parameters        
    Bt=ones(1,Ns); At=1;          % rectangular transmit filter
    figure; freqz(Bt,At);         % visualization of transfer function
    title('Transfer function of the Transmit Filter'); grid on;
    % Data generation 
    % Sequence of IID discrete random variables taking values in {0,1}
    BitsTX = round(rand(1,NTotBit));
    % Symbol mapping and upsampling 
    an = 2*BitsTX-1; % mapper
    chUp = upsample(an,Ns);      
    % Pulse shaping 
    SignalTX = filter(Bt,At,chUp);     
end

