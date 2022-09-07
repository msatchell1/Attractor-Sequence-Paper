%make_paper_figures_ordered
% This script was used to generate all figures in the paper except for Fig.
% 9. It requires all of the data files (these are quite large files which are 
% available upon request) in order to generate the figures.
%% define folders/sweeps to analyze
datadirs{1} = 'We0_Wee_sweep_noise000';
datadirs{2} = 'We0_Wee_sweep_noise002';
datadirs{3} = 'dif_start_We0_Wee_sweep_noise000';
datadirs{4} = 'dif_start59_We0_Wee_noise000';
datadirs{5} = 'dif_start59_stim20_We0_Wee_noise000';
datadirs{6} = 'We0_Wee_sweep_noise000_amp100_110';
datadirs{7} = 'no_D_We0_Wee_sweep_noise000';
datadirs{8} = 'Wei_Wie_sweep_noise000';
datadirs{9} = 'Wei_Wie_sweep_noise002';
datadirs{10} = 'variable_amplitudes_Wei_Wie_sweep_noise000';
datadirs{11} = 'variable_durations_Wei_Wie_sweep_noise000';
datadirs{12} = 'We0_sweep_noise000';
datadirs{13} = 'no_EE_We0_sweep_noise000';
datadirs{14} = 'dif_start20_stim20_We0_Wee_noise000';
datadirs{15} = 'We0_Wee_sweep_noise000_amp100_110';
datadirs{16} = 'We0_Wee_dif_stim_int';
datadirs{17} = 'We0_Wee_word_seq';
datadirs{18} = 'no_D_We0_Wee_sweep_dif_area';
datadirs{19} = 'We0_Wee_Iapp_generalization';
datadirs{20} = 'We0_Wee_word_seq_noise002';
datadirs{21} = 'no_D_We0_Wee_word_seq_dif_area';
interpFactor = 100;
%field1 = 'confusability_matrix';
field1 = 'cm_binary';
field2 = 'choice_accuracy_train_rand_order';
%field2 = 'choice_accuracy_train012456';
fig_version = 'final_version2'; mkdir(['figures/' fig_version])
titleStr = '';
%% r,D,s dynamics - Figure 2
saveDir = ['figures/' fig_version '/2']; mkdir(saveDir)
saveStr = [saveDir '/rDs_example'];
r = load('figures/r_dynamics.mat'); r=r.r;
D = load('figures/D_dynamics.mat'); D=D.D;
s = load('figures/s_dynamics.mat'); s=s.s;
cell1 = 6; %was 6
cell2 = 10; %was 30 8 is good
tvec=0:.001:12;
subplot(3,1,1); plot(tvec,r(cell1,:),'LineWidth',4); hold on; plot(tvec,r(cell2,:),'LineWidth',4)
ylabel('r','FontSize',30,'FontWeight','bold')
subplot(3,1,2); plot(tvec,D(cell1,:),'LineWidth',4); hold on; plot(tvec,D(cell2,:),'LineWidth',4)
ylabel('D','FontSize',30,'FontWeight','bold')
subplot(3,1,3); plot(tvec,s(cell1,:),'LineWidth',4); hold on; plot(tvec,s(cell2,:),'LineWidth',4)
ylabel('s','FontSize',30,'FontWeight','bold'); xlabel('Time (s)','FontSize',30,'FontWeight','bold')
saveas(gcf,saveStr,'fig')
%saveas(gcf,saveStr,'tiffn')
print(saveStr,'-dtiffn','-r300')
close all;

%% Good & bad confusion matrices - Figure 3
saveDir = ['figures/' fig_version '/3']; mkdir(saveDir)
saveStr = [saveDir '/good_bad_confusion_matricies'];
cmGood = load(['data/' datadirs{1} '/5/5/net1/cm_binary.mat']); cmGood=cmGood.cm;
cmBad = load(['data/' datadirs{2} '/1/1/net1/cm_binary.mat']); cmBad=cmBad.cm;
subplot(1,2,1); imagesc(cmGood); colormap(jet); h1 = colorbar(); ylabel(h1,'Sequence Discrimination','FontSize',25)
set(gca,'XTick',[1 64],'YTick',[1 64],'XTickLabel',{'1','64'},'YTickLabel',{'1','64'},'FontSize',25)
xlabel('Test sequences','FontSize',30,'FontWeight','bold'); ylabel('Train sequences','FontSize',30,'FontWeight','bold')
subplot(1,2,2); imagesc(cmBad); colormap(jet); h2 = colorbar(); ylabel(h2,'Sequence Discrimination','FontSize',25)
set(gca,'XTick',[1 64],'YTick',[1 64],'XTickLabel',{'1','64'},'YTickLabel',{'1','64'},'FontSize',25)
xlabel('Test sequences','FontSize',30,'FontWeight','bold'); ylabel('Train sequences','FontSize',30,'FontWeight','bold')
set(gcf,'Position',[10 10 1000 375])
saveas(gcf,saveStr,'fig')
%saveas(gcf,saveStr,'tiffn')
print(saveStr,'-dtiffn','-r300')
close all;
%% Kappas and choice accuracy w/wo noise - Figure 4
saveDir = ['figures/' fig_version '/4']; mkdir(saveDir)
saveStr = [saveDir '/performance_w_wo_noise'];
field2 = 'choice_accuracy_train_rand_order_binary';
subplot(2,2,1)
plot_sweep_result(['data/' datadirs{1}],field1,interpFactor,titleStr,'no',saveStr)
subplot(2,2,2)
plot_sweep_result(['data/' datadirs{1}],field2,interpFactor,titleStr,'no',saveStr)
subplot(2,2,3)
plot_sweep_result(['data/' datadirs{2}],field1,interpFactor,titleStr,'no',saveStr)
subplot(2,2,4)
plot_sweep_result(['data/' datadirs{2}],field2,interpFactor,titleStr,'no',saveStr)
set(gcf,'Position',[10 10 1100 1000])
saveas(gcf,saveStr,'fig')
%saveas(gcf,saveStr,'tiffn')
print(saveStr,'-dtiffn','-r300')
close all;

