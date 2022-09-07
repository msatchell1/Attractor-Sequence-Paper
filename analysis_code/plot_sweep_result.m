function plot_sweep_result(sweep,field,npts,figTitle,saveFig,saveStr)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% Helper function used to generate several of the plots used in the paper.
% This function loads data from each network in a 2D parameter sweep and
% interpolates the values for parameter sets in between those actually
% sampled.
% 
% Inputs:
% 1. sweep: top level directory of a 2D parameter sweep
% 2. field: name of the datafile to load from each network (without .mat)
% 3. npts: the final number of points along each dimension (determines how
%          much interpolation to do). e.g. if npts=100 and length(xrange)
%          (or equivalently length(run_log.param1_range)) is 10, then 90
%          values must be interpolated along the x-direction.
% 4. figTitle: optional title for generated figure
% 5. saveFig: 'yes' or 'no' option to save the generated figure
% 6. saveStr: path and filename at which to save the figure
rl = load([sweep '/run_log.mat']); rl = rl.run_log;
var1str = get_param_string(rl.param1); var2str = get_param_string(rl.param2);
xrange = rl.param1_range; yrange = rl.param2_range;
[X,Y] = meshgrid(xrange,yrange);
xdt = (max(xrange) - min(xrange))/npts;
ydt = (max(yrange) - min(yrange))/npts;
interp_x_range = min(xrange):xdt:max(xrange);
interp_y_range = min(yrange):ydt:max(yrange);
[interp_X,interp_Y] = meshgrid(interp_x_range,interp_y_range);


for i=1:length(xrange)
    for j=1:length(yrange)
        for k=1:rl.nnets
            curdir = [sweep '/' num2str(i) '/' num2str(j) '/net' num2str(k)];
            data = load([curdir '/' field '.mat']);
            if (contains(field,'accuracy'))
                datum(i,j,k)=data.accuracy;
                colorBarLabel = 'Choice Accuracy';
            elseif (contains(field,'confusability'))
                nseqs = size(data.cm,1);
                datum(i,j,k)=(1 - (1 - trace(data.cm)/nseqs)/(1 - 1/nseqs));
                colorBarLabel = 'Sequence Discrimination';
            elseif (contains(field,'cm_new'))
                nseqs = size(data.cm,1);
                datum(i,j,k) = (1 - (1 - trace(data.cm)/nseqs)/(1-1/nseqs));
                colorBarLabel = 'Sequence Discrimination';
            elseif (contains(field,'cm_binary'))
                nseqs = size(data.cm,1);
                datum(i,j,k) = (1 - (1 - trace(data.cm)/nseqs)/(1-1/nseqs));
                colorBarLabel = 'Sequence Discrimination';
            else
                error('Wrong field given')
            end
        end
    end
end
data_mean = mean(datum,3);
interp_data_mean = interp2(X,Y,data_mean',interp_X,interp_Y);

xticklocs = linspace(1,npts,length(xrange)); xtickvals = xrange;
yticklocs = linspace(1,npts,length(yrange)); ytickvals = yrange;
imagesc(interp_data_mean); colormap(jet); h=colorbar(); xlabel(var1str,'FontSize',30,'FontWeight','bold'); ylabel(var2str,'FontSize',30,'FontWeight','bold')
set(gca,'Ydir','normal','XTick',xticklocs,'XTickLabel',xtickvals,'XTickLabelRotation',60,'YTick',yticklocs,'YTickLabel',ytickvals,'FontSize',25); 
caxis([0 1])
ylabel(h,colorBarLabel,'FontSize',30,'FontWeight','bold')
if (~strcmp(figTitle,''))
    title(figTitle,'FontSize',20,'FontWeight','bold')
end
if (strcmp(saveFig,'yes'))
    saveas(gcf,saveStr,'fig')
    saveas(gcf,saveStr,'tiffn')
end

