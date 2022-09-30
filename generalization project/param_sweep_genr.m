% function [] = param_sweep_genr()
% Function to vary parameters over multiple simulations.

vary_p.param1 = "rng_seed";
vary_p.values1 = [11,15];

p = make_params_genr();
% Since parameters p are changing in the loop below, its important that
% none of those changing parameters are included in LCp, because only the
% information of the parameter set p defined above will be fed to make_LC_params().
LCp = make_LC_params();

% Array to hold avg rate data for all parameter sweeps.
all_r_avg = zeros(length(vary_p.values1),length(p.type_combs),p.Ne);
X_types = zeros(size(all_r_avg,1),size(all_r_avg,2), p.num_type);

% This loop runs through parameter values, running simulations on each one.
for i = 1:length(vary_p.values1)
    
    p = make_params_genr(vary_p.param1,vary_p.values1(i));

    all_r_avg(i,:,:) = run_main(p);
    X_types(i,:,:) = p.type_combs'; % Stores the types used for the simulations just ran.

end

LCp.types = X_types; % Assigns types to linear classification parameters so
% it can be worked on later.
LCp.r_avg = all_r_avg;




for k = 1:size(all_r_avg,1)
    figure(); 
    hold on; 
    for i = 1:size(p.type_combs,2)
        comb = p.type_combs(:,i); 
        plt1 = plot(1:p.Ne, squeeze(all_r_avg(k,i,:)), '.','DisplayName', strjoin(string(comb))); 
        plt1.MarkerSize = 10;
    end

    ylabel('Final Avg Firing Rate (Hz)'); 
    xlabel('Unit ID'); 
    title(strcat(strrep(vary_p.param1,"_"," ")," ",string(vary_p.values1(k))))
    lgd = legend();
    lgd.Title.String = "Stimulus Code"; 
    lgd.Location = "east"; 
    hold off;
end


% % Plot avg firing rates for multiple parameter runs.
% figure(2);
% hold on;
% colors = ["blue","green","red","black"];
% for i = 1:size(all_r_avg,1)
%     for j = 1:size(all_r_avg,2)
%         
%         ydata = squeeze(all_r_avg(i,j,:));
%         xdata = 1:p.Ne;
%         plt2 = plot(xdata,ydata, '.', 'DisplayName', strcat(strrep(vary_p.param1,"_"," ")," ",...
%             string(vary_p.values1(i))));
%         plt2.MarkerSize = 10;
%         plt2.Color = colors(i);
%     
%     end
% end
% 
% lgd = legend();


% end