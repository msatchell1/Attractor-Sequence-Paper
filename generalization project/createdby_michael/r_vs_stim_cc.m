function [corr_coef] = r_vs_stim_cc(p,t, stim_choice)
% Function that takes simulation parameters, a correlation coefficient
% calculation time, and ..., and returns the correlation coefficient
% calculated between the firing rates and stimulus amplitudes at that time.

% Runs simulation:
Iapp = make_Iapp_genr(p,stim_choice);
[r,~,~] = run_network_genr(p, Iapp, 'silent', 'no');


% Calculates correlation coefficient for all times after stimulus onset:
units_I_amp = Iapp(1:end-1, p.stim_start);

t_r = r(1:end-1, t); % Grabs firing rate for all E units at time t.

corr_mat = corrcoef(units_I_amp, t_r);
corr_coef = corr_mat(1,2); % Grabs the correlation between the stimulus 
% amplitudes and the current firing rates.




end