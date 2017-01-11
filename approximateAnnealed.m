%Approximates the marginal probability of the vertex label using
%variational mean field approximation
%Author: Shaona Ghosh
%Inputs: 
%N : number of vertices in graph G
%G : undirected graph with weights 1 for an edge and 0 for no edge
%L : indices of labelled vertices
%S_o : labels of labelled vertices
%S_all : partially labelled vector
%C : number of classes
%Ctype: type of class mapped from labels to index
%S_true : completely labelled vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[theta] = approximateAnnealed(N, G, L, S_o, S_all, C, Ctype, S_true, theta, U)


%Anneal beta slightly by slowly changing beta
%beta = 1/KT where T is the temperature
betarange = linspace(0.0000001,0.000001,1000);
%no of betas 
betarangesz = length(betarange);

%results over beta range
results_beta = zeros(betarangesz,3);
results_beta(:,1) = betarange;
    

%starting beta
betaiter = 1;

%mapping between actual class label and class ids
Cmap = 1:1:length(Ctype);    

Cmapcpy = Cmap;
for iL = 1:length(L)
    nodeid = L(iL);
    labelnodeid = S_o(iL);
    %for labtyp = 1:length(Ctype)
    idlab = find(Ctype==labelnodeid);
    theta(nodeid,idlab)= 1;
    Cmapcpy(idlab) = [];
    theta(nodeid, Cmapcpy) = 0;
    Cmapcpy = Cmap;
   % end
       
end


prevnormtheta = 1;
normtheta = 0;
nodifference = 1;

%anneal beta
for betait = 1:betarangesz
 
%anneal beta 
beta = betarange(betait);

%while the iteration stabilized for this beta
%while prevnormtheta ~= normtheta 
    
%update marginal probability
theta2 = updatevertexmarginal(N, G, theta, beta, C, Ctype, Cmap, S_all, U) ;    
    
%make it point to updated theta
theta = theta2; 
 
normtheta  = norm(theta);

nodifference = abs(normtheta-prevnormtheta);  

prevnormtheta = normtheta;
%end%while end iteration stabilized for this beta now increase beta slightly 
% if prevnormtheta == normtheta 
%     break;
% end
end


end
