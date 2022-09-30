% function [] = param_sweep_genr()
% Function to vary parameters over multiple simulations.

vary_p.param1 = 'rng_seed';
vary_p.values1 = [11,12,13];

% Array to hold avg rate data for all parameter sweeps.
all_r_avg = zeros(length(vary_p.values1),length(p.type_combs),p.Ne);

% This loop runs through parameter values, running simulations on each one.
for i = 1:length(vary_p.values1)
    
    p = make_params_genr(vary_p.param1,vary_p.values1(i), 'num_type',2, 'num_char',2);

    all_r_avg(i,:,:) = run_main(p);

end

% 
% figure(1);
% hold on;
% for i = 1:size(p.type_combs,2)
%     comb = p.type_combs(:,i);
%     plt1 = plot(1:p.Ne, all_r_avg(i,:), '.', 'DisplayName', strjoin(string(comb)));
%     plt1.MarkerSize = 10;
% end
% 
% ylabel('Final Avg Firing Rate (Hz)');
% xlabel('Unit ID');
% lgd = legend();
% lgd.Title.String = "Stimulus Code";
% lgd.Location = "east";
% hold off;

figure(2);
hold on;
colors = ["blue","green","red","black"];
for i = 1:size(all_r_avg,1)
    for j = 1:size(all_r_avg,2)
        
        ydata = squeeze(all_r_avg(i,j,:));
        xdata = 1:p.Ne;
        plt2 = plot(xdata,ydata, '.', 'DisplayName', strcat("rng seed ", string(vary_p.values1(i))));
        plt2.MarkerSize = 10;
        plt2.Color = colors(i);
    
    end
end

lgd = legend();


% end