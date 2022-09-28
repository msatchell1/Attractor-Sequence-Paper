%% Script for running the network from Ben's paper. I plan to use this network 
% for the generalization project. I need to figure out how to change the
% stimulus so that it is not longer a sequence and instead is customizable
% by me.


p = make_params_genr();

seq = [1,1,1,2,2,2];

Iapp = make_Iapp_genr(p,seq);

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