function [likehood] = HMM_recognize(MFCC_HMM,prior, transmat, mu, sigma, mixmat)

addpath(genpath('HMMall'));
fprintf('\nHMM recognization ');

likehood = zeros(length(MFCC_HMM(1,:,1)),1);

width = length(MFCC_HMM(1,:,1));

for i=1:width
    likehood(i) = mhmm_logprob(MFCC_HMM(:,i,:), prior, transmat, mu, sigma, mixmat);
    
    % Progression Bar
    if mod(i,round(width/10)) == 0 
        fprintf('.');
    end
end

fprintf(' end\n');
rmpath('HMMall');

end