%% Psychometric curve - Figure 5
saveDir = ['figures/' fig_version '/5']; mkdir(saveDir)
saveStr = [saveDir '/psychometric_curve'];
dirNum = 2;
accThresh=.73;
rl=load(['data/' datadirs{dirNum} '/run_log.mat']); rl=rl.run_log;
nv1=length(rl.param1_range);
nv2=length(rl.param2_range);
nnets = rl.nnets;
seqs=load(['data/' datadirs{dirNum} '/1/1/net1/seqs.mat']); seqs=seqs.seqs;
seqs=repelem(seqs,10,1);
seqsum=sum(seqs-1,2);
good_seqs = (seqsum ~= 3);
%seqs=seqs(good_seqs,:);
nLeftCues = sum(seqs-1,2);
seqs0left = find(nLeftCues == 0);
seqs1left = find(nLeftCues == 1);
seqs2left = find(nLeftCues == 2);
seqs3left = find(nLeftCues == 3);
seqs4left = find(nLeftCues == 4);
seqs5left = find(nLeftCues == 5);
seqs6left = find(nLeftCues == 6);
good_count=0;
x = [0 1 2 3 4 5 6];
for i=1:nv1
    for j=1:nv2
        for k=1:nnets
            curdir = ['data/' datadirs{dirNum} '/' num2str(i) '/' num2str(j) '/net' num2str(k)];
            a = load([curdir '/choice_accuracy_train_rand_order_binary.mat']); a=a.accuracy;
            if (a > accThresh)
                good_count=good_count+1;
                y = load([curdir '/y_train_rand_order.mat']); y=y.y;
                frac0 = sum(y(seqs0left) == 1)/length(seqs0left);
                frac1 = sum(y(seqs1left) == 1)/length(seqs1left);
                frac2 = sum(y(seqs2left) == 1)/length(seqs2left);
                frac3 = sum(y(seqs3left) == 1)/length(seqs3left);
                frac4 = sum(y(seqs4left) == 1)/length(seqs4left);
                frac5 = sum(y(seqs5left) == 1)/length(seqs5left);
                frac6 = sum(y(seqs6left) == 1)/length(seqs6left);
                fracLeftChoice(good_count,:) = [frac0 frac1 frac2 frac3 frac4 frac5 frac6];
            end
        end
    end
end
figure;
shadedErrorBar(x,mean(fracLeftChoice,1),std(fracLeftChoice,[],1))
set(gca,'XTick',[0 1 2 3 4 5 6],'XTickLabel',{'0','1','2','3','4','5','6'})
xlabel('# of left cues','FontSize',30,'FontWeight','bold')
ylabel('Fraction of left choices','FontSize',30,'FontWeight','bold')
ylim([0 1])
saveas(gcf,[saveStr '_shadedErrorBar'],'fig')
saveas(gcf,[saveStr '_shadedErrorBar'],'tiffn')
figure;
boxplot(fracLeftChoice,{'0','1','2','3','4','5','6'})
xlabel('# of left cues','FontSize',30,'FontWeight','bold')
ylabel('Fraction of left choices','FontSize',30,'FontWeight','bold')
saveas(gcf,[saveStr '_boxplot'],'fig')
print([saveStr '_boxplot'],'-dtiffn','-r300')
%saveas(gcf,[saveStr '_boxplot'],'tiffn')
close all;

