function [all_r_avg] = run_main(p)
% Function for running the network from Ben's paper. I plan to use this network 
% for the generalization project. I have altered make_params_genr to
% include parameters for stimulus inputs with variable number of
% characteristics and types. The stimulus is applied at a variable time in
% the simulation to a fraction of units. Firing rates are then averaged. -
% Michael Satchell 9/30/2022
%
% Inputs: p
% p - parameter structure
%
% Outputs: all_r_avg
% all_r_avg - average firing rates over a period defined in p for each
% possible combination of stimuli. 


% I have changed the stimulus to be:
% Iapp(units, params.stim_start:params.stim_end) = stim_amps(char);
% Which applies a constant amplitude input to p.num_char groups of units, one for
% each characteristic, over a time period between stim_start and stim_end.



% p = make_params_genr();
% 
% stim_choice = {1,2}; % The choice of stimulus type for each characteristic.
% % Format is [char1, char2, ...]. The length of stim_choice must equal
% % p.num_char and the value of each element must not exceed p.num_type.
% 
% Iapp = make_Iapp_genr(p,stim_choice);
% 
% [r,D,s] = run_network_genr(p, Iapp, 'silent', 'no');
% 
% [r_e_avg] = get_avg_r(p, r, p.simLength-2000, p.simLength);
% 
% figure(1);
% plot(1:p.Ne, r_e_avg, '.')
% ylabel('Final Avg Firing Rate (Hz)');
% xlabel('Unit ID');
% legend(strjoin(string(stim_choice)));

% %% I want to plot firing rates of units in the network over time
% 
% figure(2);
% hold on;
% 
% for i = 1:size(r,1) % Loops through each unit (row)
%     plot(1:size(r,2), r(i,:))
% end
% title('All units in network');
% xlabel('time (ms)');
% ylabel('Firing rate (Hz)');
% hold off;


%% Simulating all possible combinations of type inputs.
% I want to have the network run with all possible combinations of inputs,
% which should be a total number of num_type^num_char simulations. To do
% this I can use a meshgrid! (remember from physics coding?). I think
% num_char represents the number of dimensions in the matrix, where all the
% matrix dimensions will have equal length num_type. Thus for 2
% characteristics and 3 types we have a 3 x 3 matrix, and for 3
% characteristics we have a 3 x 3 x 3 matrix. 


all_r_avg = zeros(size(p.type_combs,2),p.Ne); % Array to hold final avg firing rates for
% all possible stimuli. For excitatory units.

for j = 1:size(p.type_combs,2) % Loops through all possible type input combinations.

    stim_choice = num2cell(p.type_combs(:,j)); % Selects a stimulus and turn it 
    % into a cell for use in make_Iapp_genr().
    
    Iapp = make_Iapp_genr(p,stim_choice);

    [r,D,s] = run_network_genr(p, Iapp, 'random', 'no');

    [r_e_avg] = get_avg_r(p, r, p.simLength-2000, p.simLength); % Gets average firing rate of each unit.
    all_r_avg(j,:) = r_e_avg'; % Stores each vector.
    
%     figure(3);
%     hold on;
%     plt1 = plot(1:p.Ne, r_e_avg, '.', 'DisplayName', strjoin(string(stim_choice)));
%     plt1.MarkerSize = 10;
             
end
% 
% ylabel('Final Avg Firing Rate (Hz)');
% xlabel('Unit ID');
% lgd = legend();
% lgd.Title.String = "Stimulus Code";
% lgd.Location = "east";
% hold off;

end

