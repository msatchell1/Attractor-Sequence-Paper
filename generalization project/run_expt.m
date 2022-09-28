function [] = run_expt(p,seqs,basedir,init_type,memoptimize,delrfiles)
% wrapper function to run "experiments" for the paper. Each experiment
% consists of running each sequence p.ntrials times to form the "target
% trials" and then doing the same thing to run the "test" trials
% Inputs
% 1. p: parameter structure from make_params()
% 2. seqs: matrix where each row is a sequence and the values represent the
%          stimulus IDs
% 3. basedir: path to top level of directory in which to save results
% 4. init_type: passed to run_network()
%                   options:
%                       'silent'
%                       'random'
%                       'constant'
% 5. memoptimize: 'yes' or 'no' to the option to return dynamical variables
%                  D and s with all timesteps or just the last timestep.
%                  Recommended to use 'yes' unless explicityly analyzing D
%                  and s
% 6. delrfiles: 'yes' or 'no' to the option to delete rate.mat files that
%                are produced. Recommended to do this unless wanting to
%                plot the rates as a function of time. These files can take
%                up a lot of memory quite quickly
if (~exist(basedir,'dir'))
    mkdir(basedir)
end
save([basedir '/params.mat'],'p','-mat')
save([basedir '/seqs.mat'],'seqs','-mat')
rundir = [basedir '/target_trials']; mkdir(basedir,'target_trials');
nseqs = size(seqs,1);
% run target trials
for i=1:nseqs
    seq = seqs(i,:);
    mkdir(rundir,['seq' num2str(i)]);
    rates = cell(p.Ntrials,1);
    stim_on_times = cell(p.Ntrials,1);
    stim_off_times = cell(p.Ntrials,1);
    for j=1:p.Ntrials
        [Iapp,stim_on,stim_off] = make_Iapp(p,seq);
        [r] = run_network(p,Iapp,init_type,memoptimize);
        rates{j} = r;
        stim_on_times{j} = stim_on;
        stim_off_times{j} = stim_off;  
    end
    save([rundir '/seq' num2str(i) '/rates.mat'],'rates','-mat')
    save([rundir '/seq' num2str(i) '/stim_on_times.mat'],'stim_on_times','-mat')
    save([rundir '/seq' num2str(i) '/stim_off_times.mat'],'stim_off_times','-mat')
    clear rates stim_on_times stim_off_times
end
% run test trials
rundir = [basedir '/test_trials']; mkdir(basedir,'test_trials');
for i=1:nseqs
    seq = seqs(i,:);
    mkdir(rundir,['seq' num2str(i)]);
    rates = cell(p.Ntrials,1);
    stim_on_times = cell(p.Ntrials,1);
    stim_off_times = cell(p.Ntrials,1);
    for j=1:p.Ntrials
        [Iapp,stim_on,stim_off] = make_Iapp(p,seq);
        [r] = run_network(p,Iapp,init_type,memoptimize);
        rates{j} = r;
        stim_on_times{j} = stim_on;
        stim_off_times{j} = stim_off;  
    end
    save([rundir '/seq' num2str(i) '/rates.mat'],'rates','-mat')
    save([rundir '/seq' num2str(i) '/stim_on_times.mat'],'stim_on_times','-mat')
    save([rundir '/seq' num2str(i) '/stim_off_times.mat'],'stim_off_times','-mat')
    clear rates stim_on_times stim_off_times
end

calc_all_perm_tcs(basedir, 'target_trials', nseqs);
calc_all_perm_tcs(basedir, 'test_trials', nseqs);

calc_all_perm_confusability_matrix(basedir,nseqs);
save([basedir '/confusability_matrix.mat'],'cm','-mat')

make_xtrain_xtest(basedir);

switch delrfiles
    case 'yes'
        del_r_files([basedir '/target_trials'],64);
        del_r_files([basedir '/test_trials'],64);
end

%{
[target, seqsToTrain] = generate_perceptron_target(seqs,[0 1 2 4 5 6]);
seqsToTrain = repmat(seqsToTrain,p.Ntrials,1);
target = repmat(target,1,p.Ntrials);
[accuracy,net] = choice_analysis(x_train,x_test,target,seqsToTrain);
save([basedir '/choice_accuracy.mat'],'accuracy','-mat')
save([basedir '/net.mat'],'net','-mat')
%}
end

