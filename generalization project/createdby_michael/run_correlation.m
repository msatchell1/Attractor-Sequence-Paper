% function [] = run_correlation()
% Runs code to determine the correlation between initial stimulus input,
% and final network activity state. In order for the network to be doing
% anything useful, I can't simply have the units that receive stimulus
% input be the exact same units that are active in the final state. I need
% the network to have an effect on the final state through its connection
% strengths. To acheive this, I will play with the amplitude and duration
% of the stimulus. 

%% Analyzing individual simulations
% The first thing to do is observe individual simulations to get an idea
% for how the network behaves over different values of stimulus amplitude
% and duration.

stim_dur = 250; % Stimulus duration in ms
stim_amp = 1; % stimulus amplitude
noise_sigma = 0.0; % White noise std for simulation.

% Input stimulus fraction of available units assigned to each type and char.
stim_frac_type = 0.3;
stim_frac_char = 0.5;

p = make_params_genr("stim_seed",1, "num_char",2, "num_type",2,...
        "net_seed",1, "Ne",100, "stim_dur",stim_dur, "mean_stim_amp",stim_amp,...
        "sigma",noise_sigma, "stim_frac_type",stim_frac_type, "stim_frac_char",stim_frac_char);

stim_choice = num2cell([2,1]); % Selects a stimulus and turn it 
% into a cell for use in make_Iapp_genr().

Iapp = make_Iapp_genr(p,stim_choice);

[r,D,s] = run_network_genr(p, Iapp, 'silent', 'no');

% Compares stimulus with activity during stimulus period.
[stim_onu, nostim_onu, stim_offu, nostim_offu] = stim_units_onoff(r,p,Iapp);
% Compares stimulus with final network activity.
[stim_onu_fin, nostim_onu_fin, stim_offu_fin, nostim_offu_fin] = final_units_onoff(r,p,Iapp);

% [r_e_avg] = get_avg_r(p, r, p.simLength-1000, p.simLength); % Gets average firing rate of each unit.



% I want to plot firing rates of units in the network over time
figure();
hold on;
for i = 1:size(r,1) % Loops through each unit (row)
    plot(1:size(r,2), r(i,:))
end
title('All units in network');
xlabel('time (ms)');
ylabel('Firing rate (Hz)');
hold off;

% Plotting the firing rate over time using imagesc, as well as the stimulus
% input current.
figure();
% Firing rate plot:
ax_r = axes;
im_r = imagesc(r);
im_r.AlphaData = 1;
axis square
hold all
% Current plot:
ax_i = axes;
im_i = imagesc(Iapp);
im_i.AlphaData = 0.2;
axis square

linkaxes([ax_r,ax_i]); % link axes together
%%Hide the top axes 
ax_i.Visible = 'off'; 
ax_i.XTick = []; 
ax_i.YTick = []; 
%add differenct colormap to different data if you wish 
colormap(ax_r,flipud(colormap('gray')))
colormap(ax_i,'cool') 
%set the axes and colorbar position 
set([ax_r,ax_i],'Position',[.17 .11 .685 .815]); 
cb_r = colorbar(ax_r,'Position',[.05 .11 .0675 .815]); 
cb_i = colorbar(ax_i,'Position',[.88 .11 .0675 .815]); 
cb_r.Label.String = "Firing Rate (Hz)";
cb_i.Label.String = "Stimulus Amplitude";
title("Network Activity and Stimulus Input")

% cb_r1 = colorbar(ax_r,'Location','WestOutside'); 
% cb_r2 = colorbar(ax_i,'Location','EastOutside'); 
% cb_r1.Label.String = "Firing Rate (Hz)";
% cb_r2.Label.String = "Stimulus Amplitude";

% ax_r_pos = get(ax_r, "Position");
% ax_i_pos = get(ax_i, "Position");
% diff_pos = ax_r_pos - ax_i_pos;
% set(ax_i, "Position", ax_i_pos+diff_pos);

% 
% cb_r = colorbar;
% cb_r.Label.String = "Firing Rate (Hz)";
% title("Network Activity");
% ylabel("Unit ID")
% xlabel("Time (ms)")
% 
% xline(p.stim_start,"g--");
% xline(p.stim_end,"r--");





%% Simple Correlation 
% Now I need to quantify my results. I will need to make graphs showing the
% correlation of current firing state relative to which units got the original stimulus input.
% Before I do this, I want to plot unit activity at time t vs
% stimulus input. This will help me visualize what is happening, and
% confirm that only the units which received stimulus input are those that
% become (and stay) active when there is no noise. 


t_measure = p.simLength; % Time at which to extract firing rates (ms).

t_r = r(1:end-1, t_measure); % Grabs firing rates for all E units at t_measure.

units_I_amp = Iapp(1:end-1, p.stim_start);

