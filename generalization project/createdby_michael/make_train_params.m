function [tp] = make_train_params(varargin)
% For holding parameters that go across simulations. All models in
% run_trainings will use these parameters.
% Inputs:
% 1. varargin: You can provide pairs of strings and numeric values to
% define parameters externally (for instance when doing a parameter sweep).
% These inputs must follow the form (string,value,string,value). Therefore
% all odd indices of varargin should be parameter names and all even
% numbered indices should be parameter values. The parameter does not have
% to be defined already for me to pass it in - I can define new parameters
% externally!

tp.num_mdls = 2; % number of models to create.

tp.num_char = 2;
tp.num_type = 2;

tp.stim_seeds = [15,15]; % Must have length = num_mdls

tp.clsf_index_array = []; % Holds the char-type combo to seperate data for 
% the SVM of each model.



% Read in arbitrary number of desired parameter values. This has to come
% before doing any calculations that involve values passed in to
% make_params_genr().
for i=1:(length(varargin)/2)
    ind1 = 2*i - 1;
    tp.(varargin{ind1}) = varargin{ind1+1};
end



% Create array of type combinations:
types = cell(1, tp.num_char); % This will hold the vectors representing the types for
% each characteristic.
for char = 1:tp.num_char
    types{char} = 1:tp.num_type;
end
tp.type_combs =  combvec(types{:}); % Loads all of these vectors into combvec which creates a 
% matrix that is num_types x (total # of combinations). Each column of
% type_combs is a possible combination.



end