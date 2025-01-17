function [Iapp,stim_on_times,stim_off_times] = make_Iapp_genr(params,stim_choice)
% generates the matrix Iapp with the input currents due to the stimulus for
% each cell. Rows of Iapp correspond to a particular unit while columns
% represent a particular timestep
% Inputs:
% 1. params: input parameter structure
% 2. stim_choice: 


if length(stim_choice) ~= params.num_char
    error("Length of stim_choice must equal p.num_char")
end

if any(cell2mat(stim_choice) > params.num_type)
    error("Values in stim_choice must not exceed p.num_type")
end

% Selects appropriate units for stimulus input:
% First I need to get stim_choice into usable indexing for type_units.
% I follow this: https://www.mathworks.com/matlabcentral/answers/362211-variable-indexing-for-n-dimension-data
% Using a structure and subsref() allows me to index into type_units
% without knowing the length of stim_choice.
S.type = '()';
% Each loop adds the selected type units for a characteristic:
for char = 1:params.num_char
    index_vec = {char, stim_choice{char}};
    S.subs = [index_vec repmat({':'},1,numel(size(params.type_units))-numel(index_vec))];

    stim_units(char,:) = squeeze(subsref(params.type_units,S)); % Here S is used to index 
    % type_units. Squeeze removes dimensions of 1 from the output matrix. 
end

    
% % generate random stimulus durations (usually constant)
% stim_durs = normrnd(params.mean_stim_dur,params.stim_dur_std,1,params.sequence_length);
% generate random stimulus amplitudes (usually constant)
stim_amps = normrnd(params.mean_stim_amp,params.stim_amp_std,1,params.num_char);


tvec = 1:params.simLength; % time vector (in ms)
Iapp = zeros(params.Ngroups,length(tvec)); % initialize matrix for input current

for char = 1:params.num_char
    units = stim_units(char,:); % Units to give stimulus to.
    
    Iapp(units, params.stim_start:params.stim_end) = stim_amps(char); % Assigns 
    % stimulus to correct units over time interval.
end

% for i=1:params.sequence_length % for each stimulus in the sequence
%     % calculate stimulus onset time
%     stim_s = sum(params.stim_int(1:i))/params.dt + sum(stim_durs(1:(i-1)))/params.dt+1;
%     stim_s = round(stim_s);
%     stim_on_times(i) = stim_s;
%     % calculate stimulus offset time
%     stim_e = stim_s+stim_durs(i)/params.dt; stim_e = round(stim_e);
%     stim_off_times(i) = stim_e;
%     % for all timesteps between stim_s and stim_e add the stimulus
%     % amplitude to the appropriate units' input currents for this stimulus
%     Iapp(params.inputs(seq(i),:),stim_s:stim_e) = stim_amps(i);
% end

end

