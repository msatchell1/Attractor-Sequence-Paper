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

stim_dur = 500; % Stimulus duration in ms
stim_amp = 1; % stimulus amplitude
noise_sigma = 0.03; % White noise std for simulation.

p = make_params_genr("stim_seed",1, "num_char",2, "num_type",2,...
        "net_seed",1, "Ne",100, "stim_dur",stim_dur, "mean_stim_amp",stim_amp,...
        "sigma",noise_sigma);

stim_choice = num2cell([1,1]); % Selects a stimulus and turn it 
% into a cell for use in make_Iapp_genr().

Iapp = make_Iapp_genr(p,stim_choice);

[r,D,s] = run_network_genr(p, Iapp, 'silent', 'no');

[r_e_avg] = get_avg_r(p, r, p.simLength-1000, p.simLength); % Gets average firing rate of each unit.



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


% RESULTS:
% I found that neither varying sitmulus amplitude, nor varying stimulus
% duration was able to knock units out of their attractor states. Just
% from observing the firing rates vs time, it seems like whichever units
% get put into the excited firing state at the onset of the stimulus, will
% remain there during and after the stimulus, with no additions from the
% "off" group. 
% However, I did find that by increasing noise to between 0.03 and 0.04, I
% can observe switching of units between firing states (it seems like most
% of the switching happens as off units turning on).


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
param_array = 0.0:0.1:5; % remember matlab uses start:step:stop
param_name = "Stimulus Amplitude";

cc_avgs = zeros(length(param_array),1); % To hold avg correlation coefficient data.
cc_stds = zeros(length(param_array),1); % 

num_sims = 10; % Number of simulations the correlation coefficient will be 
% averaged over.

% Its important to make these lists and then use the same list for each
% parameter loop.
stim_seed_list = rand(num_sims,1);
net_seed_list = rand(num_sims,1);

stim_dur = 250; % Stimulus duration in ms
stim_amp = 1; % stimulus amplitude
noise_sigma = 0.034; % White noise std for simulation.


for k = 1:length(param_array)
    
    param_val = param_array(k);
    cc_temps = zeros(num_sims,1);
    
    for i = 1:num_sims

        stim_seed = stim_seed_list(i);
        net_seed = net_seed_list(i);

        p = make_params_genr("stim_seed",stim_seed, "num_char",2, "num_type",2,...
            "net_seed",net_seed, "Ne",100, "stim_dur",stim_dur, "mean_stim_amp",param_val,...
            "sigma",noise_sigma);

        stim_choice = num2cell([1,1]);

        corr_coef = r_vs_stim_cc(p, p.simLength, stim_choice); % Runs simulation
        % and gets cc data at requested time.
        
        cc_temps(i) = corr_coef;
    end

    cc_avgs(k) = mean(cc_temps);
    cc_stds(k) = std(cc_temps);
    
end


figure();
errorbar(param_array, cc_avgs, cc_stds, "o");
title(strcat("Effect of ",param_name," on Firing Rate Correlation with Stimulus"));
xlabel(param_name)
ylabel("Avg Correlation Coefficient")



%% Correlation between hyperplane vector dot products and stimulus overlap
% I want to measure how much of an effect the overlap in stimulus inputs
% has on the resultant dot product of the hyperplane vectors. This will
% only apply to hyperplanes where the data is split by the same
% characteristic. The stimulus overlap will be a measure of how many
% stimulus units two 