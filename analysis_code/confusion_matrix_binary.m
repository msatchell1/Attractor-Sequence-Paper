function [cm] = confusion_matrix_binary(dirname,nseqs)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% This function computes the confusion matrix for 1 network using only the
% binarized final states of the network resulting from each sequence
% (contained in Xtrain and Xtest). All confusion matrices and kappa values
% presented in the paper were generated using this function
% 
% Inputs:
% 1. dirname: path to directory containing the data for 1 network
% 2. nseqs: number of sequences tested in this network
%
% Outputs:
% 1. cm: (nseqs x nseqs) matrix where each (i,j) gives the fraction of
%        times where the final (binarized) network activity produced by test 
%        sequence j was identified as most closely matching the mean final
%        activity produced by target sequence i
xtr = load([dirname '/x_train_bin.mat']); xtr=xtr.x;
xtst = load([dirname '/x_test_bin.mat']); xtst=xtst.x;
tgt_p = load([dirname '/params.mat']); tgt_p=tgt_p.p;
tst_p = load([dirname '/params.mat']); tst_p=tst_p.p;
cm = zeros(nseqs,nseqs);
for i=1:nseqs % test sequence
    for j=1:tgt_p.Ntrials % trial of test sequence
        best = 0;
        best_dif = intmax;
        for k=1:nseqs % target sequence
            tgt = mean(xtr(((k-1)*tgt_p.Ntrials+1):k*tgt_p.Ntrials,:),1);
            tst = xtst((i-1)*tst_p.Ntrials+j,:);
            taxi_dist = sum(abs(tst-tgt));
            if (taxi_dist < best_dif)
                best_dif = taxi_dist;
                best = k;
            end
        end
        cm(best,i) = cm(best,i)+1;
    end
end
cm = cm/tgt_p.Ntrials;
end

