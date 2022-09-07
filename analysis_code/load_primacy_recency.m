function [primacy,recency,accuracy_curves] = load_primacy_recency(datadir)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% This function loads the sp_accuracies computed by the function
% primacy_recency_analysis and uses them to compute the corresponding
% primacy and recency scores. Inputs and outpus are described in the
% description of primacy_recency_analysis.m (see help
% primacy_recency_analysis)
rl = load([datadir '/run_log.mat']); rl=rl.run_log;
nv1 = length(rl.param1_range);
nv2 = length(rl.param2_range);
nnets = 10;

count=0;
for i=1:nv1
    for j=1:nv2
        for k=1:nnets
            count=count+1;
            curdir = [datadir '/' num2str(i) '/' num2str(j) '/net' num2str(k)];
            a = load([curdir '/sp_accuracies.mat']); a=a.sp_accuracies;
            mean_a = mean(a,1);
            accuracy_curves(count,:) = mean_a;
            primacy(i,j,k) = mean_a(1) - mean_a(4);
            recency(i,j,k) = mean_a(7) - mean_a(4);
        end
    end
end
end