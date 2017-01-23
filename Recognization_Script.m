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
speech = speech(1:500000);

% Open Hidden Markov Model parameters
% fileID = fopen('pModel.txt');
% fscanf(fileID,...);
% fclose(fileID);

%%% ALGORITHM %%%

[ MFCC_coefs ] = MFCC_computing(speech, fs);

% % Adapt MFCC format for HMM
clear MFCC_HMM
MFCC_HMM(1,:,:) = MFCC_coefs';

[likehood] = HMM_recognize(MFCC_HMM,prior, transmat, mu, sigma, mixmat);

% ECHELLE LOG !
figure
plot(1:length(likehood),likehood)

