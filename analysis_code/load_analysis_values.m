function [data] = load_analysis_values(datadir,loadname,field)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% Helper function to load all of the computed values of a particluar type
% from all networks in a 2D parameter sweep (e.g. load all kappa or 2-choice
% accuracy values)
% Inputs:
% 1. datadir: path to top level directory of a 2D parameter sweep
% 2. loadname: string giving the name of the file to load
% 3. field: string giving the field to extract from the loaded data
%
% Outputs:
% data: (nv1 x nv2 x nnets) matrix where each entry (i,j,k) gives the
%       desired value for the k'th net of the i'th parameter 1 value and
%       j'th parameter 2 value
rl = load([datadir '/run_log.mat']); rl=rl.run_log;
nv1 = length(rl.param1_range);
nv2 = length(rl.param2_range);
nnets = rl.nnets;

for i=1:nv1
    for j=1:nv2
        for k=1:nnets
            curdir = [datadir '/' num2str(i) '/' num2str(j) '/net' num2str(k)];
            seqs = load([curdir '/seqs.mat']); seqs=seqs.seqs;
            p = load([curdir '/params.mat']); p=p.p;
            nseqs = size(seqs,1);
            datum = load([curdir '/' loadname '.mat']); datum=datum.(field);
            switch field
                case 'cm'
                    kappa = (1 - (1 - trace(datum)/nseqs)/(1 - 1/nseqs));
                    data(i,j,k) = kappa;
                case 'accuracy'
                    data(i,j,k) = datum;
            end
        end
    end
end
end

