%%%%% Recognization Script %%%%%

% Matlab initalization
warning('off','all')
addpath(genpath('Sounds'));
clc; close all;

%%% READING %%%

% Put your files names
audio = 'louisPaul.wav';
% Open audio file
[ speech, fs] = wavread(audio);

% Open Hidden Markov Model parameters
fileID = fopen('pModel.txt');
fscanf(fileID,...);
fclose(fileID);

%%% ALGORITHM %%% file

MFCCs = [];
offset = fs*0.025;

for i=1:length(timeCode)
    
    % Decoupage en samples de 25 ms
    input = speech(timeCode(i)*offset:(timeCode(i)+1)*offset);
    
    % 13 MFCCs sur chaque signaux
    MFCCs = [MFCCs mfcc( input, fs, Tw, Ts, alpha, hamming, R, M, C, L );];

end

% MFCCs
[ MFCC_coefs ] = MFCC_computing(phoneme, fs, timeCode);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  HMM classification  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Transform MFCCs for HMM input
MFCC_HMM(1,:,:) = MFCCs'; 

% La matrice MFCC_HMM a 2 lignes * 18 coeffs *630 sampls de 50 ms

loglik = [];

% Compute HMM Classification
for i=1:length(MFCC_HMM(1,:,1))
    loglik = [loglik ; mhmm_logprob(MFCC_HMM(:,i,:), prior, transmat, mu, Sigma, mixmat);];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Plot of results  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot(1:length(loglik),loglik);
% 
timeCode = round(timeCode * fs / offset);

j = 1;
test = [];

for i=1:length(loglik)
    if i == timeCode(j)
        test(i) = -50;
        j = j+1;
        if j == length(timeCode)
            test(i:length(loglik)) = -150;
            break
        end
    else
        test(i) = -150;
    end
end

    
plot(1:length(loglik),loglik,1:length(loglik),test);

