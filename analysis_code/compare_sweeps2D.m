function [] = compare_sweeps2D(sweep1,sweep2,Sweep1Label,Sweep2Label,useinterp,saveFigs,saveStr)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% Tool for comparing 1D parameter sweeps
% Inputs are the same as to compare_sweeps()
rl1 = load([sweep1 '/run_log.mat']); rl1=rl1.run_log;
rl2 = load([sweep2 '/run_log.mat']); rl2=rl2.run_log;
if (abs(rl1.param1_range(1)) < 1)
    disp(['Sweep1 variable 1 range: ' sprintf('%.2f ',round(rl1.param1_range,3))])
    disp(['Sweep2 variable 1 range: ' sprintf('%.2f ',round(rl2.param1_range,3))])
else
    disp(['Sweep1 variable 1 range: ' sprintf('%d ',round(rl1.param1_range,3))])
    disp(['Sweep2 variable 1 range: ' sprintf('%d ',round(rl2.param1_range,3))])
end
if (abs(rl1.param2_range(1)) < 1)
    disp(['Sweep1 variable 2 range: ' sprintf('%.2f ',round(rl1.param2_range,3))])
    disp(['Sweep2 variable 2 range: ' sprintf('%.2f ',round(rl2.param2_range,3))])
else
    disp(['Sweep1 variable 2 range: ' sprintf('%d ',round(rl1.param2_range,3))])
    disp(['Sweep2 variable 2 range: ' sprintf('%d ',round(rl2.param2_range,3))])
end
nv1Sweep1 = length(rl1.param1_range); nv2Sweep1 = length(rl1.param2_range);
nv1Sweep2 = length(rl2.param1_range); nv2Sweep2 = length(rl2.param2_range);
nnets1 = rl1.nnets; nnets2 = rl2.nnets;
param1str = get_param_string(rl1.param1);
param2str = get_param_string(rl1.param2);
[v1Common,s1v1_common_inds,s2v1_common_inds] = intersect(rl1.param1_range,rl2.param1_range);
[v2Common,s1v2_common_inds,s2v2_common_inds] = intersect(rl1.param2_range,rl2.param2_range);

for i=1:nv1Sweep1
    for j=1:nv2Sweep1
        for k=1:nnets1
            curdir = [sweep1 '/' num2str(i) '/' num2str(j) '/net' num2str(k)];
            p = load([curdir '/params.mat']); p=p.p;
            load([curdir '/choice_accuracy_train012456.mat'],'accuracy')
            ca_train012456(i,j,k) = accuracy;
            load([curdir '/choice_accuracy_train24.mat'],'accuracy')
            ca_train24(i,j,k) = accuracy;
            load([curdir '/choice_accuracy_train0156.mat'],'accuracy')
            ca_train0156(i,j,k) = accuracy;
            load([curdir '/choice_accuracy_train06.mat'],'accuracy')
            ca_train06(i,j,k) = accuracy;
            load([curdir '/choice_accuracy_same_first_last.mat'],'accuracy')
            ca_same_first_last(i,j,k) = accuracy;
            load([curdir '/choice_accuracy_first_opposite_choice.mat'],'accuracy')
            ca_first_opposite_choice(i,j,k) = accuracy;
            load([curdir '/choice_accuracy_last_opposite_choice.mat'],'accuracy')
            ca_last_opposite_choice(i,j,k) = accuracy;
            load([curdir '/confusability_matrix.mat'],'cm')
            kappas(i,j,k) = trace(cm)/size(cm,1);
            data{1}.ca_train012456 = ca_train012456;
            data{1}.ca_train24 = ca_train24;
            data{1}.ca_train0156 = ca_train0156;
            data{1}.ca_train06 = ca_train06;
            data{1}.ca_same_first_last = ca_same_first_last;
            data{1}.ca_first_opposite_choice = ca_first_opposite_choice;
            data{1}.ca_last_opposite_choice = ca_last_opposite_choice;
            data{1}.kappas = kappas;
        end
    end