%% Error rates for sequences with first/last stimulus ~= correct choice - Fig 6
dirNum = 2;
saveDir = ['figures/' fig_version '/6']; mkdir(saveDir)
saveStr = [saveDir '/first_mid_last_stim_opp_choice'];
[accs] = load_analysis_values(['data/' datadirs{dirNum}],'choice_accuracy_train_rand_order_binary','accuracy'); 
lin_accs=accs(:);
good_accs = lin_accs > .73;
rl = load(['data/' datadirs{dirNum} '/run_log.mat']); rl=rl.run_log;
nv1 = length(rl.param1_range);
nv2 = length(rl.param2_range);
nnets = rl.nnets;
[dif_first_error_rates,not_dif_first_error_rates] = get_dif_first_error_rates(['data/' datadirs{dirNum}]);
xticklabels = {'\bf First stimulus = \newline correct choice', '\bf First stimulus \neq \newline correct choice'};
n=sum(good_accs);
lin_not_dif_first_error_rates = not_dif_first_error_rates(:);
lin_dif_first_error_rates = dif_first_error_rates(:);
C = [(1 - lin_not_dif_first_error_rates(good_accs)) (1 - lin_dif_first_error_rates(good_accs))];
groups = [zeros(1,n) ones(1,n)];
subplot(1,3,1)
h=boxplot(C,groups); set(h,'LineWidth',3); set(gca,'Xtick',[1 2],'XTickLabels',xticklabels)
ylim([0 1]); ylabel('Choice accuracy','FontSize',30,'FontWeight','bold')
[h,pval] = ttest2((1 - not_dif_first_error_rates(good_accs)),(1 - dif_first_error_rates(good_accs)));
disp(['P-value that sequences with first stimuli opposite choice have more errors for good networks = ' num2str(pval)])
set(gca,'TickLabelInterpreter','tex'); %title('Good networks (Choice accuracy >.73)')
%{
C = [(1 - not_dif_last_error_rates(:)) (1 - dif_last_error_rates(:))];
groups = [zeros(1,n) ones(1,n)];
figure;
subplot(2,2,1)
h=boxplot(C,groups); set(h,'LineWidth',3); set(gca,'Xtick',[1 2],'XTickLabels',xticklabels)
ylim([0 1]); ylabel('Choice accuracy','FontSize',30,'FontWeight','bold')
%saveas(gcf,[saveStr '_all'],'fig')
%print([saveStr '_all'],'-dtiffn','-r300')
[h,pval] = ttest2((1 - not_dif_last_error_rates(:)),(1 - dif_last_error_rates(:)));
disp(['P-value that sequences with last stimuli opposite choice have more errors = ' num2str(pval)])
set(gca,'TickLabelInterpreter','tex'); title('All networks')
%}

subplot(1,3,2)
[dif_mid_error_rates,not_dif_mid_error_rates] = get_dif_mid_error_rates(['data/' datadirs{dirNum}]);
xticklabels = {'\bf 3rd stimulus = \newline correct choice', '\bf 3rd stimulus \neq \newline correct choice'};
lin_not_dif_mid_error_rates = not_dif_mid_error_rates(:);
lin_dif_mid_error_rates = dif_mid_error_rates(:);
C = [(1 - lin_not_dif_mid_error_rates(good_accs)) (1 - lin_dif_mid_error_rates(good_accs))];
groups = [zeros(1,n) ones(1,n)];
h=boxplot(C,groups); set(h,'LineWidth',3); set(gca,'Xtick',[1 2],'XTickLabels',xticklabels)
ylim([0 1]); ylabel('Choice accuracy','FontSize',30,'FontWeight','bold')
set(gca,'TickLabelInterpreter','tex');
[h,pval] = ttest2((1 - not_dif_mid_error_rates(good_accs)),(1 - dif_mid_error_rates(good_accs)));
disp(['P-value that sequences with middle stimuli opposite choice have more errors for good networks = ' num2str(pval)])
%{
%saveStr = [saveDir '/first_stim_opp_choice'];
n = nv1*nv2*nnets;
xticklabels = {'\bf same-first-choice', '\bf dif-first-choice'};
[dif_first_error_rates,not_dif_first_error_rates] = get_dif_first_error_rates(['data/' datadirs{dirNum}]);
C = [(1 - not_dif_first_error_rates(:)) (1 - dif_first_error_rates(:))];
groups = [zeros(1,n) ones(1,n)];
subplot(2,2,3)
h=boxplot(C,groups); set(h,'LineWidth',3); set(gca,'Xtick',[1 2],'XTickLabels',xticklabels)
ylim([0 1]); ylabel('Choice accuracy','FontSize',30,'FontWeight','bold')
%saveas(gcf,[saveStr '_all'],'fig')
%print([saveStr '_all'],'-dtiffn','-r300')
[h,pval] = ttest2((1 - not_dif_first_error_rates(:)),(1 - dif_first_error_rates(:)));
disp(['P-value that sequences with first stimuli opposite choice have more errors = ' num2str(pval)])
set(gca,'TickLabelInterpreter','tex'); title('All networks')
%}

