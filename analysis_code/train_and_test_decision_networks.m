function [] = train_and_test_decision_networks(basedir,trainseqsums,testseqsums,traintype,allowskip)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% This function trains perceptrons to make binary decisions for the
% 2-choice task based on the final state of the network (stored in x_train
% and x_test). Each perceptron is trained on the set (or subset) of
% sequences that have an unequal number of each stimulus type.
% Additionally, each perceptron is trained on each trial in a random order
% (this matters when considering which sequences errors are made on)
%
% Inputs:
% 1. basedir: path to the top level directory of a parameter sweep (1D or
%             2D)
% 2. trainseqsums: determines which sequences the perceptrons are trained
%                  on. e.g. in order to train only on sequences that have
%                  4 "left" stimuli, trainseqsums should be 4. To train on
%                  sequences that have either 2 or 4 "left" stimuli,
%                  trainseqsums = [2 4]
% 3. testseqsums: same as trainseqsums but determining which sequences the
%                 perceptrons are tested on
% 4. traintype: determines the training regime used. All data presented in
%               the paper used either 'standard' or 'train_rand_order_binary' options
% 5. allowSkip: 'yes' or 'no' option to allow skipping if the function
%               detects that the requested training/testing has already
%               been done
rl = load([basedir '/run_log.mat']); rl=rl.run_log;
if (isfield(rl,'param_range'))
    nv = length(rl.param_range);
    nv1=NaN;
    nv2=NaN;
    sweep1D = 1;
    disp('sweep1D')
else
    nv1 = length(rl.param1_range);
    nv2 = length(rl.param2_range);
    nv=NaN;
    sweep1D = 0;
end
doBinary = 0;
switch traintype
    case 'standard'
        savestr = ['_train' sprintf('%d',trainseqsums) '_binary'];
        doBinary=1;
    case 'same-first-last'
        savestr = '_same_first_last';
    case 'first-opposite-choice'
        savestr = '_first_opposite_choice';
    case 'last-opposite-choice'
        savestr = '_last_opposite_choice';
    case 'train_rand_order'
        savestr = '_train_rand_order';
    case 'train_rand_order_binary'
        savestr = '_train_rand_order_binary';
        doBinary = 1;
end
nnets = rl.nnets;
if (sweep1D)
    totalNets = nv*nnets;
else
    totalNets = nv1*nv2*nnets;
end
parfor netInd=1:totalNets
    if (sweep1D)
        [i,j] = ind2sub([nv nnets],netInd);
        k=0;
        curdir = [basedir '/' num2str(i) '/net' num2str(j)];
    else
        [i,j,k] = ind2sub([nv1 nv2 nnets],netInd);
        curdir = [basedir '/' num2str(i) '/' num2str(j) '/net' num2str(k)];
    end
    if ((i~=6) || (j~=6))
        disp(['Skipping (' num2str(i) ',' num2str(j) ')'])
        continue;
    end
    if (strcmp(allowskip,'yes') && exist([curdir '/choice_accuracy' savestr '.mat'],'file'))
        disp('already done')
        if (sweep1D)
            disp([num2str(i) ' ' num2str(j) ' already done'])
        else
            disp([num2str(i) ' ' num2str(j) ' ' num2str(k) ' already done'])
        end
        continue;
    end
    if (doBinary)
        xtr = load([curdir '/x_train_bin.mat']); xtr=xtr.x;
        xtst = load([curdir '/x_test_bin.mat']); xtst=xtst.x;
    else
        xtr = load([curdir '/x_train.mat']); xtr=xtr.x;
        xtst = load([curdir '/x_test.mat']); xtst=xtst.x;
    end
    seqs = load([curdir '/seqs.mat']); seqs=seqs.seqs;
    [train_target,test_target,seqs2train,seqs2test] = generate_perceptron_target(seqs,trainseqsums,testseqsums,traintype);
    train_target = repelem(train_target,1,10);
    test_target = repelem(test_target,1,10);
    seqs2train = repelem(seqs2train,10,1);
    seqs2test = repelem(seqs2test,10,1);
    [choice_accuracy,y,net] = choice_analysis(xtr,xtst,train_target,test_target,seqs2train,seqs2test);

    parsave([curdir '/train_target' savestr '.mat'],train_target,'train_target')
    parsave([curdir '/test_target' savestr '.mat'],test_target,'test_target')
    parsave([curdir '/seqs2train' savestr '.mat'],seqs2train,'seqs2train')
    parsave([curdir '/seqs2test' savestr '.mat'],seqs2test,'seqs2test')
    parsave([curdir '/choice_accuracy' savestr '.mat'],choice_accuracy,'accuracy')
    parsave([curdir '/y' savestr '.mat'],y,'y')
    parsave([curdir '/net' savestr '.mat'],net,'net')
    if (sweep1D)
        disp([num2str(i) ' ' num2str(j)])
    else
        disp([num2str(i) ' ' num2str(j) ' ' num2str(k)])
    end
end
end

