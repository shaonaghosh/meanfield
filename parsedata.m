%Function to read data files. 
%Author: Shaona Ghosh
% Arg 1: number of instances in datset
% Arg 2: Trial number, each trial is a randomly sampled graph from the
% dataset
%Return
%N:number of vertices of the graph
%G: Unweighted and undirected graph
%L: Graph Laplacian
%S_o: Available labelled vertices
%S_all: Partially labelled vector
%C: Number of classes
%Ctype: Class type
%S_true: True labels/ground truth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
function[N, G, L, S_o, S_all, C, Ctype,S_true] = parsedata() %input arguments for dataset files are n, run
   if nargin <= 1
    datasetfilename = sprintf('%s%s', 'simgraphtestcase1',  '.csv');
   else
    datasetfilename = sprintf('%s%d%d%s', 'datasetgraph', n, run, '.csv'); 
   end
   datasetfilepath = fullfile(pwd,datasetfilename);
   
   %Read the data
   try
   fid = fopen(datasetfilename,'r+');
   data = textscan(fid, repmat('%d',1,3),  'delimiter', ',', 'CollectOutput', 1);
   catch exception
       datasetfilename
   end
   
   data = data{1};
   %Unweighted graph construction
   E = data(:,1:2);
   E = double(E);
   A = sparse(E(:,1),E(:,2),1);
   degrees = sum(A,2);
   
   fclose(fid);  
    
   %Available labels
   if nargin < 1
        f_j = [-1 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0];%Partially labelled vector for simulated data
        labnodes = [1, 6, 9];                      %Labelled vertices
        S_true = [-1,-1,-1,-1,-1,1,-1,-1,1,1,1,1]; %True labels 
   else
    %available labels for the dataset
    labsetfilename = sprintf('%s%d%d%d%s', 'labset', n, run, 0, '.csv'); %available labels for dataset
    labsetfilepath = fullfile(pwd,labsetfilename);
    labels = csvread(labsetfilepath);
    labels = labels(:,2);
    labels(labels==0) = -1;
    labels(labels==1) = 1;
    S_true = labels;
   
     
    availabfilename = sprintf('%s%d%d%s', 'trainingset', n, run,'.csv'); 
    
    availlabfilepath = fullfile(pwd, availabfilename);
    availlab = csvread(availlabfilepath);
    
    nlab = length(availlab);
    
    nlabhalf = nlab/2;
    availlabels = availlab(:,2);
    availabnodes = availlab(:,1);
    
    [id1s,partlab1] = find(availlabels == 1);
    nodelab1 = availabnodes(id1s)';
    [id2s,partlab2] = find(availlabels == -1);
    nodelab2 = availabnodes(id2s)';
    partlab2 = -1*partlab2;
    partlab1 = partlab1';
    partlab2  = partlab2';
    labnodes = horzcat(nodelab1,nodelab2);
    S_lab =  horzcat(partlab1,partlab2);
   %marginal probabilities
    f_j = zeros(n,1);
    f_j(labnodes) = S_lab;
    
   end
    
    
   %return
   G = A;
   L = labnodes;
   S_all = f_j;
   N = length(f_j);
   S_o = zeros(1,length(labnodes));
   S_o = f_j(labnodes);
   C = 2;
   Ctype = [-1,1];
end