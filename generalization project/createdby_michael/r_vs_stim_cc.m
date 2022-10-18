function [corr_coef] = r_vs_stim_cc(p, t_range, stim_choice)
% Function that takes simulation parameters, the time range over which to 
% average firing rates, and the stimulus choice. The simulation is run and then
% returns the correlation coefficient
% calculated between the firing rates and stimulus amplitudes at that time.

% Runs simulation:
Iapp = make_Iapp_genr(p,stim_choice);
[r,~,~] = run_network_genr(p, Iapp, 'silent', 'no');


% Calculates correlation coefficient for all times after stimulus onset:
units_I_amp = Iapp(1:end-1, p.stim_start);

t_range_r = r(1:end-1, t_range(1):t_range(2)); % Grabs firing rate for all E units at time t.
mean_r = mean(t_range_r, 2); % Takes mean over time range.

corr_mat = corrcoef(units_I_amp, mean_r);
corr_coef = corr_mat(1,2); % Grabs the correlation between the stimulus 
% amplitudes and the current firing rates.




end