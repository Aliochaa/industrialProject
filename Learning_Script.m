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
%speech = norm_comp(speech, fs);

% Open time_code file
fileID = fopen(txt,'r');
timeCode = fscanf(fileID,'%f')/1000;
fclose(fileID);

%%% ALGORITHM %%%

% Decoupage du son du phoneme en suivant le timeCode
phoneme = [];

for i=1:length(timeCode)
    time = fs*timeCode(i);
    offset = round(fs*0.025);
    phoneme = [phoneme; speech(time:time+offset);];
end

% MFCCs
[ MFCC_coefs ] = MFCC_computing(phoneme, fs, timeCode);

% Gaussian MM

% Hidden Markov Model
% Put the number of try you want to find the best model
% Risque de minimum local
nbTry = 10;
[prior,transmat] = HMM_learning(MFCC_coefs,nbTry);

% Write the new model in txt file
HMM_export('pModel.txt',prior,transmat);


%%%%%%%%%%%%%%%%%%%%%%%%%%%