%% Binary Transmission 
% Author: Marvin Mendez

% initial operations
close all
clear all
clc;
rng('default');

% Parameters:  
% frequencies in MHz, bit rates in Mbit/s, time in micro-sec
Rb = 100;                    % Bit rate - 100 Mbit/s
Tb = 1/Rb;                   % bit interval
Nb = 1;                      % Bits per Symbol 
Ns = 8;                      % Samples per symbol
Ts = Tb/Ns;                  % Sampling interval
fs = 1/Ts;
K = 20;                      % Number of bits in each signal segment
N = K*Ns;                    % number of samples for each signal segment
M = 800;                     % number of segments
NTotBit = M*K;               % Number of bits to be simulated
M0 = Ns-1;                   % Optimal Sampling instant
Bvec = linspace(Rb/10,Rb,39); % Considered Bandwidth values
NoiseAmp = [0.8 1 1.2];


% Sweep Parameters
Bvec = linspace(Rb/10, Rb, 39); % Considered Bandwidth values
NoiseAmp = [0.8 1 1.2];         % Noise Amplitudes

% System Simulation 
[SignalTX, BitsTX] = Binary_Transmitter(NTotBit, Ns);
Pt = mean(abs(SignalTX).^2);

% BER matrix
P = zeros(length(NoiseAmp), length(Bvec));
SNR = zeros(1, length(NoiseAmp));

%  MONTE CARLO LOOP
for ind2 = 1:length(NoiseAmp)

    % Generate fresh noise for the current amplitude
    Noise = NoiseAmp(ind2) * randn(1, length(SignalTX));
    Pn = mean(abs(Noise).^2);
    SNR(ind2) = 10 * log10(Pt/Pn);

    % [FIXED]: Apply noise to a temporary variable so it doesn't accumulate
    SignalTX_noisy = SignalTX + Noise;

    for ind1 = 1:length(Bvec)
        B = Bvec(ind1);                     

        % Pass the temporarily noisy signal through the receiver filter
        [SignalRX] = RCfilter(SignalTX_noisy, fs, B);       

        % Sample and evaluate errors
        SamplesRX = SignalRX(M0:Ns:end);    
        LevelRX = sign(SamplesRX);       
        BitsRX = (LevelRX + 1)/2;        
        ErrorsRX = abs(BitsRX - BitsTX); 

        % Calculate and store the Bit Error Rate
        P(ind2, ind1) = sum(ErrorsRX)/NTotBit;        
    end
end

% Plot the theoretical performance curve (BER vs. Filter Bandwidth)
figure; 
semilogy(Bvec, P, 'LineWidth', 1.5); 
grid on;
title('Bit Error Rate vs RC Filter Bandwidth'); 
xlabel('Filter Bandwidth B [MHz]');
ylabel('Bit Error Rate (P_e)');
legend('Noise Amp: 0.8', 'Noise Amp: 1.0', 'Noise Amp: 1.2');

% % System Simulation
% [SignalTX,BitsTX] = Binary_Transmitter(NTotBit,Ns);
% figure; plot(SignalTX(1:10*Ns)); title('Transmitted signal'); grid on
% Pt = mean(abs(SignalTX).^2);
% for ind2 = 1:length(NoiseAmp)
%     Noise = NoiseAmp(ind2)*randn(1,length(SignalTX));
%     Pn = mean(abs(Noise).^2);
%     SNR = 10*log10(Pt/Pn);
%     SignalTX = SignalTX + Noise;
% 
%     for ind1 = 1:length(Bvec)
%         B = Bvec(ind1);                     % Selecting the current Bandwidth value
%         [SignalRX] = RCfilter(SignalTX,fs,B);       % Receiver Filter
%         Prn = mean(abs(SignalRX).^2);
%         eyediagram(SignalTX,3*Ns,3*Ns); % eye diagram of transmitted signal
%         title('Eye Diagram of Transmitted Signal'); grid on; ylabel('Amplitude');
%         eyediagram(SignalRX,3*Ns,3*Ns); % eye diagram of received signal
%         title('Eye Diagram of Received Signal'); grid on; ylabel('Amplitude');
%         figure; plot(SignalTX(1:10*Ns)); hold on;
%         plot(SignalRX(1:10*Ns),'r'); grid on;
%         title('Transmitted Noisy Signal vs Filtered Received Signal'); % Plot of TX and RX after RC Filtering
%         legend('TX Signal with Noise','RX Filtered Signal');
% 
%         SamplesRX = SignalRX(M0:Ns:end);    % Sequence of received samples
%         figure; histogram(SamplesRX,50); grid on; title('Histogram of Received Signal')
% 
%         % Evaluation of PSD
%         MatSigTX=reshape(SignalTX,N,M);
%         FrSigTX=abs(fft(MatSigTX)').^2/N;
%         if M>1
%            PSDSigTX=mean(FrSigTX);
%         else
%            PSDSigTX=FrSigTX;
%         end
%         figure; freq=linspace(-fs/2,fs/2,N);
%         plot(freq,fftshift(10*log10(abs(PSDSigTX)))); grid on
%         title('Power Spectral Density');
%         LevelRX = sign(SamplesRX);       % Estimated Values
%         BitsRX = (LevelRX + 1)/2;        % Received bits
%         ErrorsRX = abs(BitsRX - BitsTX); % Number of Errors
%         P(ind2,ind1) = sum(ErrorsRX)/NTotBit;        % Bit error rate
%     end
% end
% figure; grid on;
% semilogy(Bvec,P,'LineWidth',1.5); grid on
% title('Bit Error Rate vs RC Filter Bandwidth');
% xlabel('B [Mhz]');legend('0.8','1','1.2')