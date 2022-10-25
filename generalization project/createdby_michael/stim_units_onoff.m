function [stim_on, nostim_on, stim_off, nostim_off] = stim_units_onoff(r,p,Iapp)
% Takes the firing data and parameter data and returns which units were
% turned on by the stimulus during the stimulus application period
% (stim_on), which units got no stimulus but turned on (nostim_on),
% which units got stimulus but stayed off (stim_off), and which units got
% no stimulus and stayed off(nostim_off). Note this is ONLY for during the
% stimulus application period.

stim_on = zeros(size(r,1),1);
nostim_on = zeros(size(r,1),1);
stim_off = zeros(size(r,1),1);
nostim_off = zeros(size(r,1),1);

r_duringStim = r(:,p.stim_start:p.stim_end);
Iapp_duringStim = Iapp(:,p.stim_start:p.stim_end);

for unit_ID = 1:size(r,1)
    % Using 40 Hz as the threshold to determine is a unit was turned on.
    if any( r_duringStim(unit_ID,:) > 40) 
        
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