end
clear ca_train012456 ca_train24 ca_train0156 ca_train06 ca_same_first_last ca_first_opposite_choice ca_last_opposite_choice kappas
for i=1:nv1Sweep2
    for j=1:nv2Sweep2
        for k=1:nnets2
            curdir = [sweep2 '/' num2str(i) '/' num2str(j) '/net' num2str(k)];
            p = load([curdir '/params.mat']); p=p.p;
            load([curdir '/choice_accuracy_train012456.mat'],'accuracy')
            ca_train012456(i,j,k) = accuracy;
            load([curdir '/choice_accuracy_train24.mat'],'accuracy')
            ca_train24(i,j,k) = accuracy;
            load([curdir '/choice_accuracy_train0156.mat'],'accuracy')
            ca_train0156(i,j,k) = accuracy;
            load([curdir '/choice_accuracy_train06.mat'],'accuracy')
            ca_train06(i,j,k) = accuracy;
            load([curdir '/choice_accuracy_same_first_last.mat'],'accuracy')
            ca_same_first_last(i,j,k) = accuracy;
            load([curdir '/choice_accuracy_first_opposite_choice.mat'],'accuracy')
            ca_first_opposite_choice(i,j,k) = accuracy;
            load([curdir '/choice_accuracy_last_opposite_choice.mat'],'accuracy')
            ca_last_opposite_choice(i,j,k) = accuracy;
            load([curdir '/confusability_matrix.mat'],'cm')
            kappas(i,j,k) = trace(cm)/size(cm,1);
            data{2}.ca_train012456 = ca_train012456;
            data{2}.ca_train24 = ca_train24;
            data{2}.ca_train0156 = ca_train0156;
            data{2}.ca_train06 = ca_train06;
            data{2}.ca_same_first_last = ca_same_first_last;
            data{2}.ca_first_opposite_choice = ca_first_opposite_choice;
            data{2}.ca_last_opposite_choice = ca_last_opposite_choice;
            data{2}.kappas = kappas;
        end
    end
end
clear ca_train012456 ca_train24 ca_train0156 ca_train06 ca_same_first_last ca_first_opposite_choice ca_last_opposite_choice

