function [mean_intra_ev_dists,mean_inter_ev_dists,hypotheses,pvalues] = analyze_clustering_sweep(datadir)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% This function computes the mean intra/inter cluster distances for an
% entire parameter sweep
% Inputs:
% 1. datadir: the path to the directory containing the data for the whole
%             parameter sweep
% Outputs:
% 1. mean_intra_ev_dists: a (nv1 x nv2 x nnets) matrix containing the mean
%                         intra-cluster distances for all the networks in
%                         the parameter sweep. Entry (i,j,k) gives the
%                         value for the k'th network run for the i'th value
%                         of parameter 1 and the j'th value of parameter 2
% 2. mean_inter_ev_dists: same as for output #1 but giving the mean
%                         inter-cluster distances
% 3. hypotheses: a (nv1 x nv2 x nnets) matrix where each entry specifies 
%                whether or not the intra/inter-cluster distance distributions
%                have significantly different means or not. A value of 1
%                indicates these means were significantly different (using
%                a p-value of .05 as the cutoff)
% 4. pvals: (nv1 x nv2 x nnets) matrix where each entry gives the p-value
%           associated with the comparisons made in the hypotheses output
if (exist([datadir '/mean_intra_ev_dists.mat'],'file'))
    m = load([datadir '/mean_intra_ev_dists.mat']); mean_intra_ev_dists = m.mean_intra_ev_dists;
    m = load([datadir '/mean_inter_ev_dists.mat']); mean_inter_ev_dists = m.mean_inter_ev_dists;
    h = load([datadir '/cluster_dist_hypotheses.mat']); hypotheses = h.cluster_dist_hypotheses;
    p = load([datadir '/cluster_dist_pvalues.mat']); pvalues = p.cluster_dist_pvalues;
else
    rl = load([datadir '/run_log.mat']); rl=rl.run_log;
    nv1 = length(rl.param1_range);
    nv2 = length(rl.param2_range);
    nnets = rl.nnets;

    for i=1:nv1
        for j=1:nv2
            for k=1:nnets
                curdir = [datadir '/' num2str(i) '/' num2str(j) '/net' num2str(k)];
                ca = load([curdir '/choice_accuracy_train_rand_order.mat']); ca=ca.accuracy;
                [meanSeqDists,mean_net_ev_dist,mean_inter_clust_dists] = cluster_analysis(curdir,1);
                idx = eye(7);
                intra_ev_dists = idx.*mean_inter_clust_dists;
                inter_ev_dists = (1-idx).*mean_inter_clust_dists;
                intra_ev_dists = intra_ev_dists(:); intra_ev_dists = intra_ev_dists(intra_ev_dists ~= 0);
                inter_ev_dists = inter_ev_dists(:); inter_ev_dists = inter_ev_dists(inter_ev_dists ~= 0);
                mean_intra_ev_dists(i,j,k) = mean(intra_ev_dists);
                mean_inter_ev_dists(i,j,k) = mean(inter_ev_dists);
                [h,p] = ttest2(intra_ev_dists,inter_ev_dists);
                hypotheses(i,j,k) = h;
                pvalues(i,j,k) = p;
                disp([num2str(i) ' ' num2str(j) ' ' num2str(k)])
            end
        end
    end
    cluster_dist_pvalues = pvalues;
    cluster_dist_hypotheses = hypotheses;
    save([datadir '/mean_intra_ev_dists.mat'],'mean_intra_ev_dists','-mat')
    save([datadir '/mean_inter_ev_dists.mat'],'mean_inter_ev_dists','-mat')
    save([datadir '/cluster_dist_hypotheses.mat'],'cluster_dist_hypotheses','-mat')
    save([datadir '/cluster_dist_pvalues.mat'],'cluster_dist_pvalues','-mat')
    
end
end

