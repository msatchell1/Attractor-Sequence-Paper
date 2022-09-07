function [x_train,x_test] = make_xtrain_xtest(datadir)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% This function extracts the final  network states (using the mean firing
% rate of each unit over time period 250ms - 1250ms after the offset of the final
% stimulus) from the rates.mat files saved by the simulation code. These
% final network states are then saved into the matrices x_train and x_test
% to be used in much of the decoding and other analyses. x_train and x_test
% have the same number of rows (ntrials*nseqs) and same number of columns
% (p.Ne = # of excitatory units).
%
% Inputs:
% 1. datadir: directory containing all of the data for a particular network
%
% Outputs:
% 1. x_train: a (ntrials*nseqs x p.Ne) matrix (p.Ne = # of excitatory
%             units) containing in each row i the final network state
%             produced by a presentation of a stimulus sequence (in the training set)
%             . e.g. if there are 10 sequences and 10 trials/sequence, rows 1:10 will
%             contain the final network states produced by the 10 trials of
%             sequence 1 while the 11th row will contain the final network
%             state produced by the 1st trial of the 2nd sequence
% 2. x_test: same as x_train but for all of the test trials
params = load([datadir '/params.mat']); params=params.p;
seqs = load([datadir '/seqs.mat']); seqs = seqs.seqs; nseqs = 2*size(seqs,1); %remember to change back
ntrials = params.Ntrials;
tgt_dir = [datadir '/target_trials'];
tst_dir = [datadir '/test_trials'];    
count = 0;
for i=1:nseqs
    tgt_r = load([tgt_dir '/seq' num2str(i) '/rates.mat']); tgt_r=tgt_r.rates;
    tgt_soff = load([tgt_dir '/seq' num2str(i) '/stim_off_times.mat']); tgt_soff=tgt_soff.stim_off_times;
    tst_r = load([tst_dir '/seq' num2str(i) '/rates.mat']); tst_r=tst_r.rates;
    tst_soff = load([tst_dir '/seq' num2str(i) '/stim_off_times.mat']); tst_soff=tst_soff.stim_off_times;
    for j=1:ntrials
        count = count+1;
        soff1 = tgt_soff{j}(end);
        soff2 = tst_soff{j}(end);
        x_train(count,:) = mean(tgt_r{j}(1:params.Ne,(soff1+(.25/params.dt)):(soff1+(1.25/params.dt))),2);
        x_test(count,:) = mean(tst_r{j}(1:params.Ne,(soff2+(.25/params.dt)):(soff2+(1.25/params.dt))),2);
    end
end
x = x_train;
save([datadir '/x_train.mat'],'x','-mat')
x = x_test;
save([datadir '/x_test.mat'],'x','-mat')
end