[dif_last_error_rates,not_dif_last_error_rates] = get_dif_last_error_rates(['data/' datadirs{dirNum}]);
xticklabels = {'\bf Last stimulus = \newline correct choice', '\bf Last stimulus \neq \newline correct choice'};
n=sum(good_accs);
lin_not_dif_last_error_rates = not_dif_last_error_rates(:);
lin_dif_last_error_rates = dif_last_error_rates(:);
C = [(1 - lin_not_dif_last_error_rates(good_accs)) (1 - lin_dif_last_error_rates(good_accs))];
groups = [zeros(1,n) ones(1,n)];
subplot(1,3,3);
h=boxplot(C,groups); set(h,'LineWidth',3); set(gca,'Xtick',[1 2],'XTickLabels',xticklabels)
ylim([0 1]); ylabel('Choice accuracy','FontSize',30,'FontWeight','bold')
%saveas(gcf,[saveStr '_good_kappas'],'fig')
%print([saveStr '_good_kappas'],'-dtiffn','-r300')
[h,pval] = ttest2((1 - not_dif_last_error_rates(good_accs)),(1 - dif_last_error_rates(good_accs)));
disp(['P-value that sequences with last stimuli opposite choice have more errors for good networks = ' num2str(pval)])
set(gca,'TickLabelInterpreter','tex'); %title('Good networks (\kappa > .73)')
set(gcf,'Position',[10 10 1600 800])
saveas(gcf,saveStr,'fig')
print(saveStr,'-dtiffn','-r300')
%close all;

%% correlations with #Left stimuli/last stimuli - Figure 7
saveDir = ['figures/' fig_version '/7']; mkdir(saveDir)
saveStr = [saveDir '/first_last_nstims_correlations'];
[nstimuli_corrs] = get_unit_correlations('data/We0_Wee_sweep_noise000/5/5/net10','nstimuli');
[firstStim_corrs] = get_unit_correlations('data/We0_Wee_sweep_noise000/5/5/net10','firstStim');
[lastStim_corrs] = get_unit_correlations('data/We0_Wee_sweep_noise000/5/5/net10','lastStim');
inds1 = logical((~isnan(nstimuli_corrs)).*(~isnan(lastStim_corrs)));
inds2 = logical((~isnan(nstimuli_corrs)).*(~isnan(firstStim_corrs)));
[rho1,pvals1] = corr([lastStim_corrs(inds1)' nstimuli_corrs(inds1)']);
[rho2,pvals2] = corr([firstStim_corrs(inds2)' nstimuli_corrs(inds2)']);
maxy=max(nstimuli_corrs); maxx = max(max(firstStim_corrs),max(lastStim_corrs));
miny=min(nstimuli_corrs); minx = min(min(firstStim_corrs),min(lastStim_corrs));
miny=miny-.05; minx=minx-.05; maxy=maxy+.05; maxx = maxx+.05;
figure;
subplot(1,2,1)
scatter(lastStim_corrs,nstimuli_corrs,20,'k','filled'); xlim([minx maxx]); ylim([miny maxy])
xlabel('Correlation with last stimulus','FontSize',30,'FontWeight','bold')
ylabel('Correlation with # left stimuli','FontSize',30,'FontWeight','bold')
text(0.2,0.9,['\rho = ' num2str(round(rho1(1,2),2))],'Units','normalized','FontSize',20)
disp(['correlation of last stim and nstimuli corrs p-val = ' num2str(pvals1(1,2))])
subplot(1,2,2)
scatter(firstStim_corrs,nstimuli_corrs,20,'k','filled'); xlim([minx maxx]); ylim([miny maxy])
xlabel('Correlation with first stimulus','FontSize',30,'FontWeight','bold')
ylabel('Correlation with # left stimuli','FontSize',30,'FontWeight','bold')
text(0.2,0.9,['\rho = ' num2str(round(rho2(1,2),2))],'Units','normalized','FontSize',20)
disp(['correlation of first stim and nstimuli corrs p-val = ' num2str(pvals2(1,2))])
set(gcf,'Position',[10 10 1400 500])
saveas(gcf,saveStr,'fig')
print(saveStr,'-dtiffn','-r300')
close all;

%% Activity trajectories - Figure 8
Fig4code;
close all;

%% Probability of first recall - Figure 9 (done by Paul)

%% Primacy and Recency in the 7-word task - Figure 10
saveDir = ['figures/' fig_version '/10']; mkdir(saveDir);
saveStr = [saveDir '/primacy_recency_sweeps'];
[primacy,recency,accuracy_curves] = primacy_recency_analysis(['data/' datadirs{17}],10);
npts=100;
rl = load(['data/' datadirs{17} '/run_log.mat']); rl = rl.run_log;
var1str = get_param_string(rl.param1); var2str = get_param_string(rl.param2);
xrange = rl.param1_range; yrange = rl.param2_range;
[X,Y] = meshgrid(xrange,yrange);
xdt = (max(xrange) - min(xrange))/npts;
ydt = (max(yrange) - min(yrange))/npts;
interp_x_range = min(xrange):xdt:max(xrange);
interp_y_range = min(yrange):ydt:max(yrange);
[interp_X,interp_Y] = meshgrid(interp_x_range,interp_y_range);

