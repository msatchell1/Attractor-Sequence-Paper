function [LCp] = make_LC_params()
% For making linear classification parameters. Must be called after
% make_params_genr().

% Unformatted data from simulations and parameter scans.
LCp.types = [];
LCp.r_avg = [];


LCp.X = []; % Formatted avg firing rates so that each row is a data point X.
LCp.X_types = []; % Formatted type combs where each row holds stimulus info 
% used in that simulation. Row data in X correspond to the same row in
% X_types.

LCp.X_labels = []; % Binary labels for SVM indicating whether data cointains 
% "correct" choice or not. 




end