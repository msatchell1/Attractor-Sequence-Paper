function [worstSeqs,worstErrRates] = analyze_choices(netdir,nnets,field,doplot,dosave,saveStr)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% This function was mainly used to generate plots. It analyzes the choice errors
% across all networks for a particular parameter set (specified by netdir)
% Inputs:
% 1. netdir: path to directory containing the data for the nnets networks
% 2. nnets: number of networks to analyze at this parameter set (usually
%           10)
% 3. field: string specifying the type of training used to train the
%           decision making network (perceptron). e.g. In some cases the
%           perceptrons were only trained on a subset of the sequences
% 4. doplot: 'yes' or 'no' specifying whether to generate plots or not
% 5. dosave: 'yes' or 'no' specifying whether to save the plots or not
% 6. saveStr: if dosave=='yes' then the figure will be stored in file with
%             with the path/name defined by saveStr
% Outputs:
% 1. worstSeqs: For the training type specified by the input "field", this
%               variable will contain the sequences sorted by which sequences had the
%               highest error rates (e.g. first row contains the sequence with the
%               highest error rate)
% 2. worstErrRates: The error rates corresponding to the sequences in
%                   worstSeqs
for net=1:nnets
    curdir = [netdir '/net' num2str(net)];
    seqs = load([curdir '/seqs.mat']); seqs=seqs.seqs;
    seqsum = sum(seqs-1,2);
    even_seqs = (seqsum == 3);
    good_seqs = seqs(~even_seqs,:);
    seq_inds = (1:size(good_seqs,1))';
    good_seqsum = sum(good_seqs-1,2);
    p = load([curdir '/params.mat']); p = p.p;
    large_even_seqs = repelem(even_seqs,p.Ntrials,1);
    large_seqs = repelem(good_seqs,p.Ntrials,1);
    large_seqsum = repelem(good_seqsum,p.Ntrials,1);
    n_seqs_per_sum = zeros(1,max(seqsum)+1);
    for i=1:length(n_seqs_per_sum)
        n_seqs_per_sum(i) = length(find(large_seqsum == i-1));
    end
    large_seq_inds = repelem(seq_inds,p.Ntrials,1);
    
    seqsTrained = load([curdir '/seqs2train_' field '.mat']); seqsTrained = seqsTrained.seqs2train;
    seqsTested = load([curdir '/seqs2test_' field '.mat']); seqsTested = seqsTested.seqs2test;
    seqsTrained = seqsTrained(~large_even_seqs);
    seqsTested = seqsTested(~large_even_seqs);
    
    ca = load([curdir '/choice_accuracy_' field '.mat']); ca=ca.accuracy;
    y = load([curdir '/y_' field '.mat']); y=y.y;
    test_target = load([curdir '/test_target_' field '.mat']); test_target=test_target.test_target;
    errors = (y ~= test_target);

    error_count = zeros(size(good_seqs,1),1);
    err_by_net_ev = zeros(1,max(seqsum)+1);
    for i=1:length(errors)
        error_count(large_seq_inds(i)) = error_count(large_seq_inds(i)) + errors(i);
        err_by_net_ev(large_seqsum(i)+1) = err_by_net_ev(large_seqsum(i)+1) + errors(i);
    end
    seqErrorRates = error_count/p.Ntrials;
    fracTrCorrect = sum(y(seqsTrained)' == test_target(seqsTrained)')/sum(seqsTrained);
    fracNotTrCorrect = sum(y(~seqsTrained)' == test_target(~seqsTrained)')/sum(~seqsTrained);
    
    fracTrainedCorrect(net) = fracTrCorrect;
    fracNotTrainedCorrect(net) = fracNotTrCorrect;
    
    error_rates(net,:) = seqErrorRates;
    errors_by_net_ev(net,:) = err_by_net_ev./n_seqs_per_sum;
end
mean_error_rates = mean(error_rates,1);
[worstErrRates,worstSeqInds] = sort(mean_error_rates,'descend');
worstSeqs = good_seqs(worstSeqInds,:);
worstErrRates = mean_error_rates(worstSeqInds);
xrng = 0:6;
switch doplot
    case 'yes'
        figure;
        subplot(1,2,1)
        h1 = boxplot((1 - errors_by_net_ev(:,[1:3 5:7])),{'0','1','2','4','5','6'}); 
        ylim([0 1])
        %shadedErrorBar(xrng,mean(errors_by_net_ev,1),std(errors_by_net_ev,[],1))
        %set(gca,'xtick',xrng,'xticklabels',xrng); ylim([0 1]); 
        set(h1,'LineWidth',3)
        xlabel('# of left cues','FontSize',20,'FontWeight','bold'); 
        ylabel('Fraction Choices Correct','FontSize',20,'FontWeight','bold')

        subplot(1,2,2)
        h2 = boxplot([fracTrainedCorrect' fracNotTrainedCorrect'],{'Trained',' Not Trained'});
        ax=gca; ax.XAxis.TickLabelInterpreter = 'latex'; set(gca,'XTickLabels',{'\bf Trained', '\bf Not Trained'})
        ylim([0 1]); 
        ylabel('Fraction Choices Correct','FontSize',20,'FontWeight','bold')
        %{
        for i=1:length(xlbl)
            xlbl(i) = {num2str(x
        %}
        set(h2,'LineWidth',3)
        switch dosave
            case 'yes'
                saveas(gcf,saveStr,'fig')
                %saveas(gcf,saveStr,'tiffn')
                print(saveStr,'-dtiffn','-r300')
        end
    case 'no'
end
end

