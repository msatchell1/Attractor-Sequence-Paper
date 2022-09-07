function [ tcs ] = calc_tuning_curves( data_dir, base_dir )
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% This function calculates the "tuning curves" for a particular sequence.
% NOTE: This function must be called before deleting the rates.mat files
% via del_r_files!
%
% Inputs: 
% 1. data_dir: path to directory with data for a specific sequence (e.g. W_e0_and_W_ee_max/1/1/target_trials/seq1)
% 2. base_dir: path to highest level data directory for a particular network ( e.g. W_e0_and_W_ee_max/1/1)
% Outputs:
% 1. tcs: a (nunits x sequence_length) matrix where each column j gives the
%         trial-averaged activity of each unit after the j'th stimulus in
%         the sequence
params = load([base_dir '/params.mat']); params = params.p; % load parameter set used for this simulation

rates = load([data_dir '/rates.mat']); rates=rates.rates;
son = load([data_dir '/stim_on_times.mat']); son=son.stim_on_times;
soff = load([data_dir '/stim_off_times.mat']); soff=soff.stim_off_times;
for trial=1:params.Ntrials % for each trial
    for stim=1:params.sequence_length % for each stimulus
	% calculate the mean firing rate in the .25-1.25 seconds following the offset of the prior stimulus (measures the network "steady" state after a stimulus and before the next stimulus
        record_on = round((soff{trial}(stim)+.250/params.dt)); % start averaging 125ms after stimulus offset 
        record_off = round((soff{trial}(stim)+1.25/params.dt)); % end average 1250ms after stimulus offset
        means = mean(rates{trial}(:,record_on:record_off),2); % get mean response for each cell group
        mean_rs(:,stim,trial) = means;
    end
end

tcs = mean(mean_rs,3); % calculate mean response across trials
end

