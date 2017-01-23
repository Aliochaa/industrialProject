%%%%% Learning Script %%%%%

% Matlab initalization
warning('off','all')
addpath(genpath('Sounds'));
clc; close all; clear all;

%%% READING %%%
% Put your files names
audio = 'louisPaul.wav';
txt = 'timeCode_louisPaul.txt';

% Open audio file
[ speech, fs] = wavread(audio);

% Compression and normalization from speech
% EN OPTION T'AS VU
% speech = norm_comp(speech, fs);

% Open time_code file
fileID = fopen(txt,'r');
timeCode = fscanf(fileID,'%f')/1000;
fclose(fileID);

%%% ALGORITHM %%%

% Isolation phonemes P
% Decoupage du son du phoneme en suivant le timeCode
lengthPhoneme = 0.025;
offset = round(fs*lengthPhoneme);
phoneme = zeros(offset,length(timeCode));

for i=1:length(timeCode)
    time = fs*timeCode(i);
    phoneme(:,i) = speech(time:time+offset-1)';
    
    MFCC_coefs(i,:,:) = MFCC_computing(phoneme(:,i), fs);
end


% % MFCCs
% [ MFCC_coefs ] = MFCC_computing(phoneme, fs);
% 
% % Gaussian MM
% 
% % Adapt MFCC format for HMM
% MFCC_HMM(1,:,:) = MFCC_coefs; 
% 
% % Hidden Markov Model
% % Put the number of try you want to find the best model
% % Risque de minimum local
% 
% nbTry = 10;
% [prior,transmat,mu,sigma,mixmat] = HMM_learning(MFCC_HMM,nbTry);
% 
% % Write the new model in txt file
% HMM_export('pModel.txt',prior,transmat,mu,mixmat);