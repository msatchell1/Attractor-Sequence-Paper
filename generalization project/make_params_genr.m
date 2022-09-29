function [p] = make_params_genr(varargin)
% Function to define all of the parameters needed to run a simulation
% Inputs:
% 1. varargin: You can provide pairs of strings and numeric values to
% define parameters externally (for instance when doing a parameter sweep).
% These inputs must follow the form (string,value,string,value). Therefore
% all odd indices of varargin should be parameter names and all even
% numbered indices should be parameter values

% Seed for random events
p.rng_seed = 1;
rng(p.rng_seed,'twister');

% % Experiment Info
% p.Ntrials = 10;
p.dt = 1e-3;

% Population info
p.Ne = 100; % (100 cell groups) # of excitatory cell groups
p.Ni = 1;   % (1 cell group) # of inhibitory cell groups
p.Ngroups = p.Ne+p.Ni;

% Time Constants
p.tau_r = .01; % (10ms) firing rate time constant
p.tau_D = .5;  % (500ms) depression time constant
p.tau_s_e = .05; % (50ms) EE/EI synaptic time constant for decay of si to zero
p.tau_s_i = .005; % (5ms) IE synaptic time constant for decay of si to zero

% Max Firing Rates
p.r_e_max = 100; % (100Hz) maximum firing rate for excitatory neurons
p.r_i_max = 200; % (200Hz) maximum firing rate for inhibitory neurons

% Current thresholds (for half-maximum firing based on f-I curve)
p.min_theta_e = 6; % (6.3) minimum of range of excitatory cell thresholds
p.max_theta_e = 6; % (6.5) maximum of range of excitatory cell thresholds
%p.min_theta_i = 12;
%p.max_theta_i = 12;
p.theta_i = ones(p.Ni,1)*10; % hardcoded singular theta_i for now

% f-I curve slope parameter Delta
p.Delta_e = 1; % determines slope of excitatory f-I curve
p.Delta_i = 3; % determines slope of inhibitory f-I curve

% Noise parameters
p.sigma = [.002]; % (2 noise levels) sigma is the std of white noise

% Synaptic release parameters
p.p0_e = 1;  % fraction of docked vesicles released per spike for EE/EI connections
p.p0_i = .1; % fraction of docked vesicles released per spike for IE connections
p.alpha = 1; % fraction of open receptors bound by maximal vesicle release

