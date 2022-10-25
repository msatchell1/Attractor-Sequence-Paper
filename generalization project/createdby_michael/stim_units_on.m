function [on_units] = stim_units_on(r,p)
% Takes the firing data and parameter data and returns which units were
% turned on by the stimulus during the stimulus application period. 

on_units = zeros(size(r,1),1);

r_duringStim = r(:,p.stim_start:p.stim_end);

for unit_ID = 1:size(r,1)
    if any( r_duringStim(unit_ID,:) > 20) % Using 20 Hz as the threshold to
        % dtermine is a unit was turned on.
        
        on_units(unit_ID) = 1; % Index will have value 1 for units that did turn on,
        % and value 0 for units that did not.
        
    end
end