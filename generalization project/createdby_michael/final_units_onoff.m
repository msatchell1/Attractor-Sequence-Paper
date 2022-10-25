function [stim_on,nostim_on,stim_off,nostim_off] = final_units_onoff(r,p,Iapp)
% Similar to stim_units_onoff, except this time instead of looking at
% activity during the stimulus period, we look at activity in the final
% state of the network. We compare units that got stimulus and didn't get
% stimulus with which units are active in the final state.

stim_on = zeros(size(r,1),1);
nostim_on = zeros(size(r,1),1);
stim_off = zeros(size(r,1),1);
nostim_off = zeros(size(r,1),1);

r_final = r(:,(p.simLength-100):p.simLength); % Will test to see if a unit is 
% active anytime within the last 100 ms of the simulation.
Iapp_duringStim = Iapp(:,p.stim_start:p.stim_end);

for unit_ID = 1:size(r,1)
    % Using 30 Hz as the threshold to determine is a unit was turned on.
    if any( r_final(unit_ID,:) > 30) 
        
        if any( Iapp_duringStim(unit_ID,:) > 0) % Unit is active and got stimulus.
            stim_on(unit_ID) = 1; % Index will have value 1 for units that did turn on,
            % and value 0 for units that did not.
        else % Unit is active without stimulus
            nostim_on(unit_ID) = 1;
        end
        
    else 
        
        if any( Iapp_duringStim(unit_ID,:) > 0) % Unit is inactive but got stimulus.
            stim_off(unit_ID) = 1;
        else % Unit is inactive and got no stimulus.
            nostim_off(unit_ID) = 1;
        end
        
    end
end

