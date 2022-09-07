function [  ] = del_r_files( base_dir,nseqs)
% Deletes rates.mat files produced by simulation code in order to save hard
% drive space
% Inputs:
% 1. base_dir: path to directory one level above the seq directories
%    e.g. path_to_sweep_directory/1/1/net1/target_trials
% 2. nseqs: # of seq folders in the base_dir directory
% delete rate.mat files to save space
for i=1:nseqs
    fname = [base_dir '/seq' num2str(i) '/rates.mat'];
    delete(fname)
end
end

