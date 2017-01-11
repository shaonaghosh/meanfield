%Main Script for calling the data manipulation functions and mean field
%variational approximation routine
%Author: Shaona Ghosh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
[N, G, L, S_o, S_all, C, Ctype, S_true] = parsedata()

%Online learning
%find the unlabelled vertices
U = find(S_all == 0);

%initialize labels to zero for the unlabelled vertices
S = zeros(length(U),1);

%take a random permutation on the unlabelled nodes to query for prediction
rand_U = randperm(length(U));
rand_U = U(rand_U);

Ucopy = U;

%for measuring mistakes and accuracy 
mistakes = 0;
S_pred = zeros(length(U),1);

%number of trials
notrials = 10;

%mean of error
meanerror = zeros(notrials,1);
meanexperror = zeros(notrials,1);
meanaccuracy = zeros(notrials,1);


%number of trials
for trialno = 1:10
    
expectederror = 0;
expectedaccuracy = 0;
error = 0;
mistakes = 0;


%marginal probabilities
theta = 0.5 * ones(N,C);


%loop through all the unlabelled vertices until all labelled
%loop until convergence
%for iter = 1:length(rand_U)%for loop begin for online mode
    %approximate variational inference before predicting the label of this
    %vertex
    theta2 = approximateAnnealed(N, G, L, S_o, S_all, C, Ctype, S_true, theta, U);


    %update marginal probability
    %theta2 = updatevertexmarginal(N, G, theta, beta, L_C, C, Ctype, Cmap, S_all, U) ;
    
    %make it point to updated theta
    theta = theta2;
for iter = 1:length(rand_U) %for loop begin for batch mode
    %queried vertex
    q = rand_U(iter);
    
    %predict with class that has highest marginal
    marginals_q = theta(q,:);
    [maxtheta, class] = max(marginals_q);
    y_hat = Ctype(class);
    
    %receive true labels and update
    y_true = S_true(q);
    
    %remove this vertex from unlabelled
    %rand_U(iter) = [];
    %U(U==q) = [];
    
       
    theta(q,class) = 1;%updating the probab of this class to 1 now that true is known
    othercls = 1:1:C;
    theta_jclasses = find(othercls ~= class);
    for jj = 1:length(theta_jclasses)
        theta(q,theta_jclasses(jj)) = 0;
    end
    
    %calculate the expected error - sum of probabilities of making an error
    for len = 1:length(marginals_q)
    classlen = Ctype(len);
    if classlen ~= y_true
        expectederror = expectederror + marginals_q(len);
        
    else
        expectedaccuracy = expectedaccuracy + marginals_q(len);
    end
    end
   
    %measure performance
    if y_true ~= y_hat
        mistakes = mistakes + 1;
    end

end%for loop end for offline batch mode

    S_pred(q) = y_hat;
    
    %update partially labelled vector
    S_all(q) = y_true;
    %add new label to labels of labelled vertices
    S_o(length(S_o)+1) = y_true;
    %add to index to labelled vertices
    L(length(L)+1) = q;
    %remove q from unlabelled vertices array
    idq = find(U == q);
    U(idq) = [];
    %repeat the whole annealing process now with new information
    
%end %For loop end for online mode
%accuracy and error
error = mistakes/iter;
expectederror = expectederror/iter;
expectedaccuracy = expectedaccuracy/iter;

meanerror(trialno) = error;
meanexperror(trialno) = expectederror;
meanaccuracy(trialno) = expectedaccuracy;
end

%find mean and s.dev
meanerrorfinal = mean(meanerror);
sdmeanerror = std(meanerror);

meanexperrorfinal = mean(meanexperror)
stdexperrorfinal = std(meanexperror)






