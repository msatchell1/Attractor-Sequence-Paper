function [r_e_avg] = get_avg_r(p, r, b_start, b_end)
% Function to return the average firing rate r_avg given the firing rate vs
% time matrix r and the bounds for the time over which to average t_start
% and t_end. Note bound times must be in ms

% Remove inhibitory unit from list and select rates within time bounds.
r_e = r(1:p.Ne, :);
r_e_b = r_e(:, b_start:b_end);

r_e_avg = mean(r_e_b,2);

end