mean_primacy = mean(primacy,3);
mean_recency = mean(recency,3);
max_score = max(max(mean_primacy(:)),max(mean_recency(:)));
min_score = min(min(mean_primacy(:)),min(mean_recency(:)));
interp_mean_primacy = interp2(X,Y,mean_primacy',interp_X,interp_Y);
interp_mean_recency = interp2(X,Y,mean_recency',interp_X,interp_Y);
subplot(1,2,1)
xticklocs = linspace(1,npts,length(xrange)); xtickvals = xrange;
yticklocs = linspace(1,npts,length(yrange)); ytickvals = yrange;
colorBarLabel = 'Primacy score';
imagesc(interp_mean_primacy); colormap(jet); h=colorbar(); xlabel(var1str,'FontSize',30,'FontWeight','bold'); ylabel(var2str,'FontSize',30,'FontWeight','bold')
set(gca,'Ydir','normal','XTick',xticklocs,'XTickLabel',xtickvals,'XTickLabelRotation',60,'YTick',yticklocs,'YTickLabel',ytickvals,'FontSize',25); 
caxis([min_score max_score])
ylabel(h,colorBarLabel,'FontSize',30,'FontWeight','bold')
subplot(1,2,2)
xticklocs = linspace(1,npts,length(xrange)); xtickvals = xrange;
yticklocs = linspace(1,npts,length(yrange)); ytickvals = yrange;
colorBarLabel = 'Recency score';
imagesc(interp_mean_recency); colormap(jet); h=colorbar(); xlabel(var1str,'FontSize',30,'FontWeight','bold'); ylabel(var2str,'FontSize',30,'FontWeight','bold')
set(gca,'Ydir','normal','XTick',xticklocs,'XTickLabel',xtickvals,'XTickLabelRotation',60,'YTick',yticklocs,'YTickLabel',ytickvals,'FontSize',25); 
caxis([min_score max_score])
ylabel(h,colorBarLabel,'FontSize',30,'FontWeight','bold')
set(gcf,'Position',[10 10 1500 600])
saveas(gcf,saveStr,'fig')
print(saveStr,'-dtiffn','-r300')
%close all;

saveStr = [saveDir '/primacy_recency_kappa_correlations'];
[kappas] = load_analysis_values(['data/' datadirs{17}],'cm_binary','cm');
[rho,pval] = corr([primacy(:) recency(:)]);
disp(['Primacy-Recency correlation \rho = ' num2str(rho(1,2)) ' p-val = ' num2str(pval(1,2))])
primacy_recency_corr = rho(1,2);
figure;
subplot(1,3,1)
cmap=jet;
scatter(primacy(:),recency(:),20,cmap(round(kappas(:)*63 +1),:),'filled'); h=colorbar(); colormap(jet)
ylabel(h,'Discrimination score (\kappa)','FontSize',25,'FontWeight','bold')
xlabel('Primacy score','FontSize',30,'FontWeight','bold')
ylabel('Recency score','FontSize',30,'FontWeight','bold')
text(0.8,0.9,['\rho = ' num2str(round(primacy_recency_corr,2))],'Units','normalized','FontSize',20)

[rho,pval] = corr([kappas(:) primacy(:)]);
disp(['Kappa-Primacy correlation \rho = ' num2str(rho(1,2)) ' p-val = ' num2str(pval(1,2))])
kappas_primacy_corr = rho(1,2);
subplot(1,3,2)
scatter(kappas(:),primacy(:),20,'k','filled')
xlabel('Discrimination score (\kappa)','FontSize',30,'FontWeight','bold')
ylabel('Primacy score','FontSize',30,'FontWeight','bold')
text(0.8,0.9,['\rho = ' num2str(round(kappas_primacy_corr,2))],'Units','normalized','FontSize',20)

[rho,pval] = corr([kappas(:) recency(:)]);
disp(['Kappa-Recency correlation \rho = ' num2str(rho(1,2)) ' p-val = ' num2str(pval(1,2))])
kappas_recency_corr = rho(1,2);
subplot(1,3,3)
scatter(kappas(:),recency(:),20,'k','filled')
xlabel('Discrimination score (\kappa)','FontSize',30,'FontWeight','bold')
ylabel('Recency score','FontSize',30,'FontWeight','bold')
text(0.8,0.9,['\rho = ' num2str(round(kappas_recency_corr,2))],'Units','normalized','FontSize',20)
set(gcf,'Position',[10 10 1200 400])
saveas(gcf,saveStr,'fig')
print(saveStr,'-dtiffn','-r300')
%close all;

%% No Excitatory Cross-Connections - Figure 11
saveDir = ['figures/' fig_version '/11']; mkdir(saveDir)
saveStr = [saveDir '/compare_EE_to_noEE'];
compare_sweeps('data/We0_sweep_noise000','data/no_EE_We0_sweep_noise000','With E --> E','Without E --> E','no','yes',saveStr)
close all;

%% Look at 24 and 0156 errors for We0_Wee_sweep_noise000/2/2 - Figure 12
saveDir = ['figures/' fig_version '/12']; mkdir(saveDir)
saveStr = [saveDir '/train24_errors'];
curdir = ['data/' datadirs{1} '/6/6'];
[worstSeqs,worstErrRates] = analyze_choices(curdir,10,'train24_binary','yes','yes',saveStr);
save([saveDir '/train24_worstSeqs.mat'],'worstSeqs','-mat')
save([saveDir '/train24_worstErrRates.mat'],'worstErrRates','-mat')

saveStr = [saveDir '/train0156_errors'];
[worstSeqs,worstErrRates] = analyze_choices(curdir,10,'train0156_binary','yes','yes',saveStr);
save([saveDir '/train0156_worstSeqs.mat'],'worstSeqs','-mat')
save([saveDir '/train0156_worstErrRates.mat'],'worstErrRates','-mat')
close all;

%% intra/inter-cluster distances - Figure 13
saveDir = ['figures/' fig_version '/13']; mkdir(saveDir)
saveStr = [saveDir '/cluster_dists_scatter'];
[mean_intra_ev_dists1,mean_inter_ev_dists1,hypotheses1,pvalues1] = analyze_clustering_sweep(['data/' datadirs{1}]);
[accs1] = load_analysis_values(['data/' datadirs{1}],'choice_accuracy_train_rand_order_binary','accuracy');
kappas1 = load_analysis_values(['data/' datadirs{1}],'cm_binary','cm');
[mean_intra_ev_dists2,mean_inter_ev_dists2,hypotheses2,pvalues2] = analyze_clustering_sweep(['data/' datadirs{2}]);
[accs2] = load_analysis_values(['data/' datadirs{2}],'choice_accuracy_train_rand_order_binary','accuracy');
acc_thresh = .73;
lin_accs1 = accs1(:); good_accs1 = (lin_accs1 > acc_thresh);
lin_kappas1 = kappas1(:); good_kappas1 = (lin_kappas1 > .1);
good_inds1 = good_accs1; %logical(good_accs1.*good_kappas1);
lin_accs2 = accs2(:); good_accs2 = (lin_accs2 > acc_thresh);
lin_mean_intra_ev_dists1 = mean_intra_ev_dists1(:);
lin_mean_inter_ev_dists1 = mean_inter_ev_dists1(:);
lin_mean_intra_ev_dists2 = mean_intra_ev_dists2(:);
lin_mean_inter_ev_dists2 = mean_inter_ev_dists2(:);
minx = min(min(lin_mean_intra_ev_dists1),min(lin_mean_intra_ev_dists2));
maxx = max(max(lin_mean_intra_ev_dists1),max(lin_mean_intra_ev_dists2));
miny = min(min(lin_mean_inter_ev_dists1),min(lin_mean_inter_ev_dists2));
maxy = max(max(lin_mean_inter_ev_dists1),max(lin_mean_inter_ev_dists2));
cmap = jet;
figure;
subplot(1,2,1)
scatter(lin_mean_intra_ev_dists1(good_inds1),lin_mean_inter_ev_dists1(good_inds1),20,cmap(round(lin_accs1(good_inds1)*63 + 1),:),'filled')
xlabel(['Mean intra-cluster distance'],'FontSize',30,'FontWeight','bold')
ylabel(['Mean inter-cluster distance'],'FontSize',30,'FontWeight','bold')
xlim([minx maxx]); ylim([miny maxy])
colormap(jet); h = colorbar(); ylabel(h,'Choice accuracy','FontSize',25,'FontWeight','bold');
hold on; plot([0 max(maxx,maxy)],[0 max(maxx,maxy)],'k','LineWidth',3)
subplot(1,2,2)
scatter(lin_mean_intra_ev_dists2(good_accs2),lin_mean_inter_ev_dists2(good_accs2),20,cmap(round(lin_accs2(good_accs2)*63 + 1),:),'filled')
xlabel(['Mean intra-cluster distance'],'FontSize',30,'FontWeight','bold')
ylabel(['Mean inter-cluster distance'],'FontSize',30,'FontWeight','bold')
xlim([minx maxx]); ylim([miny maxy])
colormap(jet); h = colorbar(); ylabel(h,'Choice accuracy','FontSize',25,'FontWeight','bold');
hold on; plot([0 max(maxx,maxy)],[0 max(maxx,maxy)],'k','LineWidth',3)
set(gcf,'Position',[10 10 1400 500])
[h,pval] = ttest2(lin_mean_intra_ev_dists1(good_accs1),lin_mean_intra_ev_dists2(good_accs2));
disp(['pvalue that mean intra-cluster distances vary between noisy/non-noisy = ' num2str(pval)])
[h,pval] = ttest2(lin_mean_inter_ev_dists1(good_accs1),lin_mean_inter_ev_dists2(good_accs2));
disp(['pvalue that mean inter-cluster distances vary between noisy/non-noisy = ' num2str(pval)])
[h,pval] = ttest2(lin_mean_intra_ev_dists1(good_accs1),lin_mean_inter_ev_dists1(good_accs1));
disp(['pvalue that mean intra/inter-cluster distances vary between in non-noisy condition = ' num2str(pval)])
[h,pval] = ttest2(lin_mean_intra_ev_dists2(good_accs2),lin_mean_inter_ev_dists2(good_accs2));
disp(['pvalue that mean intra/inter-cluster distances vary between in noisy condition = ' num2str(pval)])
saveas(gcf,saveStr,'fig')
print(saveStr,'-dtiffn','-r300')
%close all;

%% Different start conditions - Supp Figure 1
saveDir = ['figures/' fig_version '/supp_1']; mkdir(saveDir)
saveStr = [saveDir '/dif_starts'];
subplot(2,2,1)
plot_sweep_result(['data/' datadirs{3}],field1,interpFactor,titleStr,'no',saveStr)
subplot(2,2,2)
plot_sweep_result(['data/' datadirs{4}],field1,interpFactor,titleStr,'no',saveStr)
subplot(2,2,3)
plot_sweep_result(['data/' datadirs{5}],field1,interpFactor,titleStr,'no',saveStr)
subplot(2,2,4)
plot_sweep_result(['data/' datadirs{14}],field1,interpFactor,titleStr,'no',saveStr)
set(gcf,'Position',[10 10 1100 1000])
saveas(gcf,saveStr,'fig')
%saveas(gcf,saveStr,'tiffn')
print(saveStr,'-dtiffn','-r300')
%close all;

%% 4-cases (1st=last=choice, 1st~=last=choice, 1st=choice~=last - Supp fig 2 - don't include
% 1st=last~=choice
saveDir = ['figures/' fig_version '/supp_2'];
saveStr = [saveDir 'first_last_choice_4_cases'];
[case_accuracies1,not_case_accuracies1] = get_first_last_accuracies(['data/' datadirs{2}],1);
[case_accuracies2,not_case_accuracies2] = get_first_last_accuracies(['data/' datadirs{2}],2);
[case_accuracies3,not_case_accuracies3] = get_first_last_accuracies(['data/' datadirs{2}],3);
[case_accuracies4,not_case_accuracies4] = get_first_last_accuracies(['data/' datadirs{2}],4);
lin_case_accuracies1 = case_accuracies1(:);
lin_case_accuracies2 = case_accuracies2(:);
lin_case_accuracies3 = case_accuracies3(:);
lin_case_accuracies4 = case_accuracies4(:);
lin_not_case_accuracies1 = not_case_accuracies1(:);
lin_not_case_accuracies2 = not_case_accuracies2(:);
lin_not_case_accuracies3 = not_case_accuracies3(:);
lin_not_case_accuracies4 = not_case_accuracies4(:);

grps = [zeros(1,sum(good_accs)) ones(1,sum(good_accs))];
C1 = [lin_case_accuracies1(good_accs) lin_not_case_accuracies1(good_accs)];
C2 = [lin_case_accuracies2(good_accs) lin_not_case_accuracies2(good_accs)];
C3 = [lin_case_accuracies3(good_accs) lin_not_case_accuracies3(good_accs)];
C4 = [lin_case_accuracies4(good_accs) lin_not_case_accuracies4(good_accs)];
[h1,pval1] = ttest2(lin_case_accuracies1(good_accs),lin_not_case_accuracies1(good_accs));
[h2,pval2] = ttest2(lin_case_accuracies2(good_accs),lin_not_case_accuracies2(good_accs));
[h3,pval3] = ttest2(lin_case_accuracies3(good_accs),lin_not_case_accuracies3(good_accs));
[h4,pval4] = ttest2(lin_case_accuracies4(good_accs),lin_not_case_accuracies4(good_accs));
figure;
subplot(2,2,1); h=boxplot(C1,grps); xticklabels = {'\bf 1st=last=choice', '\bf all other sequences'};
set(h,'LineWidth',3); set(gca,'Xtick',[1 2],'XTickLabels',xticklabels)
ylim([0 1]); ylabel('Choice accuracy','FontSize',30,'FontWeight','bold')
set(gca,'TickLabelInterpreter','tex');
disp(['1st = last = choice pval = ' num2str(pval1)])

subplot(2,2,2); h=boxplot(C3,grps); xticklabels = {'\bf 1st=choice\neqlast', '\bf all other sequences'};
set(h,'LineWidth',3); set(gca,'Xtick',[1 2],'XTickLabels',xticklabels)
ylim([0 1]); ylabel('Choice accuracy','FontSize',30,'FontWeight','bold')
set(gca,'TickLabelInterpreter','tex');
disp(['1st = choice ~= last pval = ' num2str(pval3)])

subplot(2,2,3); h=boxplot(C2,grps); xticklabels = {'\bf 1st\neqlast=choice', '\bf all other sequences'};
set(h,'LineWidth',3); set(gca,'Xtick',[1 2],'XTickLabels',xticklabels)
ylim([0 1]); ylabel('Choice accuracy','FontSize',30,'FontWeight','bold')
set(gca,'TickLabelInterpreter','tex');
disp(['1st ~= last = choice pval = ' num2str(pval2)])

subplot(2,2,4); h=boxplot(C4,grps); xticklabels = {'\bf 1st=last\neqchoice', '\bf all other sequences'};
set(h,'LineWidth',3); set(gca,'Xtick',[1 2],'XTickLabels',xticklabels)
ylim([0 1]); ylabel('Choice accuracy','FontSize',30,'FontWeight','bold')
set(gca,'TickLabelInterpreter','tex');
disp(['1st = last ~= choice pval = ' num2str(pval4)])
set(gcf,'Position',[10 10 1200 1200])
%saveas(gcf,saveStr,'fig')
%print(saveStr,'-dtiffn','-r300')
%close all;

%% variable amplitude/duration - Supp Figure 2
saveDir = ['figures/' fig_version '/supp_2']; mkdir(saveDir)
saveStr = [saveDir '/variable_amplitude_duration'];
subplot(2,2,1)
plot_sweep_result(['data/' datadirs{8}],field1,interpFactor,titleStr,'no',saveStr)
subplot(2,2,2)
plot_sweep_result(['data/' datadirs{9}],field1,interpFactor,titleStr,'no',saveStr)
subplot(2,2,3)
plot_sweep_result(['data/' datadirs{10}],field1,interpFactor,titleStr,'no',saveStr)
subplot(2,2,4)
plot_sweep_result(['data/' datadirs{11}],field1,interpFactor,titleStr,'no',saveStr)
set(gcf,'Position',[10 10 1100 1000])
saveas(gcf,saveStr,'fig')
%saveas(gcf,saveStr,'tiffn')
print(saveStr,'-dtiffn','-r300')
close all;

%% different inter-stimulus-intervals - Supp Figure 3
field2 = 'choice_accuracy_train_rand_order_binary';
%field2 = 'choice_accuracy_train012456';
saveDir = ['figures/' fig_version '/supp_3']; mkdir(saveDir)
saveStr = [saveDir '/dif_stim_int'];
subplot(1,2,1);
plot_sweep_result(['data/' datadirs{16}],field1,interpFactor,titleStr,'no',saveStr);
subplot(1,2,2);
plot_sweep_result(['data/' datadirs{16}],field2,interpFactor,titleStr,'no',saveStr);
set(gcf,'Position',[10 10 1600 550])
saveas(gcf,saveStr,'fig')
%saveas(gcf,saveStr,'tiffn')
print(saveStr,'-dtiffn','-r300')
close all;

%% Iapp Generalization - Supp Figure 4
saveDir = ['figures/' fig_version '/supp_4']; mkdir(saveDir)
saveStr = [saveDir '/Iapp_generalization'];
field2 = 'choice_accuracy_train_rand_order_binary';
figure;
subplot(1,2,1)
plot_sweep_result(['data/' datadirs{19}],field1,interpFactor,titleStr,'no',saveStr)
subplot(1,2,2)
plot_sweep_result(['data/' datadirs{19}],field2,interpFactor,titleStr,'no',saveStr)
set(gcf,'Position',[10 10 1650 600])
saveas(gcf,saveStr,'fig')
print(saveStr,'-dtiffn','-r300')
close all;

%% Word seq performance - Supp Figure 5
saveDir = ['figures/' fig_version '/supp_5']; mkdir(saveDir)
saveStr = [saveDir '/word_seq_performance'];
figure;
subplot(1,2,1)
plot_sweep_result(['data/' datadirs{17}],field1,interpFactor,titleStr,'no',saveStr)
subplot(1,2,2)
plot_sweep_result(['data/' datadirs{20}],field1,interpFactor,titleStr,'no',saveStr)
set(gcf,'Position',[10 10 1800 600])
saveas(gcf,saveStr,'fig')
%saveas(gcf,saveStr,'tiffn')
print(saveStr,'-dtiffn','-r300')
close all;

%% no Depression - Supp Figure 7 - don't include
saveDir = ['figures/' fig_version '/supp_7']; %mkdir(saveDir)
saveStr = [saveDir '/no_D_performance'];
subplot(1,2,1)
plot_sweep_result(['data/' datadirs{18}],field1,interpFactor,titleStr,'no',saveStr)
subplot(1,2,2)
plot_sweep_result(['data/' datadirs{21}],field1,interpFactor,titleStr,'no',saveStr)
%{
subplot(2,2,3)
xgood = load(['data/' datadirs{18} '/2/7/net1/x_train.mat']); xgood=xgood.x;
xbad = load(['data/' datadirs{18} '/1/1/net1/x_train.mat']); xbad=xbad.x;
xgood_dists = dist(xgood');
xbad_dists = dist(xbad');
imagesc(xgood_dists); caxis([0 .01]); colorbar()
set(gca,'XTick',1:100:640,'YTick',1:100:640,'XTickLabelRotation',30)
xlabel('Trial ID','FontSize',30,'FontWeight','bold'); ylabel('Trial ID','FontSize',30,'FontWeight','bold')
subplot(2,2,4)
imagesc(xgood_dists); caxis([0 .00000001]); colorbar()
set(gca,'XTick',1:100:640,'YTick',1:100:640,'XTickLabelRotation',30)
xlabel('Trial ID','FontSize',30,'FontWeight','bold'); ylabel('Trial ID','FontSize',30,'FontWeight','bold')
%}
set(gcf,'Position',[100 100 1500 550])
%saveas(gcf,saveStr,'fig')
%saveas(gcf,saveStr,'tiffn')
%print(saveStr,'-dtiffn','-r300')
%print([saveStr '_print'],'-dtiffn','-r300')
%close all;