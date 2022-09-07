function [corrs] = get_unit_correlations(datadir,corrType)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% This function is used to compute the correlations between the final activity of
% each unit in the network (binarized activity to be either "on" or "off")
% and the ID of the first stimulus ("left" or "right"), last stimulus
% ("left" or "right"), or the number of "left" (or "right") stimuli in the
% sequence
% Inputs:
% 1. datadir: path to directory of a specific network
% 2. corrType: string ('nstimuli','firstStim', or 'lastStim') determining
%              with which feature of the stimulus sequence each unit's
%              acivity is being correlated with
% 3. corrs: vector of length p.Ne (# of excitatory units) giving the
%           correlation of each unit with the desired stimulus feature
xtr=load([datadir '/x_train_bin.mat']); xtr=xtr.x;
seqs=load([datadir '/seqs.mat']); seqs=seqs.seqs;
repseqs=repelem(seqs,10,1);
seqsum = sum(repseqs-1,2);
p = load([datadir '/params.mat']); p=p.p;
for i=1:p.Ne
    final_states = xtr(:,i);
    switch corrType
        case 'nstimuli'
            curr_corr = corr([final_states seqsum]);
            corrs(i) = curr_corr(1,2);
        case 'firstStim'
            curr_corr = corr([final_states repseqs(:,1)]);
            corrs(i) = curr_corr(1,2);
        case 'lastStim'
            curr_corr = corr([final_states repseqs(:,end)]);
            corrs(i) = curr_corr(1,2);
    end
end
end

