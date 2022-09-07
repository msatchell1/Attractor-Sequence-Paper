function []=compare_sweeps2D_plotter(data,field,interpIndsS1V1,interpIndsS1V2,interpIndsS2V1,interpIndsS2V2,indsS1V1,indsS1V2,indsS2V1,indsS2V2,param1str,param2str,Sweep1Label,Sweep2Label,xticklocs1,xtickvals1,yticklocs1,ytickvals1,xticklocs2,xtickvals2,yticklocs2,ytickvals2,saveFig,saveStr)
% helper function to generate plots for compare_sweeps2D
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
end

markerSize = 20;

figure;
subplot(2,2,1); imagesc(data{1}.(['interp_' field]));
colormap(jet); caxis([0 1]); colorbar(); set(gca,'Ydir','normal','XTick',xticklocs1,'XTickLabel',xtickvals1,'XTickLabelRotation',40,'YTick',yticklocs1,'YTickLabel',ytickvals1,'FontSize',18); title(Sweep1Label)
xlabel(param1str,'FontSize',20,'FontWeight','bold'); ylabel(param2str,'FontSize',20,'FontWeight','bold')

subplot(2,2,2); imagesc(data{2}.(['interp_' field]));
colormap(jet); caxis([0 1]); colorbar(); set(gca,'Ydir','normal','XTick',xticklocs2,'XTickLabel',xtickvals2,'XTickLabelRotation',40,'YTick',yticklocs2,'YTickLabel',ytickvals2,'FontSize',18); title(Sweep2Label)
xlabel(param1str,'FontSize',20,'FontWeight','bold'); ylabel(param2str,'FontSize',20,'FontWeight','bold')

interpCommonData1 = data{1}.(['interp_' field])(interpIndsS1V1,interpIndsS1V2);
interpCommonData2 = data{2}.(['interp_' field])(interpIndsS2V1,interpIndsS2V2);
subplot(2,2,3); scatter(interpCommonData1(:),interpCommonData2(:),markerSize,'k','filled'); 
xlabel(Sweep1Label,'FontSize',20,'FontWeight','bold'); ylabel(Sweep2Label,'FontSize',20,'FontWeight','bold');
if (strcmp(field,'kappas'))
    hold on; plot([0 1],[0 1],'LineWidth',2); title('Interpolated Data Points')
else
    hold on; plot([0 1],[0 1],'LineWidth',2); title('Interpolated Data Points')
end

meanCommonData1 = mean(data{1}.(field)(indsS1V1,indsS1V2,:),3);
meanCommonData2 = mean(data{2}.(field)(indsS2V1,indsS2V2,:),3);
subplot(2,2,4); scatter(meanCommonData1(:),meanCommonData2(:),markerSize,'k','filled');
xlabel(Sweep1Label,'FontSize',20,'FontWeight','bold'); ylabel(Sweep2Label,'FontSize',20,'FontWeight','bold')
if (strcmp(field,'kappas'))
    hold on; plot([0 1],[0 1],'LineWidth',2); title('Comparable Data Points')
else
    hold on; plot([0 1],[0 1],'LineWidth',2); title('Comparable Data Points')
end
set(gcf,'Position',[10 10 1000 1000]); %suptitle(titleStr)

if (strcmp(saveFig,'yes'))
    saveas(gcf,saveStr,'fig')
    %saveas(gcf,saveStr,'tiffn')
    print(saveStr,'-dtiffn','-r300')
end
end

