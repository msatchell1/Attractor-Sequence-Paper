function [params] = makeWeightMatrix(params)

net_s = RandStream('mt19937ar', 'Seed',params.net_seed); % defines random 
% number stream for making the connectivity matrix.

params.W = zeros(params.Ngroups,params.Ngroups);
for i=1:params.Ngroups
    for j=1:params.Ngroups
        if (i == j && j <= params.Ne) % excitatory self connections (E0)
            params.W(i,j) = params.W_e0;
        elseif (i == j && j > params.Ne) % inhibitory self connections
            params.W(i,j) = 0;
        elseif (i ~= j && i <= params.Ne && j <= params.Ne) % Inter-group excitatory connections (EE)
            params.W(i,j) = (params.W_ee_max-params.W_ee_min)*rand(net_s)+params.W_ee_min;
        elseif (i ~= j && i <= params.Ne && j > params.Ne) % Excitatory-inhibitory connections (EI)
            params.W(i,j) = params.W_ei;
        elseif (i~= j && i > params.Ne && j <= params.Ne) % Inhibitory-excitatory connections (IE)
            params.W(i,j) = params.W_ie;
        end
        
    end
end
end

