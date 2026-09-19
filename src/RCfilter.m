function [out] = RCfilter(in,fs,B)
%     B = 3 dB bandwidth of the RC filter (in Hz)
%     real pole in s = 2*pi*B
%     B=1/(2*pi*R*C)
    k1=fs/(pi*B); k2=1/(k1+1);
    a=[1 (1-k1)*k2];
    b=[k2 k2];
%     figure; freqz(b,a); title('H(f) for RC LPF'); grid on;
%     figure; impz(b,a); title('h(t) for RC LPF'); grid on;
    out=filter(b,a,in);
end

