function [ outSpeech ] = norm_comp( speech, Fech )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%On met la valeur max à 1 respectivement -1
speech = speech/max(abs(speech));

%Compression
TH      = -15;      % in dB
RATIO   = 6;
AT      = 0.01;     % in seconds
RT      = 0.01;     % in seconds
MAKEUP  = 10;       % in dB
 
[speech , ~] = comp_peak(speech, Fech, TH, RATIO, AT, RT, MAKEUP);

%On remet la valeur max à 1 respectivement -1
outSpeech=speech/max(abs(speech));

end

function [y, xpeak] = comp_peak( x, Fs, CT, CR, at, rt, Gout) % CT,CR, AT1, RT1)
%COMP compresses an audio signal according to the compression threshold CT
%in dB and the compression ratio CR

%The static curve applied can be chosen by uncomment the line corresponding
% to the desired static curve in the Gain Reduction (GR) section of the
% following code

%   CT: compression threshold in dB (below this signal level the input signal
%   will not be affected)
%	CR: compression ratio specifies how much the dynamic range above the
%	compression threshold is reduced
%	at: attack time in seconds
%	rt: release time in seconds


 % Conversion from time to coefficients
AT = 1 - exp(-2.2/(at*Fs));
RT = 1 - exp(-2.2/(rt*Fs));

% Slope of the static curve
CS = 1-(1/CR);

% Init variables
xpeak = zeros(length(x),1);
x_sc = zeros(size(x,1),1);
GR = zeros(size(x,1),1);
xpeak_old = 0.5;
x_sc_old = 0.5;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for n = 1:1:length(x)
    
    % Peak Level measurement -----------------------------
    if n==1 || xpeak_old<abs(x(n))
        coeff = AT;
    else
        coeff = RT;
    end
    xpeak(n) = (1-coeff)*xpeak_old + coeff * abs(x(n));
    xpeak_old = xpeak(n);
    
    % Lin->log ------------------------------------------
    xpeak(n) = 20*log10(xpeak(n)+eps);

    % Gain Reduction ------------------------------------
    GR(n) = min([ 0, CS*(CT-xpeak(n))]);
    
    % Sidechain factor (log->lin)------------------------
    x_sc(n) = 10^(GR(n)/20);
    
    % Smoothing Filter ----------------------------------
    if n==1 || x_sc_old > x_sc(n)
        coeff = AT;
    else
        coeff = RT;
    end
    x_sc(n) = (1-coeff)*x_sc_old + coeff * x_sc(n);
    x_sc_old = x_sc(n);
    
    
end

% Apply Gain Reduction
y = x .* x_sc;

% output gain
y = 10^(Gout/20) * y;

end

