% For running linear classification model trainings on provided random
% seeds, classification specifications, etc.

num_mdls = 2;% number of models to create.

% I may want to vary these in a for loop running Train_LinClass with
% num_mdls = 1 to get models with different stimulus inputs (regulated by
% the seed) and different labelling (clsf_index_arrays). To get lots of
% data points using the same stimuli combinations (same seed) I 
clsf_index_arrays = [1,1 ; 1,1];
seed = [5]; 

[LCOs] = Train_LinClass(num_mdls,clsf_index_arrays,seed);




%% Analysis of models

W1 = LCOs(1).Mdl.Beta; W2 = LCOs(2).Mdl.Beta;

% Normalize the hyperplane vectors to unit length
W1 = W1/norm(W1); W2 = W2/norm(W2);

% Calculate dot product between the vectors
dotp = dot(W1, W2)