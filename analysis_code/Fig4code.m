% Make trajectory figures
% This script is used to make the trajectory figures (Fig. 8)
%% Load Data from 2-word sequences
figVersion = 'final_version2';
figFolder = '8';
saveStr = ['figures/' figVersion '/' figFolder]; mkdir(saveStr);

p_p = load('Fig4data/perms/p.mat'); p_p = p_p.p;
for i=1:3
    data = load(['Fig4data/perms/seq' num2str(i) '/mean_r.mat']); data = data.mean_r;
    states = load(['Fig4data/perms/seq' num2str(i) '/state.mat']); states = states.state;
    p_states{i} = states;
    mean_rs_p{i} = data;
end
for i=1:size(p_states{1},2)
    d12 = dist([p_states{1}(:,i) p_states{2}(:,i)]);
    d13 = dist([p_states{1}(:,i) p_states{3}(:,i)]);
    p_1_2_dists(i) = d12(1,2);
    p_1_3_dists(i) = d13(1,2);
end
%% 1) 2-word seqs (1,2)
figure('Position',[100 100 2000 1400]);
subplot(2,5,[1,2])
imagesc(mean_rs_p{1}(1:p_p.Ne,:));
cmap_temp = hot; flipinds = fliplr(1:64);
cmap = cmap_temp(flipinds,:);
colormap(cmap); h1=colorbar(); ylabel(h1,'Firing rate (Hz)','FontSize',25)
set(gca,'XTick',1:1000:12000,'XTickLabel',1:12)
caxis([0 100]); title(['Sequence: ' p_p.stim_orders(1,:)]); 
xlabel('Time (s)','FontSize',30,'FontWeight','bold'); 
ylabel('Cell number','FontSize',30,'FontWeight','bold');
hold on;
for i=1:length(p_p.stim_on_times)
    rectangle('Position',[p_p.stim_on_times(i) 0 p_p.stim_dur/p_p.dt 101],'FaceColor',[.8 .8 .8 .5])
end

subplot(2,5,[6,7])
imagesc(mean_rs_p{2}(1:p_p.Ne,:));
colormap(cmap); h2=colorbar(); ylabel(h2,'Firing rate (Hz)','FontSize',25)
set(gca,'XTick',1:1000:12000,'XTickLabel',1:12)
caxis([0 100]); title(['Sequence: ' p_p.stim_orders(2,:)]); 
xlabel('Time (s)','FontSize',30,'FontWeight','bold'); 
ylabel('Cell number','FontSize',30,'FontWeight','bold');
hold on;
for i=1:length(p_p.stim_on_times)
    rectangle('Position',[p_p.stim_on_times(i) 0 p_p.stim_dur/p_p.dt 101],'FaceColor',[.8 .8 .8 .5])
end

subplot(2,5,[4,5,9,10])
plot(0:6,p_1_2_dists,'LineWidth',3)
set(gca,'Position',[.5 .1 .4 .8])
title('Distance between network states'); 
xlabel('Stimulus #','FontSize',30,'FontWeight','bold'); 
ylabel('Euclidean distance','FontSize',30,'FontWeight','bold')
saveas(gcf,[saveStr '/2word_1v2'],'fig')
%saveas(gcf,[saveStr '/2word_1v2'],'tiffn')
print([saveStr '/2word_1v2'],'-dtiffn','-r300')

%% 2-word seqs (1,3)
figure('Position',[100 100 2000 1400]);
subplot(2,5,[1,2])
imagesc(mean_rs_p{1}(1:p_p.Ne,:));
colormap(cmap); h1=colorbar(); ylabel(h1,'Firing rate (Hz)','FontSize',25)
set(gca,'XTick',1:1000:12000,'XTickLabel',1:12)
caxis([0 100]); title(['Sequence: ' p_p.stim_orders(1,:)]); 
xlabel('Time (s)','FontSize',30,'FontWeight','bold'); 
ylabel('Cell number','FontSize',30,'FontWeight','bold');
hold on;
for i=1:length(p_p.stim_on_times)
    rectangle('Position',[p_p.stim_on_times(i) 0 p_p.stim_dur/p_p.dt 101],'FaceColor',[.8 .8 .8 .5])
end

subplot(2,5,[6,7])
imagesc(mean_rs_p{3}(1:p_p.Ne,:));
colormap(cmap); h2=colorbar(); ylabel(h2,'Firing rate (Hz)','FontSize',25)
set(gca,'XTick',1:1000:12000,'XTickLabel',1:12)
caxis([0 100]); title(['Sequence: ' p_p.stim_orders(3,:)]); 
xlabel('Time (s)','FontSize',30,'FontWeight','bold'); 
ylabel('Cell number','FontSize',30,'FontWeight','bold');
hold on;
for i=1:length(p_p.stim_on_times)
    rectangle('Position',[p_p.stim_on_times(i) 0 p_p.stim_dur/p_p.dt 101],'FaceColor',[.8 .8 .8 .5])
end

