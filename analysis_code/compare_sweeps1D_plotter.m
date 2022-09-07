function [] = compare_sweeps1D_plotter(data,field,s1_common_inds,s2_common_inds,param1str,Sweep1Label,Sweep2Label,xticklocs1,xtickvals1,xticklocs2,xtickvals2,saveFig,saveStr)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% helper function for compare_sweeps1D
if (~isfield(data{1},field))
    warning([field ' is not not present as a field in data'])
    return;
end
switch field
    case 'kappas'
        titleStr = 'Sequence Discrimination Scores (\kappa)';
    case 'ca_train012456'
        titleStr = 'Train on sequences with 4, 5, or 6 of the same stimulus';
    case 'ca_train0156'
        titleStr = 'Train on sequences with 5 or 6 of the same stimulus';
    case 'ca_train24'
        titleStr = 'Train on sequences with 4 of the same stimulus';
    case 'ca_train15'
        titleStr = 'Train on sequences with 5 of the same stimulus';
    case 'ca_train06'
        titleStr = 'Train on sequences with 6 of the same stimulus';
    case 'ca_same_first_last'
        titleStr = 'Train on sequences with identical 1st and last stimuli';
    case 'ca_first_opposite_choice'
        titleStr = 'Train on sequences where the 1st stimulus is opposite the correct choice';
    case 'ca_last_opposite_choice'
        titleStr = 'Train on sequences where the last stimulus is opposite the correct choice';
    case 'ca_train_rand_order_binary'
        titleStr = '';
end
if (contains(field,'kappas'))
    yLabel = 'Sequence Discrimination (\kappa)';
else
    yLabel = 'Choice Accuracy';
end

markerSize = 20;
meanData1 = mean(data{1}.(field),2);
stdData1 = std(data{1}.(field),[],2);
meanData2 = mean(data{2}.(field),2);
stdData2 = std(data{2}.(field),[],2);
common_meanData1 = mean(data{1}.(field)(s1_common_inds,:),2);
common_meanData2 = mean(data{2}.(field)(s2_common_inds,:),2);
figure;
subplot(1,2,1); shadedErrorBar(1:length(meanData1),meanData1,stdData1); ylim([0 1])
set(gca,'XTick',xticklocs1,'XTickLabel',xtickvals1,'XTickLabelRotation',70,'FontSize',24); 
xlabel(param1str,'FontSize',28,'FontWeight','bold'); 
ylabel(yLabel,'FontSize',28,'FontWeight','bold')
subplot(1,2,2); shadedErrorBar(1:length(meanData2),meanData2,stdData2); ylim([0 1])
set(gca,'XTick',xticklocs2,'XTickLabel',xtickvals2,'XTickLabelRotation',70,'FontSize',24); 
xlabel(param1str,'FontSize',28,'FontWeight','bold'); 
ylabel(yLabel,'FontSize',28,'FontWeight','bold')

%{
subplot(1,3,3); scatter(common_meanData1,common_meanData2,markerSize,'k','filled');
hold on; plot([0 1],[0 1],'LineWidth',2)
xlabel(Sweep1Label); ylabel(Sweep2Label);
%}
set(gcf,'Position',[10 10 1400 500]); %suptitle(titleStr)
if (strcmp(saveFig,'yes'))
    saveas(gcf,[saveStr '_' field],'fig')
    saveas(gcf,[saveStr '_' field],'tiffn')
end
end

