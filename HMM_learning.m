function [prior,transmat,mu,sigma,mixmat] = HMM_learning(MFCC_HMM, nbTry)

addpath(genpath('HMMall'));

%Let us generate nex=50 vector-valued sequences of length T=50; each vector has size O=2.

O = length(MFCC_HMM(:,1,1));
T = length(MFCC_HMM(1,:,1));
nex = length(MFCC_HMM(1,1,:));
data = MFCC_HMM;
%data = randn(O,T,nex);

%HMM Parameters
%Now let use fit a mixture of M=2 Gaussians for each of the Q=2 states using K-means.
M = 1;
Q = 3;
cov_type='full';

%Finally, let us improve these parameter estimates using EM.
% LL : History of research
% Prior1 : Final priority probability
% Transmat1 : Final Transition probability

disp('Hidden Markov Model Learning :'); disp('Try n°1');

for i=1:nbTry %CHANGE NUMBER OF TRIES HERE
    % On part de données aléatoires
    prior0 = normalise(rand(Q,1));
    transmat0 = mk_stochastic(rand(Q,Q));
    
    %Initialisation Gaussienne
    [mu0, sigma0] = mixgauss_init(Q*M, reshape(data, [O T*nex]), cov_type);
    mu0 = reshape(mu0, [O Q M]);
    sigma0 = reshape(sigma0, [O O Q M]);
    mixmat0 = mk_stochastic(rand(Q,M));
    
    [LL, prior1, transmat1, mu1, sigma1, mixmat1] = mhmm_em(data, prior0, transmat0, mu0, sigma0, mixmat0, 'max_iter', 100,'verbose',0);
    
    if i == 1
        bestModel = LL(end);
        prior = prior1;
        transmat = transmat1;
        mu = mu1;
        sigma = sigma1;
        mixmat = mixmat1;
    
    elseif (LL(end) > bestModel)
        bestModel = LL(end);
        fprintf('Try n°%d --> better model : Likehood = %f\n',i,bestModel);
        prior = prior1;
        transmat = transmat1;
        mu = mu1;
        sigma = sigma1;
        mixmat = mixmat1;
        
    else
        fprintf('Try n°%d --> not better\n',i);
        
    end
    
end

fprintf('\n\nBest model found :\nLikehood : %f\n\n',bestModel);
fprintf('Prior matrix\n');
disp(prior)
fprintf('Transposition matrix\n');
disp(transmat)

rmpath('HMMall');

end
