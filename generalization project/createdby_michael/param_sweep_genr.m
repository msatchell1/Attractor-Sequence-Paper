function [LCO] = param_sweep_genr(LCO,tp)
% Function to vary parameters over multiple simulations. May also be used
% simply to rerun simulation sets using the same stimuli (stim_seed),
% creating multiple sets of data points because of the random connections
% and noise in the network.

% vary_p.param1 = "stim_seed";
% vary_p.values1 = stim_seed;

p = make_params_genr(); % to get p.Ne
num_sweeps = 5;


% Array to hold avg rate data for all parameter sweeps.
all_r_avg = zeros(num_sweeps,length(tp.type_combs),p.Ne);
types = zeros(num_sweeps,length(tp.type_combs),tp.num_char);

% This loop runs the simulations num_sweeps number of times, each time with
% different network connectvities and noise.
for i = 1:num_sweeps
    
    p = make_params_genr("stim_seed",LCO.stim_seed, "num_char",tp.num_char, "num_type",tp.num_type, "type_combs",tp.type_combs);

    all_r_avg(i,:,:) = run_main(p);
    types(i,:,:) = tp.type_combs'; % Stores the types used for the simulations just ran.

end

LCO.types = types; % Assigns types to linear classification parameters so
% it can be worked on later.
LCO.r_avg = all_r_avg;




% % Plot differences in firing rates between sweeps.
% figure(2);
% hold on;
% colors = ["blue","green","red","black"];
% for i = 1:size(all_r_avg,1)
%     for j = 1:size(all_r_avg,2)
%         
%         ydata = squeeze(all_r_avg(i,j,:));
%         xdata = 1:p.Ne;
%         plt2 = plot(xdata,ydata, '.', 'DisplayName', strcat('Network Setup',num2str(i)));
%         plt2.MarkerSize = 10;
%         plt2.Color = colors(i);
%     
%     end
% end
% 
% lgd = legend();


end