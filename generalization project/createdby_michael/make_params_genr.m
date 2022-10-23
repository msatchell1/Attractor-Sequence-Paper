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

p.stim_seed = ''; % stimulus RNG seed.
p.net_seed = ''; % network connectivity seed used in makeWeightMatrix().
p.type_combs = []; 


% % Experiment Info
% p.Ntrials = 10;
p.dt = 1e-3;

% Population info
p.Ne = 100; % (100 cell groups) # of excitatory cell groups
p.Ni = 1;   % (1 cell group) # of inhibitory cell groups


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
p.sigma = [0.012]; % (2 noise levels) sigma is the std of white noise
% Bens value was 0.002. Around 0.03 is the threshold for noise to start
% changing units attractor states (i.e. switching them from firing to
% non-firing and vice versa).

% Synaptic release parameters
p.p0_e = 1;  % fraction of docked vesicles released per spike for EE/EI connections
p.p0_i = .1; % fraction of docked vesicles released per spike for IE connections
p.alpha = 1; % fraction of open receptors bound by maximal vesicle release

% Connection parameters
p.W_e0     = 87;   % connection strength for excitatory SELF connections (ben's value = 89)
p.W_ee_min = 0;    % minimum connection strength for EE connections (ben's value = 0)
p.W_ee_max = 1.05; % maximum connection strength for EE connections (ben's value = .342)
p.W_ei     = 1.45;  % connection strength for EI connections (ben's value = .665)
p.W_ie     = -540; % connection strength for IE connections (ben's value = -540)
%
% Notes on which connection parameter values induce changes in network
% activity state after stimulus:
%
% W_ie just generally raises or lowers the amount of inhibiton the network
% receives. It is important in determining the avg firing rate of "on" units. 
%
% W_ei in some way increases the instability of the "on" state, or at least
% of a select few units that drop the lowest in frequency after stimulus
% ends.
%
% Raising w_ee_max slowly raises avg firing rate of on units. It also
% minimizes the amplitude of transient oscillations in firing after stimulus end. 
% High enough values begin to recruit units from the off state into the on
% state during these oscillations.
%
% W_e0 seems to potently control the amplitude of oscillations after
% sitmulus end and the resulting steady state firing rate.
%
% Continuous recruitment of units into on state: 
% W_e0 = 89, W_ee_max = 0.8, W_ei = 0.9, W_ie = -520
%
% To get slow dropping out of units from the firing state:
% W_e0 = 87, W_ei - W_ee_max = 0.4, W_ie = -540
%
% A nice balance of units dropping in and out after stimulus end, but not
% much long-term change:
% W_e0 = 87, W_ee_max = 1.05, W_ei = 1.45, W_ie = -540
% I will refer to these parameters as the base parameters, including
% stimulus amplitude = 1, noise sigma = 0, and stimulus duration = 250.



p.stim_case = 10;
switch p.stim_case
        
    case 10 % Generalization project case
        p.mean_stim_amp        = 0.8;
        p.stim_amp_variability = 0;

        p.num_char             = 0; % Number of characteristics in an input. Ex: if shape and color, num_char = 2.
        p.stim_frac_char       = 0.5; % Fraction of total units to be assigned to a characteristic.
        % Note num_char*stim_frac_char cannot be greater than 1. 

        p.num_type             = 0; % Number of specific character subtypes for each char. Ex: If color has green 
        % and blue, num_type = 2.
        p.stim_frac_type       = 0.5; % Fraction of units within a characteristic to assign each type.
        % Note stim_frac_type can range from 0 to 1, as overlap is allowed
        % between type inputs.
        
        p.stim_dur             = 250; % Duration of stimulus (ms)
        p.stim_start           = 1000; % Time to begin stimulus (ms)
        p.simLength            = 8000; % Total simulation length (ms)
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


% % set dependent variables after update
p.Ngroups = p.Ne+p.Ni;
p.stim_end = p.stim_start+p.stim_dur; % Time to end stimulus (ms)
p.theta_e = (p.max_theta_e-p.min_theta_e)*rand(p.Ne,1)+p.min_theta_e; % draw thresholds from uniform distribution
% p.stim_int = round((max_int - min_int)*rand(1,p.sequence_length+1) + min_int, 3); %normally 1.5
p.stim_amp_std = p.stim_amp_variability*p.mean_stim_amp;


% Creates a random number stream ONLY for the stimulus related numbers.
% WARNING, RandStream rounds integers down, so if I want to calculate
% random seeds I can't pass them as floats between 0 and 1, instead I need
% to scale them up to be between, for example, 0 and 1000.
stim_s = RandStream('mt19937ar', 'Seed',p.stim_seed);

net_s = RandStream('mt19937ar', 'Seed',p.net_seed); % Uses network weight matrix seed 
% to also keep the characterstic groups consistent.

% Assign p.stim_frac_char units to each characteristic.
shuffled_IDs = randperm(net_s,p.Ne); % Creates and shuffles a list of unit IDs.
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





% make the weight matrix
[p] = makeWeightMatrix(p);
end

