function [ MFCC_coefs ] = MFCC_computing(speech, fs)

fprintf('\nMFCCs processing ...');

addpath(genpath('mfcc'));

 % MFCC variables
    Tw = 25;                       % analysis frame duration (ms)
    Ts = 10;                       % analysis frame shift (ms)
    alpha = 0.97;                  % preemphasis coefficient
    M = 20;                        % number of filterbank channels 
    C = 12;                        % number of cepstral coefficients
    L = 22;                        % cepstral sine lifter parameter
    R = [ 300 3700 ];              % frequency range to consider
  
% Hamming window (see Eq. (5.2) on p.73 of [1])
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));



% Toolbox fonction
[ MFCC_coefs, FBEs, frames ] = mfcc(speech, fs, Tw, Ts, alpha, hamming, R, M, C, L );

%Delete first coefficient which is unusable
MFCC_coefs = MFCC_coefs(2:end,:);

%Compute deltas
MFCC_coefs = MFCC_delta(MFCC_coefs,C);

%Plot results
MFCC_plot(MFCC_coefs,C);

fprintf(' end !\n\n');
rmpath('mfcc');

end




function [ ] = MFCC_plot(MFCC_coefs,C)

figure('PaperPositionMode', 'auto', 'color', 'w', 'PaperOrientation', 'landscape', 'Visible', 'on' );

width = 1:size(MFCC_coefs,2);                   % "Width" of matrix
height = 1:C-1;                                 % "Height" of matrix
firstHalf = MFCC_coefs(1:(end/2),:);            % Coefficients part
secondHalf = MFCC_coefs((end/2+1):end,:);       % Deltas part

% MFCC_coefs
subplot(2,1,1)
    imagesc(width, height, firstHalf);
    axis('xy');
    xlabel('Frame index');
    ylabel('Cepstrum index');
    title('Mel frequency cepstrum coefficients');

%Deltas
subplot(2,1,2)
    imagesc( width, height, secondHalf);
    axis( 'xy' );
    xlabel('Frame index');
    ylabel('Cepstrum index');
    title('Mel frequency cepstrum delta');

end




function [MFCC_coefs] = MFCC_delta(MFCC_coefs,C)

% Add repetiton of column both side to compute the delta
% a b c d       % a a a b c d d d  
% e f g h  -->  % e e e f g h h h
% i j k l       % i i i j k l l l 

firstCol = MFCC_coefs(1,:);
lastCol = MFCC_coefs(end,:);

MFCC_D = [firstCol; firstCol; MFCC_coefs; lastCol; lastCol];

% Compute delta :
% each delta = n * [(ct+1 - ct-1) + ... + (ct+n - ct-n)] / (2*(1+ ... + n^2))

% we take n = 2 :
% each delta = 2 * [(ct+1 - ct-1) + (ct+2 - ct-2)] / (2*(1+ 2^2))

for i = 3:(size(MFCC_coefs,1)+2)    % col of original matrix (from 3 to end-2)
    
    for j = 1:size(MFCC_coefs,2)    % row    
        D1 = MFCC_D(i+1,j)-MFCC_D(i-1,j);
        D2 = MFCC_D(i+2,j)-MFCC_D(i-2,j);
        MFCC_coefs(C+i-2,j) = (D1 + D2*2) / (2*5);
    end
    
end

end

