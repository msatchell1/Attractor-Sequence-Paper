%% For exploring the model

p = make_params();

seq = [1,1,1,2,2,2];

Iapp = make_Iapp(p,seq);

[r,D,s] = run_network(p, Iapp, 'silent', 'no');


%% I want to plot firing rates of units in the network over time

figure(1);
hold on;

for i = 1:size(r,1) % Loops through each unit (row)
    plot(1:size(r,2), r(i,:))
end
title('All units in network');
xlabel('time (ms??)');
ylabel('Firing rate (Hz??)');
hold off;


%% Next plot all the dynamic variables for a single unit over time

unit_ID = 50; % ID of unit to plot

figure(2);

subplot(3,1,1);

plot(1:size(r,2), r(unit_ID,:),'r' ,'DisplayName','r')
ylabel('Firing Rate (Hz)')
legend()

subplot(3,1,2);
plot(1:size(D,2), D(unit_ID,:),'b', 'DisplayName','D')
ylabel('Depression Variable')
legend()

subplot(3,1,3);
plot(1:size(s,2), s(unit_ID,:),'g', 'DisplayName','s')
ylabel('Synaptic Gating Variable')
xlabel('Time (ms)')
legend()
