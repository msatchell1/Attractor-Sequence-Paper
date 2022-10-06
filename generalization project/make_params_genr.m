function [p] = make_params_genr(varargin)
% Function to define all of the parameters needed to run a simulation
% Inputs:
% 1. varargin: You can provide pairs of strings and numeric values to
% define parameters externally (for instance when doing a parameter sweep).
% These inputs must follow the form (string,value,string,value). Therefore
% all odd indices of varargin should be parameter names and all even
% numbered indices should be parameter values. The parameter does not have
% to be defined already for me to pass it in - I can define new parameters
% externally!

p.stim_seed = 1; % stimulus RNG seed.
p.type_combs = []; 


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

p.stim_type = 10;
switch p.stim_type
        
    case 10 % Generalization project case
        p.mean_stim_dur        = .25; 
        p.stim_dur_variability = 0;
        p.mean_stim_amp        = 1;
        p.stim_amp_variability = 0;

        p.num_char             = 0; % Number of characteristics in an input. Ex: if shape and color, num_char = 2.
        p.stim_frac_char       = 0.33; % Fraction of total units to be assigned to a characteristic.
        % Note num_char*stim_frac_char cannot be greater than 1. 

        p.num_type             = 0; % Number of specific character subtypes for each char. Ex: If color has green 
        % and blue, num_type = 2.
        p.stim_frac_type       = 0.3; % Fraction of units within a characteristic to assign each type.
        % Note stim_frac_type can range from 0 to 1, as overlap is allowed
        % between type inputs.

        p.stim_start           = 3000; % Time to begin stimulus (ms)
        p.stim_end             = 3500; % Time to end stimulus (ms)
        p.simLength            = 10000; % Total simulation length (ms)
end


% Read in arbitrary number of desired parameter values. This has to come
% before doing any calculations that involve values passed in to
% make_params_genr().
for i=1:(length(varargin)/2)
    ind1 = 2*i - 1;
    p.(varargin{ind1}) = varargin{ind1+1};
end

if p.num_char*p.stim_frac_char > 1
    error("Fraction of units assigned to each characteristic too large for number of characteristics.")
end

% Creates a random number stream ONLY for the stimulus related numbers.
stim_s = RandStream('mt19937ar', 'Seed',p.stim_seed);

% Assign p.stim_frac_char units to each characteristic.
shuffled_IDs = randperm(stim_s,p.Ne); % Creates and shuffles a list of unit IDs.
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
        shuffled_char_IDs = char_IDs(randperm(stim_s,length(char_IDs))); % Shuffles them.
        num_elems = round(p.stim_frac_type*length(shuffled_char_IDs)); % Number of units to select from shuffled char units.
        p.type_units(char,type,:) = shuffled_char_IDs(1:num_elems); % Assigns fraction of them to type input
    end
end



% % set dependent variables after update
p.theta_e = (p.max_theta_e-p.min_theta_e)*rand(p.Ne,1)+p.min_theta_e; % draw thresholds from uniform distribution
% p.stim_int = round((max_int - min_int)*rand(1,p.sequence_length+1) + min_int, 3); %normally 1.5
p.stim_amp_std = p.stim_amp_variability*p.mean_stim_amp;
p.stim_dur_std = p.stim_dur_variability*p.mean_stim_dur;

% make the weight matrix
[p] = makeWeightMatrix(p);
end

