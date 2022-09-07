function [dif_last_error_rates,not_dif_last_error_rates] = get_dif_last_error_rates(datadir)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% This function calculates, for each network in a parameter sweep, the
% 2-choice error rates among sequences where the last stimulus in the
% sequence is or is not the "same" or "opposite" the correct choice. e.g.
% in the sequence "LLRLRL" the last stimulus (L="left") is also the same as
% the correct choice ("left")
%
% Inputs:
% 1. datadir: path to the top level directory of a parameter sweep
%
% Outputs:
% 1. dif_last_error_rates: (nv1 x nv2 x nnets) matrix where each element
%                           (i,j,k) gives the mean choice error rate among
%                           sequences where the last stimulus is opposite
%                           the correct choice for the k'th network tested
%                           with the i'th value of parameter 1 and the j'th
%                           value of parameter 2
% 2. not_dif_last_error_rates: The same as dif_first_error_rates but for
%                               sequences where the last stimulus equals the
%                               correct choice
rl = load([datadir '/run_log.mat']); rl=rl.run_log;
nv1 = length(rl.param1_range);
nv2 = length(rl.param2_range);
nnets = rl.nnets;

for i=1:nv1
    for j=1:nv2
        for k=1:nnets
            curdir = [datadir '/' num2str(i) '/' num2str(j) '/net' num2str(k)];
            y = load([curdir '/y_train_rand_order.mat']); y=y.y;
            test_target = load([curdir '/test_target_train_rand_order.mat']); test_target=test_target.test_target;
            seqs = load([curdir '/seqs.mat']); seqs=seqs.seqs;
            longseqs = repelem(seqs,10,1);
            seqsum = sum(longseqs-1,2);
            even_seqs = (seqsum == 3);
            not_even_seqs = longseqs(~even_seqs,:)-1;
            not_even_y = y(~even_seqs);
            not_even_target = test_target(~even_seqs);
            dif_last = (not_even_seqs(:,end)~=not_even_target');
            errors = (not_even_y ~= not_even_target);
            dif_last_errors = errors(dif_last);
            ndif_last_errors(i,j,k) = sum(dif_last_errors);
            n_not_dif_last_errors(i,j,k) = sum(errors(~dif_last));
            dif_last_error_rates(i,j,k) = ndif_last_errors(i,j,k)/sum(dif_last);
            not_dif_last_error_rates(i,j,k) = n_not_dif_last_errors(i,j,k)/sum(~dif_last);
        end
    end
end
end

