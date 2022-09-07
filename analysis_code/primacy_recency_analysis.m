function [primacy,recency,accuracy_curves] = primacy_recency_analysis(datadir,everyNtrials)
rl = load([datadir '/run_log.mat']); rl=rl.run_log;
nv1 = length(rl.param1_range);
nv2 = length(rl.param2_range);
nnets = 10;
p = load([datadir '/1/1/net1/params.mat']); p=p.p;
seqs = load([datadir '/1/1/net1/seqs.mat']); seqs=seqs.seqs;
fullseqs = repelem(seqs,p.Ntrials,1);
inds2train = 1:everyNtrials:size(fullseqs,1);

% make targets
for word=1:p.n_dif_stims % word IDs
    for sp=1:size(seqs,2) % serial position
        t{word,sp} = (seqs(:,sp) == word);
        full_t{word,sp} = (fullseqs(:,sp) == word);
    end
end

% do training
totalNets = nv1*nv2*nnets;
word_recalls = cell(nv1,nv2,nnets);
parfor netInd=1:totalNets
    [i,j,k] = ind2sub([nv1 nv2 nnets],netInd);
    curdir = [datadir '/' num2str(i) '/' num2str(j) '/net' num2str(k)];
    if (exist([curdir '/sp_accuracies.mat'],'file'))
        disp([curdir ' already done'])
        continue;
    end
    xtr = load([curdir '/x_train.mat']); xtr=xtr.x;
    xtst = load([curdir '/x_test.mat']); xtst=xtst.x;
    a = zeros(p.n_dif_stims,size(seqs,2));
    for word=1:p.n_dif_stims
        for sp=1:size(seqs,2)
            net = perceptron;
            net.trainParam.showWindow = false;
            net = train(net,xtr(inds2train,:)',t{word,sp}');
            y = net(xtst');
            a(word,sp) = sum(y == full_t{word,sp}')/length(full_t{word,sp});
        end
    end
    sp_accuracies = a;
    parsave([curdir '/sp_accuracies.mat'],sp_accuracies,'sp_accuracies')
end
[primacy,recency,accuracy_curves] = load_primacy_recency(datadir);
end