function [] = compare_sweeps1D(sweep1,sweep2,Sweep1Label,Sweep2Label,useinterp,saveFig,saveStr)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% Tool for comparing 1D parameter sweeps
% Inputs are the same as to compare_sweeps()

rl1 = load([sweep1 '/run_log.mat']); rl1=rl1.run_log;
rl2 = load([sweep2 '/run_log.mat']); rl2=rl2.run_log;
if (abs(rl1.param_range(1)) < 1)
    disp(['Sweep 1 variable range: ' sprintf('%.2f ',rl1.param_range)])
else
    disp(['Sweep 1 variable range: ' sprintf('%d ',rl1.param_range)])
end
if (abs(rl2.param_range(1)) < 1)
    disp(['Sweep 2 variable range: ' sprintf('%.2f ',rl2.param_range)])
else
    disp(['Sweep 2 variable range: ' sprintf('%d ',rl2.param_range)])
end

nvSweep1 = length(rl1.param_range); nvSweep2 = length(rl2.param_range);
nnets1 = rl1.nnets; nnets2 = rl2.nnets;
paramStr = get_param_string(rl1.param);
[vCommon,s1_common_inds,s2_common_inds] = intersect(rl1.param_range,rl2.param_range);

for i=1:nvSweep1
    for j=1:nnets1
        curdir = [sweep1 '/' num2str(i) '/net' num2str(j)];
        p = load([curdir '/params.mat']); p=p.p;
        load([curdir '/choice_accuracy_train_rand_order_binary.mat'],'accuracy')
        ca(i,j) = accuracy;
        load([curdir '/cm_binary.mat'],'cm')
        kappas(i,j) = (1 - (1 - trace(cm)/size(cm,1))/(1-1/size(cm,1)));
    end
end
data{1}.choice_accuracy = ca;
data{1}.kappas = kappas;
clear ca kappas
for i=1:nvSweep2
    for j=1:nnets2
        curdir = [sweep2 '/' num2str(i) '/net' num2str(j)];
        p = load([curdir '/params.mat']); p=p.p;
        load([curdir '/choice_accuracy_train_rand_order_binary.mat'],'accuracy')
        ca(i,j) = accuracy;
        load([curdir '/cm_binary.mat'],'cm')
        kappas(i,j) = trace(cm)/size(cm,1);
    end
end
data{2}.choice_accuracy = ca;
data{2}.kappas = kappas;
clear ca kappas
switch useinterp
    case 'yes'
        % not supported currently
        % maybe write this but probably not necessary
        error('Interpolation not supported')
    case 'no'
        xrange1 = rl1.param_range; xrange2 = rl2.param_range;
        if (length(xrange1) > 10)
            xticklocs1 = 1:length(xrange1)/10:length(xrange1); 
            xticklocs2 = 1:length(xrange2)/10:length(xrange2);
            xtickvals1 = xrange1(1:length(xrange1)/10:length(xrange1));
            xtickvals2 = xrange2(1:length(xrange2)/10:length(xrange2));
        else
            xticklocs1 = 1:length(xrange1); xticklocs2 = 1:length(xrange2);
            xtickvals1 = xrange1; xtickvals2 = xrange2;
        end
    otherwise
        error('Provide either yes or no as useinterp input')
end
compare_sweeps1D_plotter(data,'kappas',s1_common_inds,s2_common_inds,paramStr,Sweep1Label,Sweep2Label,xticklocs1,xtickvals1,xticklocs2,xtickvals2,saveFig,saveStr)
compare_sweeps1D_plotter(data,'choice_accuracy',s1_common_inds,s2_common_inds,paramStr,Sweep1Label,Sweep2Label,xticklocs1,xtickvals1,xticklocs2,xtickvals2,saveFig,saveStr)
end