% Make a scatter plot of unit activity at time t vs stimulus input
% amplitude:
figure();
hold on;
for i = 1:length(t_r)
   scatter(units_I_amp(i),t_r(i)); 
end
xlim([-0.1, stim_amp+0.1]);
ylabel(strcat("Firing rate at time: ", num2str(t_measure), " ms"));
xlabel("Stimulus amplitude");
title("Correlation between activity and stimulus amplitude for all units")


%% Correlation vs time
% Here I loop through all times after p.stim_start, calculating the
% correlation between the stimulus input data to that of the current firing
% rates. The correlation is calculated over all units.

units_I_amp = Iapp(1:end-1, p.stim_start);
cc_overtime = zeros(length(p.stim_start:p.simLength),1);
count = 1;

for t = p.stim_start:p.simLength
    
    t_r = r(1:end-1, t); % Grabs firing rates for all E units at t_measure.

    corr_mat = corrcoef(units_I_amp, t_r);
    corr_coef = corr_mat(1,2); % Grabs the correlation between the stimulus 
    % amplitudes and the current firing rates.
    
    cc_overtime(count) = corr_coef;
    
    count = count + 1;
    
   
end

figure();
plot(p.stim_start:p.simLength, cc_overtime);
title("Correlation of Firing Activity to Stimulus")
ylabel("Correlation Coefficient")
xlabel("Time (ms)")

% end


%% Correlation vs stimulus amplitude and duration
% Now I will plot the correlation value at a given time as a function of
% stimulus amplitude and duration. To make the results more robust, I will
% get the correlation values by averaging results from multiple
% simulations.

% Parameter values to be used. Might be amplitude, duration, etc.
% Note: passing stim_amp = 0 to the simulation gives NaN for the
% correlation, so start the param sweep just above 0. 
param_array = 0:0.0005:0.04; % remember matlab uses start:step:stop
param_name = "Noise Std";

cc_avgs = zeros(length(param_array),1); % To hold avg correlation coefficient data.
cc_stds = zeros(length(param_array),1); % Holds standard deviations of data.
cc_SEMs = zeros(length(param_array),1); % Holds standard error of means for data.

num_sims = 10; % Number of simulations the correlation coefficient will be 
% averaged over.

% Its important to make these lists and then use the same list for each
% parameter loop. WARNING: Seeds provided to RandStream to create random
% number generators are automatically rounded to integers, so it is
% essential not to rely on floats as seeds.
stim_seed_list = rand(num_sims,1).*1000;
net_seed_list = rand(num_sims,1).*1000;

