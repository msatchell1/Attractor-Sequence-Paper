function [Iapp,stim_on_times,stim_off_times] = make_Iapp(params,seq)
% generates the matrix Iapp with the input currents due to the stimulus for
% each cell. Rows of Iapp correspond to a particular unit while columns
% represent a particular timestep
% Inputs:
% 1. params: input parameter structure
% 2. seq: vector of numbers representing the sequence of stimuli. the
% length of seq should match params.sequence_length and each element of seq
% should be the corresponding stimulus ID number
if (size(params.inputs,1) > params.n_dif_stims)
    error('To many different inputs')
end
% generate random stimulus durations (usually constant)
stim_durs = normrnd(params.mean_stim_dur,params.stim_dur_std,1,params.sequence_length);
% generate random stimulus amplitudes (usually constant)
stim_amps = normrnd(params.mean_stim_amp,params.stim_amp_std,1,params.sequence_length);
% calculate experiment duration (in timesteps)
exp_dur = sum(params.stim_int/params.dt) + sum(stim_durs/params.dt);
tvec = 1:exp_dur; % time vector
Iapp = zeros(params.Ngroups,length(tvec)); % initialize matrix for input current
for i=1:params.sequence_length % for each stimulus in the sequence
    % calculate stimulus onset time
    stim_s = sum(params.stim_int(1:i))/params.dt + sum(stim_durs(1:(i-1)))/params.dt+1;
    stim_s = round(stim_s);
    stim_on_times(i) = stim_s;
    % calculate stimulus offset time
    stim_e = stim_s+stim_durs(i)/params.dt; stim_e = round(stim_e);
    stim_off_times(i) = stim_e;
    % for all timesteps between stim_s and stim_e add the stimulus
    % amplitude to the appropriate units' input currents for this stimulus
    Iapp(params.inputs(seq(i),:),stim_s:stim_e) = stim_amps(i);
end
end

