function [EWA, EH, varH, alphaH, betaH, alphaW, betaW, ...
    alphaA, betaA, varWA, finalscore, final_iter, init_seed_struct] = BN2MF_patterns(X, true_patterns)

% Run BN2MF with known patterns

rng('shuffle')
init_seed_struct = rng; % bc default is seed = 0
randn(1000); % Warming up the mersenne twister rng

bnp_switch = 1;  % this turns on/off the Bayesian nonparametric part.
[dim, N] = size(X);
[Kinit, ~] = size(true_patterns);

reps = 10;
end_score = zeros(reps, 1);

for i = 1:reps % Choose best of 10 runs
    
%h01 = 1; %/Kinit;
%h02 = 1;

w01 = 1; %/dim;
w02 = 1;
W1 = gamrnd(dim*ones(dim,Kinit),1/dim);
W2 = dim*ones(dim,Kinit);

a01 = bnp_switch*1/Kinit + (1-bnp_switch);
a02 = 1;
A1 = a01 + bnp_switch*1000*ones(1,Kinit)/Kinit;
A2 = a02 + bnp_switch*1000*ones(1,Kinit);

%H1 = ones(Kinit,N);
%H2 = ones(Kinit,N); 

K = Kinit;
num_iter = 100000;
score = zeros(num_iter, 1);

for iter = 1:num_iter

    T = 1 + 0.75^(iter-1); % deterministic annealing temperature

    EW = W1./W2;
    X_reshape = repmat(reshape(X',[1 N dim]),[K 1 1]);
    ElnWA = psi(W1) - log(W2) + repmat(psi(A1)-log(A2),dim,1);
    ElnWA_reshape = repmat(reshape(ElnWA',[K 1 dim]),[1 N 1]);
    t1 = max(ElnWA_reshape,[],1);
    ElnWA_reshape = ElnWA_reshape - repmat(t1,[K 1 1]);
    
    %ElnH = psi(H1) - log(H2);
    ElnH = log(true_patterns);
    % HERE
    P = bsxfun(@plus,ElnWA_reshape/T,ElnH/T);
    P = exp(P);
    P = bsxfun(@rdivide,P,sum(P,1));
    %H1 = 1 + (h01 + sum(P.*X_reshape,3) - 1)/T;
    %H2 = (h02 + repmat(sum(EW.*repmat(A1./A2,dim,1),1),N,1)')/T;
    
    W1 = 1 + (w01 + reshape(sum(X_reshape.*P,2),[K dim])' - 1)/T;
    W2 = (w02 + repmat(sum((true_patterns).*repmat((A1./A2)',1,N),2)',dim,1))/T;
    % HERE
    
    A1 = 1 + (a01 + bnp_switch*sum(sum(X_reshape.*P,3),2)' - 1)/T;
    A2 = (a02 + bnp_switch*sum(W1./W2,1).*sum(true_patterns,2)')/T; 
    % HERE
    
    idx_prune = find(A1./A2 < 10^-3);
    if ~isempty(idx_prune)
      W1(:,idx_prune) = [];
      W2(:,idx_prune) = [];
      A1(idx_prune) = [];
      A2(idx_prune) = [];
      %H1(idx_prune,:) = [];
      %H2(idx_prune,:) = [];
    end
    K = length(A1);
    
     score(iter) = sum(sum(abs(X-(W1./W2)*diag(A1./A2)*(true_patterns))));
     % HERE
     if iter > 1 && abs(score(iter-1)-score(iter)) < 1e-5  
     break
     end
 
end

end_score(i) = score(find(score,1,'last'));  
disp(['Run Number: ' num2str(i) '. Iter Number: ' num2str(iter) '. Iter Score: ' num2str(end_score(i))]); 

% Among the results, use the fitted variational parameters that achieve the HIGHEST ELBO
if i == 1 || (i > 1 && (end_score(i) >= max(end_score)))
    EWA = (W1./W2)*diag(A1./A2);
    EH = true_patterns;
    % HERE
    varWA = ((W1 .* A1) .* (W1 + A1 + 1)) ./ (W2.^2 .* A2.^2);
    varH = 0;
    alphaH = 0;
    betaH = 0;
    alphaW = W1;
    betaW = W2;
    alphaA = A1;
    betaA = A2;
    finalscore = end_score(i);
    final_iter = iter;
end

end