stim_dur = 250; % Stimulus duration in ms
stim_amp = 1; % stimulus amplitude
noise_sigma = 0.0; % White noise std for simulation.
% Input stimulus fraction of available units assigned to each type.
stim_frac_type = 0.3;
% Connection parameters
W_e0     = 87;   % connection strength for excitatory SELF connections (ben's value = 89)
W_ee_max = 1.05; % maximum connection strength for EE connections (ben's value = .342)
W_ei     = 1.45;  % connection strength for EI connections (ben's value = .665)
W_ie     = -540; % connection strength for IE connections (ben's value = -540)




for k = 1:length(param_array)
    
    param_val = param_array(k);
    cc_temps = zeros(num_sims,1);
    
    for i = 1:num_sims

        stim_seed = stim_seed_list(i);
        net_seed = net_seed_list(i);
        
        % Replace variable with "param_val" in order to vary that
        % parameter.
        p = make_params_genr("stim_seed",stim_seed, "num_char",2, "num_type",2,...
            "net_seed",net_seed, "Ne",100, "stim_dur",stim_dur, "mean_stim_amp",stim_amp,...
            "sigma",param_val, "W_e0",W_e0, "W_ee_max",W_ee_max, "W_ei",W_ei, "W_ie",W_ie,...
            "stim_frac_type",stim_frac_type);

        stim_choice = num2cell([1,1]);

        corr_coef = r_vs_stim_cc(p, [(p.simLength - 1000), p.simLength], stim_choice); % Runs simulation
        % and gets cc data at requested time.
        
        cc_temps(i) = corr_coef;
    end

    cc_avgs(k) = mean(cc_temps);
    cc_stds(k) = std(cc_temps);
    cc_SEMs(k) = std(cc_temps)/sqrt(length(cc_temps));
    
end


figure();
errorbar(param_array, cc_avgs, cc_SEMs, "o");
title(strcat("Effect of ",param_name," on Firing Rate Correlation with Stimulus"));
xlabel(param_name)
ylabel("Correlation Coefficient")

%% Run general parameter scans

param_array = 0.6:0.01:1.3; % remember matlab uses start:step:stop
param_name = "Stimulus Amplitude";

% cc_avgs = zeros(length(param_array),1); % To hold avg correlation coefficient data.
% cc_stds = zeros(length(param_array),1); % Holds standard deviations of data.
% cc_SEMs = zeros(length(param_array),1); % Holds standard error of means for data.

stim_off_avgs = zeros(length(param_array),1);
stim_on_avgs = zeros(length(param_array),1);
nostim_on_fin_avgs = zeros(length(param_array),1);
stim_on_fin_avgs = zeros(length(param_array),1);
stim_off_fin_avgs = zeros(length(param_array),1);

offon_ratio_SEMs = zeros(length(param_array),1);
offon_ratio_avgs = zeros(length(param_array),1);

offon_fin_ratio_SEMs = zeros(length(param_array),1);
offon_fin_ratio_avgs = zeros(length(param_array),1);

num_sims = 10; % Number of simulations the correlation coefficient will be 
% averaged over.

% Its important to make these lists and then use the same list for each
% parameter loop. WARNING: Seeds provided to RandStream to create random
% number generators are automatically rounded to integers, so it is
% essential not to rely on floats as seeds.
stim_seed_list = rand(num_sims,1).*1000;
net_seed_list = rand(num_sims,1).*1000;

stim_dur = 250; % Stimulus duration in ms
stim_amp = 1; % stimulus amplitude
noise_sigma = 0.0; % White noise std for simulation.
% Input stimulus fraction of available units assigned to each type.
stim_frac_type = 0.3;
% Connection parameters
W_e0     = 87;   % connection strength for excitatory SELF connections (ben's value = 89)
W_ee_max = 1.05; % maximum connection strength for EE connections (ben's value = .342)
W_ei     = 1.45;  % connection strength for EI connections (ben's value = .665)
W_ie     = -540; % connection strength for IE connections (ben's value = -540)



for k = 1:length(param_array)
    
    param_val = param_array(k);
    stim_off_temps = zeros(num_sims,1);
    stim_on_temps = zeros(num_sims,1);
    offon_fin_ratio_temps = zeros(num_sims,1);
    offon_ratio_temps = zeros(num_sims,1);
    
    for i = 1:num_sims

        stim_seed = stim_seed_list(i);
        net_seed = net_seed_list(i);
        
        % Replace variable with "param_val" in order to vary that
        % parameter.
        p = make_params_genr("stim_seed",stim_seed, "num_char",2, "num_type",2,...
            "net_seed",net_seed, "Ne",100, "stim_dur",stim_dur, "mean_stim_amp",param_val,...
            "sigma",noise_sigma, "W_e0",W_e0, "W_ee_max",W_ee_max, "W_ei",W_ei, "W_ie",W_ie,...
            "stim_frac_type",stim_frac_type);

        stim_choice = num2cell([1,1]);
        
        Iapp = make_Iapp_genr(p,stim_choice);

        [r,D,s] = run_network_genr(p, Iapp, 'silent', 'no');

        % Compares stimulus with activity during stimulus period.
        [stim_onu, nostim_onu, stim_offu, nostim_offu] = stim_units_onoff(r,p,Iapp);
        % Compares stimulus with final network activity.
        [stim_onu_fin, nostim_onu_fin, stim_offu_fin, nostim_offu_fin] = final_units_onoff(r,p,Iapp);
        
        stim_off_temps(i) = sum(stim_offu); % Summing the list of 0s and 1s
        % effectively tells how many units stayed off even when given
        % stimulus. 
        stim_on_temps(i) = sum(stim_onu);
        % Fraction of unactivated stimulated units during stimulus period
        offon_ratio_temps(i) = sum(stim_offu)/(sum(stim_offu)+sum(stim_onu));
        
        % Fraction of unactivated stimulated units in final state
        offon_fin_ratio_temps(i) = sum(stim_offu_fin)/(sum(stim_offu_fin)+sum(stim_onu_fin));
        
%         corr_coef = r_vs_stim_cc(p, [(p.simLength - 1000), p.simLength], stim_choice); % Runs simulation
%         % and gets cc data at requested time.
        
%         cc_temps(i) = corr_coef;
    end
    
    stim_off_avgs(k) = mean(stim_off_temps);
    stim_on_avgs(k) = mean(stim_on_temps);
    % Fraction of stimulated units that didn't turn on.
    offon_ratio_avgs(k) = mean(offon_ratio_temps); 
    offon_ratio_SEMs(k) = std(offon_ratio_temps)/sqrt(length(offon_ratio_temps));
    
    
%     cc_avgs(k) = mean(cc_temps);
%     cc_stds(k) = std(cc_temps);
%     cc_SEMs(k) = std(cc_temps)/sqrt(length(cc_temps));
    
end

figure();
hold on;
errorbar(param_array, offon_ratio_avgs, offon_ratio_SEMs, "o");
title(strcat("Effect of ",param_name," on Stimulus Activation Failure Rate During Stimulus Period"));
xlabel(param_name)
ylabel("(# inactive stimulated units)/(# stimulated units)")

%% 