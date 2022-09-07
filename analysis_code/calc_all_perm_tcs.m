function [ all_tcs ] = calc_all_perm_tcs(base_dir, dirType, nseqs)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% Wrapper code to run calc_tuning_curves for all sequences
% Inputs:
% 1. base_dir: path to directory containing the subfolders "target_trials"
%              and "test_trials"
% 2. dirType: either "target_trials" or "test_trials"
% 3. nseqs: The number of sequences run for this network (should = the
%           number of subdirectories in each of "target_trials" or
%           "test_trials"
% Outputs:
% 1. all_tcs: cell array where each entry all_tcs{i} contains the matrix of
%             tuning curves for the network for sequence i
for i=1:nseqs
    data_dir = [base_dir '/' dirType '/seq' num2str(i)];
    tcs = calc_tuning_curves(data_dir,base_dir);
    all_tcs{i} = tcs;
    save([data_dir '/tuning_curves.mat'],'tcs','-mat')
end
end

