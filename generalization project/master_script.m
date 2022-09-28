%% Script for running the network from Ben's paper. I plan to use this network 
% for the generalization project. I need to figure out how to change the
% stimulus so that it is not longer a sequence and instead is customizable
% by me.

% Time course of simulation is 7 intervals of 1500ms with no input,
% seperated by 6 stimuli each of length 250ms for a total of 12000ms
% simulation. 

% To alter the simulus input, I need to change the variable Iapp in
% make_Iapp_genr(). This holds the input stimulus to each unit at each ms
% (so it is a 101 x 12000 matrix).


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


p = make_params_genr();

stim_choice = [1,1]; % The choice of stimulus type for each characteristic.
% Format is [char1, char2, ...]. The length of stim_choice must equal
% p.num_char and the value of each element must not exceed p.num_type.

Iapp = make_Iapp_genr(p,stim_choice);

[r,D,s] = run_network_genr(p, Iapp, 'silent', 'no');


%% I want to plot firing rates of units in the network over time

figure(1);
hold on;

for i = 1:size(r,1) % Loops through each unit (row)
    plot(1:size(r,2), r(i,:))
end
title('All units in network');
xlabel('time (ms??)');
ylabel('Firing rate (Hz)');
hold off;


%% Making my own network stimulus input