switch useinterp
    case 'yes'
        npts=100;
        % interpolate for all variables saved in data{1} (that is for
        % sweep1)
        xrange = rl1.param1_range; yrange = rl1.param2_range;
        [X,Y] = meshgrid(xrange,yrange);
        xdt = (max(xrange) - min(xrange))/npts;
        ydt = (max(yrange) - min(yrange))/npts;
        interp_x_range1 = min(xrange):xdt:max(xrange);
        interp_y_range1 = min(yrange):ydt:max(yrange);
        xticklocs1 = linspace(1,npts,length(rl1.param1_range));  xtickvals1 = rl1.param1_range;
        yticklocs1 = linspace(1,npts,length(rl1.param2_range)); ytickvals1 = rl1.param2_range;
        [interp_X,interp_Y] = meshgrid(interp_x_range1,interp_y_range1);
        fieldnames1 = fieldnames(data{1});
        for i=1:length(fieldnames1)
            data{1}.(['interp_'  fieldnames1{i}]) = interp2(X,Y,mean(data{1}.(fieldnames1{i}),3)',interp_X,interp_Y);
        end
        
        % interpolate for all variables saved in data{2} (that is for
        % sweep2)
        xrange = rl2.param1_range; yrange = rl2.param2_range;
        [X,Y] = meshgrid(xrange,yrange);
        xdt = (max(xrange) - min(xrange))/npts;
        ydt = (max(yrange) - min(yrange))/npts;
        interp_x_range2 = min(xrange):xdt:max(xrange);
        interp_y_range2 = min(yrange):ydt:max(yrange);
        xticklocs2 = linspace(1,npts,length(rl2.param1_range)); xtickvals2 = rl2.param1_range;
        yticklocs2 = linspace(1,npts,length(rl2.param2_range)); ytickvals2 = rl2.param2_range;
        [interp_X,interp_Y] = meshgrid(interp_x_range2,interp_y_range2);
        fieldnames2 = fieldnames(data{2});
        for i=1:length(fieldnames2)
            data{2}.(['interp_'  fieldnames2{i}]) = interp2(X,Y,mean(data{2}.(fieldnames2{i}),3)',interp_X,interp_Y);
        end
        
        [interp_v1Common,interp_s1v1_common_inds,interp_s2v1_common_inds] = intersect(interp_x_range1,interp_x_range2);
        [interp_v2Common,interp_s1v2_common_inds,interp_s2v2_common_inds] = intersect(interp_y_range1,interp_y_range2);
        
    case 'no'
        xrange = rl1.param1_range; yrange = rl1.param2_range;
        xticklocs1 = 1:length(xrange); yticklocs1 = 1:length(yrange);
end

compare_sweeps2D_plotter(data,'kappas',interp_s1v1_common_inds,interp_s1v2_common_inds, ...
    interp_s2v1_common_inds,interp_s2v2_common_inds,s1v1_common_inds,s1v2_common_inds, ...
    s2v1_common_inds,s2v2_common_inds,param1str,param2str,Sweep1Label,Sweep2Label, ...
    xticklocs1,xtickvals1,yticklocs1,ytickvals1,xticklocs2,xtickvals2,yticklocs2,ytickvals2,saveFigs,saveStr)

compare_sweeps2D_plotter(data,'ca_train012456',interp_s1v1_common_inds,interp_s1v2_common_inds, ...
    interp_s2v1_common_inds,interp_s2v2_common_inds,s1v1_common_inds,s1v2_common_inds, ...
    s2v1_common_inds,s2v2_common_inds,param1str,param2str,Sweep1Label,Sweep2Label, ...
    xticklocs1,xtickvals1,yticklocs1,ytickvals1,xticklocs2,xtickvals2,yticklocs2,ytickvals2,saveFigs,saveStr)

compare_sweeps2D_plotter(data,'ca_train24',interp_s1v1_common_inds,interp_s1v2_common_inds, ...
    interp_s2v1_common_inds,interp_s2v2_common_inds,s1v1_common_inds,s1v2_common_inds, ...
    s2v1_common_inds,s2v2_common_inds,param1str,param2str,Sweep1Label,Sweep2Label, ...
    xticklocs1,xtickvals1,yticklocs1,ytickvals1,xticklocs2,xtickvals2,yticklocs2,ytickvals2,saveFigs,saveStr)

compare_sweeps2D_plotter(data,'ca_train0156',interp_s1v1_common_inds,interp_s1v2_common_inds, ...
    interp_s2v1_common_inds,interp_s2v2_common_inds,s1v1_common_inds,s1v2_common_inds, ...
    s2v1_common_inds,s2v2_common_inds,param1str,param2str,Sweep1Label,Sweep2Label, ...
    xticklocs1,xtickvals1,yticklocs1,ytickvals1,xticklocs2,xtickvals2,yticklocs2,ytickvals2,saveFigs,saveStr)

compare_sweeps2D_plotter(data,'ca_train15',interp_s1v1_common_inds,interp_s1v2_common_inds, ...
    interp_s2v1_common_inds,interp_s2v2_common_inds,s1v1_common_inds,s1v2_common_inds, ...
    s2v1_common_inds,s2v2_common_inds,param1str,param2str,Sweep1Label,Sweep2Label, ...
    xticklocs1,xtickvals1,yticklocs1,ytickvals1,xticklocs2,xtickvals2,yticklocs2,ytickvals2,saveFigs,saveStr)

compare_sweeps2D_plotter(data,'ca_train06',interp_s1v1_common_inds,interp_s1v2_common_inds, ...
    interp_s2v1_common_inds,interp_s2v2_common_inds,s1v1_common_inds,s1v2_common_inds, ...
    s2v1_common_inds,s2v2_common_inds,param1str,param2str,Sweep1Label,Sweep2Label, ...
    xticklocs1,xtickvals1,yticklocs1,ytickvals1,xticklocs2,xtickvals2,yticklocs2,ytickvals2,saveFigs,saveStr)

compare_sweeps2D_plotter(data,'ca_same_first_last',interp_s1v1_common_inds,interp_s1v2_common_inds, ...
    interp_s2v1_common_inds,interp_s2v2_common_inds,s1v1_common_inds,s1v2_common_inds, ...
    s2v1_common_inds,s2v2_common_inds,param1str,param2str,Sweep1Label,Sweep2Label, ...
    xticklocs1,xtickvals1,yticklocs1,ytickvals1,xticklocs2,xtickvals2,yticklocs2,ytickvals2,saveFigs,saveStr)

compare_sweeps2D_plotter(data,'ca_first_opposite_choice',interp_s1v1_common_inds,interp_s1v2_common_inds, ...
    interp_s2v1_common_inds,interp_s2v2_common_inds,s1v1_common_inds,s1v2_common_inds, ...
    s2v1_common_inds,s2v2_common_inds,param1str,param2str,Sweep1Label,Sweep2Label, ...
    xticklocs1,xtickvals1,yticklocs1,ytickvals1,xticklocs2,xtickvals2,yticklocs2,ytickvals2,saveFigs,saveStr)

compare_sweeps2D_plotter(data,'ca_last_opposite_choice',interp_s1v1_common_inds,interp_s1v2_common_inds, ...
    interp_s2v1_common_inds,interp_s2v2_common_inds,s1v1_common_inds,s1v2_common_inds, ...
    s2v1_common_inds,s2v2_common_inds,param1str,param2str,Sweep1Label,Sweep2Label, ...
    xticklocs1,xtickvals1,yticklocs1,ytickvals1,xticklocs2,xtickvals2,yticklocs2,ytickvals2,saveFigs,saveStr)
end

