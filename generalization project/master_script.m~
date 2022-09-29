%% Script for running the network from Ben's paper. I plan to use this network 
% for the generalization project. I need to figure out how to change the
% stimulus so that it is not longer a sequence and instead is customizable
% by me.

% Time course of simulation is 7 intervals of 1500ms with no input,
% seperated by 6 stimuli each of length 250ms for a total of 12000ms
% simulation. 

% To alter the simulus input, I need to change the variable Iapp in
% make_Iapp_genr(). This holds the input stimulus to each unit at each ms
% (so it is a 101 x simLength matrix).


% The stimulus inputs are assigned in a loop repeating this line:
%
% Iapp(params.inputs(seq(i),:),stim_s:stim_e) = stim_amps(i)
%
% The stimulus ID (1 or 2) is grabbed from seq based on which stimulus 
% number (i) we are on. The stimulus ID is then passed to "inputs" which
% holds the IDs of units assigned to receieve each stimulus type.
% This is how the rows of Iapp are selected, indicating the unit IDs. The
% times (columns of Iapp) for which to apply these stimuli are chosen based
% on the stimulus start time (stim_s) and end time (stim_e), both in ms.
% The magnitude of the stimulus is assigned from stim_amps.
%
% I have changed the stimulus to be:
% Iapp(units, params.stim_start:params.stim_end) = stim_amps(char);
% Which applies a constant amplitude input to two groups of units, one for
% each characteristic, over a time period between stim_start and stim_end.



p = make_params_genr();

stim_choice = {1,2}; % The choice of stimulus type for each characteristic.
% Format is [char1, char2, ...]. The length of stim_choice must equal
% p.num_char and the value of each element must not exceed p.num_type.

Iapp = make_Iapp_genr(p,stim_choice);

[r,D,s] = run_network_genr(p, Iapp, 'silent', 'no');

[r_e_avg] = get_avg_r(p, r, p.simLength-2000, p.simLength);

figure(1);
plot(1:p.Ne, r_e_avg, '.')
ylabel('Final Avg Firing Rate (Hz)');
xlabel('Unit ID');
legend(strjoin(string(stim_choice)));

%% I want to plot firing rates of units in the network over time

figure(2);
hold on;

for i = 1:size(r,1) % Loops through each unit (row)
    plot(1:size(r,2), r(i,:))
end
title('All units in network');
xlabel('time (ms)');
ylabel('Firing rate (Hz)');
hold off;


%% Simulating all possible combinations of type inputs.
% I want to have the network run with all possible combinations of inputs,
% which should be a total number of num_type^num_char simulations. To do
% this I can use a meshgrid! (remember from physics coding?). I think
% num_char represents the number of dimensions in the matrix, where all the
% matrix dimensions will have equal length num_type. Thus for 2
% characteristics and 3 types we have a 3 x 3 matrix, and for 3
% characteristics we have a 3 x 3 x 3 matrix. 


types = cell(1, p.num_char); % This will hold the vectors representing the types for
% each characteristic.

for char = 1:p.num_char
    types{char} = 1:p.num_type;
end

% [type_mats{:}] = ndgrid(type_vec); % Creates the matrices.

type_combs =  combvec(types{:}); % Loads all of these vectors into combvec which creates a 
% matrix that is num_types x (total # of combinations). Each columns of
% type_combs is a possible combination.


for j = 1:size(type_combs,2) % Loops through all possible type input combinations.

%     stim_choice_a = cellfun(@(x) x(i), type_mats); % Array to hold type choices for each char.
    stim_choice = type_combs(:,j);
    
    Iapp = make_Iapp_genr(p,stim_choice);

    [r,D,s] = run_network_genr(p, Iapp, 'silent', 'no');

    [r_e_avg] = get_avg_r(p, r, p.simLength-2000, p.simLength);
    
    figure(3);
    hold on;
    plot(1:p.Ne, r_e_avg, '.')
    ylabel('Final Avg Firing Rate (Hz)');
    xlabel('Unit ID');
    legend(strjoin(string(stim_choice)));
             
end

% %% Meshgrid test
% 
% C = 1:p.num_char;
% T = 1:p.num_type;
% 
% [CC,TT] = meshgrid(C,T);
% 
% 
% %% Ndgrid test
% 
% nc = 3;
% nt = 3;
% 
% gridvec = 1:nt;
% output_cell = cell(1,nc);
% 
% [output_cell{:}] = ndgrid(gridvec);
% 
% %% combvec
% 
% V = cell(1,p.num_char);
% 
% for char = 1:p.num_char
%     V{char} = 1:p.num_type;
% end
% 
% COM = combvec(V{:});