subplot(2,5,[4,5,9,10])
plot(0:6,p_1_3_dists,'LineWidth',3)
set(gca,'Position',[.5 .1 .4 .8])
title('Distance between network states'); 
xlabel('Stimulus #','FontSize',30,'FontWeight','bold'); 
ylabel('Euclidean distance','FontSize',30,'FontWeight','bold')
saveas(gcf,[saveStr '/2word_1v3'],'fig')
%saveas(gcf,[saveStr '/2word_1v3'],'tiffn')
print([saveStr '/2word_1v3'],'-dtiffn','-r300')
%% Load data from 7-word sequences
p_ws = load('Fig4data/word_seqs/p.mat'); p_ws = p_ws.p;
for i=1:3
    data = load(['Fig4data/word_seqs/seq' num2str(i) '/mean_r.mat']); data = data.mean_r;
    states = load(['Fig4data/word_seqs/seq' num2str(i) '/state.mat']); states = states.state;
    ws_states{i} = states;
    mean_rs_ws{i} = data;
end
for i=1:size(ws_states{1},2)
    d12 = dist([ws_states{1}(:,i) ws_states{2}(:,i)]);
    d13 = dist([ws_states{1}(:,i) ws_states{3}(:,i)]);
    ws_1_2_dists(i) = d12(1,2);
    ws_1_3_dists(i) = d13(1,2);
end
%% 7-word seqs (1,2)
figure('Position',[100 100 2000 1400]);
subplot(2,5,[1,2])
imagesc(mean_rs_ws{1}(1:p_ws.Ne,:));
colormap(cmap); h1=colorbar(); ylabel(h1,'Firing rate (Hz)','FontSize',25)
set(gca,'XTick',1:1000:12000,'XTickLabel',1:12)
caxis([0 100]); title(['Sequence: ' p_ws.word_seqs(1,:)]); 
xlabel('Time (s)','FontSize',30,'FontWeight','bold'); 
ylabel('Cell number','FontSize',30,'FontWeight','bold');
hold on;
for i=1:length(p_p.stim_on_times)
    rectangle('Position',[p_p.stim_on_times(i) 0 p_p.stim_dur/p_p.dt 101],'FaceColor',[.8 .8 .8 .5])
end

subplot(2,5,[6,7])
imagesc(mean_rs_ws{2}(1:p_ws.Ne,:));
colormap(cmap); h2=colorbar(); ylabel(h2,'Firing rate (Hz)','FontSize',25)
set(gca,'XTick',1:1000:12000,'XTickLabel',1:12)
caxis([0 100]); title(['Sequence: ' p_ws.word_seqs(2,:)]); 
xlabel('Time (s)','FontSize',30,'FontWeight','bold'); 
ylabel('Cell number','FontSize',30,'FontWeight','bold');
hold on;
for i=1:length(p_p.stim_on_times)
    rectangle('Position',[p_p.stim_on_times(i) 0 p_p.stim_dur/p_p.dt 101],'FaceColor',[.8 .8 .8 .5])
end

subplot(2,5,[4,5,9,10])
plot(0:6,ws_1_2_dists,'LineWidth',3)
set(gca,'Position',[.5 .1 .4 .8])
title('Distance between network states'); 
xlabel('Stimulus #','FontSize',30,'FontWeight','bold'); 
ylabel('Euclidean distance','FontSize',30,'FontWeight','bold')
saveas(gcf,[saveStr '/7word_1v2'],'fig')
%saveas(gcf,[saveStr '/7word_1v2'],'tiffn')
print([saveStr '/7word_1v2'],'-dtiffn','-r300')
%% 7-word seqs (1,3)
figure('Position',[100 100 2000 1400]);
subplot(2,5,[1,2])
imagesc(mean_rs_ws{1}(1:p_ws.Ne,:));
colormap(cmap); h1=colorbar(); ylabel(h1,'Firing rate (Hz)','FontSize',25)
set(gca,'XTick',1:1000:12000,'XTickLabel',1:12)
caxis([0 100]); title(['Sequence: ' p_ws.word_seqs(1,:)]); 
xlabel('Time (s)','FontSize',30,'FontWeight','bold'); 
ylabel('Cell number','FontSize',30,'FontWeight','bold');
hold on;
for i=1:length(p_p.stim_on_times)
    rectangle('Position',[p_p.stim_on_times(i) 0 p_p.stim_dur/p_p.dt 101],'FaceColor',[.8 .8 .8 .5])
end

subplot(2,5,[6,7])
imagesc(mean_rs_ws{3}(1:p_ws.Ne,:));
colormap(cmap); h2=colorbar(); ylabel(h2,'Firing rate (Hz)','FontSize',25)
set(gca,'XTick',1:1000:12000,'XTickLabel',1:12)
caxis([0 100]); title(['Sequence: ' p_ws.word_seqs(3,:)]); 
xlabel('Time (s)','FontSize',30,'FontWeight','bold'); 
ylabel('Cell number','FontSize',30,'FontWeight','bold');
hold on;
for i=1:length(p_p.stim_on_times)
    rectangle('Position',[p_p.stim_on_times(i) 0 p_p.stim_dur/p_p.dt 101],'FaceColor',[.8 .8 .8 .5])
end

subplot(2,5,[4,5,9,10])
plot(0:6,ws_1_3_dists,'LineWidth',3)
set(gca,'Position',[.5 .1 .4 .8])
title('Distance between network states'); 
xlabel('Stimulus #','FontSize',30,'FontWeight','bold'); 
ylabel('Euclidean distance','FontSize',30,'FontWeight','bold')
saveas(gcf,[saveStr '/7word_1v3'],'fig')
%saveas(gcf,[saveStr '/7word_1v3'],'tiffn')
print([saveStr '/7word_1v3'],'-dtiffn','-r300')