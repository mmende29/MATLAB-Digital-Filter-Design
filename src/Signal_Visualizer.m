%% Generating Random Variables
% Author: Marvin Mendez

% initial operations
close all
clear all
clc;
rng('default');

% Common parameters 
% Measurement units:  
% frequencies in MHz, bit rates in Mbit/s, time in micro-sec
Rb = 100;                    % Bit rate - 100 Mbit/s
Tb = 1/Rb;                   % bit interval
Nb = 1;                      % Bits per Symbol 
Ns = 16;                      % Samples per symbol
Ts = Tb/Ns;                  % Sampling interval
fs = 1/Ts;
K = 20; 
N = K*Ns; % number of samples for each signal segment
M = 400; % number of segments
NTotBit = M*K;% Number of bits to be simulated
M0 = Ns-1;  % optimum sampling instant
[SignalTX,BitsTX] = Binary_Transmitter(NTotBit,Ns);
Pt = mean(abs(SignalTX).^2);
Noise = 0.1*randn(1,length(SignalTX));
Pn = mean(abs(Noise).^2);
SNR = 10*log10(Pt/Pn);
SignalTX = SignalTX + Noise;
B = Rb;
[SignalRX] = RCfilter(SignalTX,fs,B);       % Receiver Filter
Prn = mean(abs(SignalRX).^2);
eyediagram(SignalTX,3*Ns,3*Ns); % eye diagram of transmitted signal
title('Eye Diagram of Transmitted Signal'); grid on; ylabel('Amplitude');
eyediagram(SignalRX,3*Ns,3*Ns); % eye diagram of received signal
title('Eye Diagram of Received Signal'); grid on; ylabel('Amplitude');
figure; plot(SignalTX(1:10*Ns)); hold on;
plot(SignalRX(1:10*Ns),'r'); grid on;
title('Transmitted Noisy Signal vs Filtered Received Signal'); % Plot of TX and RX after RC Filtering
legend('TX Signal with Noise','RX Filtered Signal');

SamplesRX = SignalRX(M0:Ns:end);    % Sequence of received samples
figure; histogram(SamplesRX,50); grid on; title('Histogram of Received Signal')

% Evaluation of PSD
MatSigTX=reshape(SignalTX,N,M);
FrSigTX=abs(fft(MatSigTX)').^2/N;
if M>1
   PSDSigTX=mean(FrSigTX);
else
   PSDSigTX=FrSigTX;
end
figure; freq=linspace(-fs/2,fs/2,N);
plot(freq,fftshift(10*log10(abs(PSDSigTX)))); grid on
title('Power Spectral Density');