% Connection parameters
p.W_e0     = 89;   % connection strength for excitatory SELF connections (ben's value = 89)
p.W_ee_min = 0;    % minimum connection strength for EE connections
p.W_ee_max = .342; % maximum connection strength for EE connections (ben's value = .342)
p.W_ei     = .665;  % connection strength for EI connections (ben's value = .665)
p.W_ie     = -540; % connection strength for IE connections (ben's value = -540)

p.stim_type = 10; % use 9 for pretty much everything
switch p.stim_type
    case 1 % (not used for paper)
        p.sequence_length   = 10;  % # of stimuli (ranged from 1-10 stimuli in paper)
        p.stim_dur = .100;  % (100ms) Duration of stimuli (ranged from .01-1s in paper)
        p.stim_amp = 2;   % Stimulus amplitude (ranged from .5-3 in paper)
        p.stim_int = 1.5; % (1.5s) inter_stimulus interval
    case 2 % alternating (not used for paper)
        p.sequence_length = 10;
        p.stim_dur        = .100;
        p.stim_amp        = 1;
        p.stim_int        = 1.5;
        p.stim_frac       = .2;
        p.n_dif_stims     = 2;
    case 3 % half-half (not used for paper)
        p.sequence_length = 10;
        p.stim_dur        = .100;
        p.stim_amp        = 1;
        p.stim_int        = 1.5;
        p.stim_frac       = .2;
        p.n_dif_stims     = 2;
    case 4 % half-half reverse (not used for paper)
        p.sequence_length = 10;
        p.stim_dur        = .100;
        p.stim_amp        = 1;
        p.stim_int        = 1.5;
        p.stim_frac       = .2;
        p.n_dif_stims     = 2;
    case 5 % all permutations (not used for paper)
        p.sequence_length = 6;
        p.stim_dur        = .25;
        p.stim_amp        = 1.07; % (2) (ben's value = 1.07)
        max_int           = 1.5;
        min_int           = 1.5;
        p.stim_int        = round((max_int - min_int)*rand(1,p.sequence_length+1) + min_int, 3); %normally 1.5
        p.stim_frac       = .59; % (.2) (ben's value = .59)
        p.n_dif_stims     = 2;
    case 6 % Nearest-neighbor 7-word sequences 
        p.sequence_length = 7; % # of stimuli per sequence
        p.stim_dur        = .25; % # duration of stimuli in seconds
        p.stim_amp        = 1.07;% # dimensionless amplitude of input
        max_int = 1.5; % maximum interval between stimuli in seconds
        min_int = 1.5;% minimum interval between stimuli in seconds
        p.stim_int        = round((max_int - min_int)*rand(1,p.sequence_length+1) + min_int, 3);
        p.stim_frac       = .59; % fraction of excitatory cell groups receiving input from each stimulus type
        p.n_dif_stims     = 7; % # of different stimulus types present across sequences
    case 7 % latin squares word sequence generation
        p.sequence_length = 7;
        p.stim_dur        = .25;
        p.stim_amp        = 1.07;
        max_int           = 1.5;
        min_int           = 1.5;
        p.stim_int        = round((max_int - min_int)*rand(1,p.sequence_length+1) + min_int,3);
        p.stim_frac       = .59;
        p.n_dif_stims     = 7;
        p.nseqs           = 70; % here we are generating 70 unique sequences using the latin squares method to ensure that each stimulus is present in each sequence position the same number of times across the whole sequence set
    case 8 % 10-word (for producing final recall figures)
        % We generate 100 unique sequences from 1000 unique stimulus types and for each sequence, we measure what individual response (response of the network to one of the 1000 individual stimuli) most closely matches the final network state
        p.sequence_length = 10;
        p.stim_dur        = .25;
        p.stim_amp        = 1.07;
        max_int = 1.5;
        min_int = 1.5;
        p.stim_int        = round((max_int-min_int)*rand(1,p.sequence_length+1)+min_int,3);
        p.stim_frac       = .59;
        p.n_dif_stims     = 1000;
        p.nseqs           = 100;
    case 9 % variable duration/amplitude
        p.sequence_length      = 6; % length of the desired sequences
        p.mean_stim_dur        = .25; % mean stimulus durations (s)
        p.stim_dur_variability = 0; % Fraction of mean stim dur to set duration STD
        p.mean_stim_amp        = 1.07; % mean of stimulus amplitudes
        p.stim_amp_variability = 0; % Fraction of mean stim amplitude to set amplitude STD
        max_int = 1.5; % maximum stimulus interval
        min_int = 1.5; % minimum stimulus interval
        p.stim_frac            = .59; % Fraction of excitatory units receiving each stimulus
        p.n_dif_stims          = 2; % Number of different stimulus types
        
    case 10 % Generalization project case
        p.mean_stim_dur        = .25; 
        p.stim_dur_variability = 0;
        p.mean_stim_amp        = 1;
        p.stim_amp_variability = 0;
        p.num_char             = 2; % Number of characteristics in an input. Ex: if shape and color, num_char = 2.
        p.stim_frac_char       = 0.5; % Fraction of total units to be assigned to a characteristic.
        % Note num_char*stim_frac_char cannot be greater than 1. 
        p.num_type             = 2; % Number of specific character subtypes for each char. Ex: If color has green 
        % and blue, num_type = 2.
        p.stim_frac_type       = .3; % Fraction of units within a characteristic to assign each type.
        % Note stim_frac_type can range from 0 to 1, as overlap is allowed
        % between type inputs.
        p.stim_start           = 3000; % Time to begin stimulus (ms)
        p.stim_end             = 3500; % Time to end stimulus (ms)
        p.simLength            = 10000; % Total simulation length (ms)
end

if p.num_char*p.stim_frac_char > 1
    error("Fraction of units assigned to each characteristic too large for number of characteristics.")
end

% Assign p.stim_frac_char units to each characteristic.
shuffled_IDs = randperm(p.Ne); % Creates and shuffles a list of unit IDs.
for char = 1:p.num_char
    p.char_units(char,:) = shuffled_IDs(1:(p.stim_frac_char*p.Ne)); % Selects units for a characteristic
    shuffled_IDs = shuffled_IDs((p.stim_frac_char*p.Ne)+1:end); % Removes these units from list to ensure
    % orthogonal characteristic unit groups.
end

% Assign p.stim_frac_type units within each char group to a specific
% stimulus.
for char = 1:p.num_char
    
    char_IDs = p.char_units(char,:); % Grabs units from one char.
    
    for type = 1:p.num_type
        shuffled_char_IDs = char_IDs(randperm(length(char_IDs))); % Shuffles them.
        num_elems = round(p.stim_frac_type*length(shuffled_char_IDs)); % Number of units to select from shuffled char units.
        p.type_units(char,type,:) = shuffled_char_IDs(1:num_elems); % Assigns fraction of them to type input
    end
end




% Read in arbitrary number of desired parameter values
for i=1:(length(varargin)/2)
    ind1 = 2*i - 1;
    p.(varargin{ind1}) = varargin{ind1+1};
end

% % set dependent variables after update
p.theta_e = (p.max_theta_e-p.min_theta_e)*rand(p.Ne,1)+p.min_theta_e; % draw thresholds from uniform distribution
% p.stim_int = round((max_int - min_int)*rand(1,p.sequence_length+1) + min_int, 3); %normally 1.5
p.stim_amp_std = p.stim_amp_variability*p.mean_stim_amp;
p.stim_dur_std = p.stim_dur_variability*p.mean_stim_dur;

% make the weight matrix
[p] = makeWeightMatrix(p);
end
