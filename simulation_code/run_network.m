function [r,D,s] = run_network(params,Iapp,init_type,memoptimize)
% Function to actually run the network for 1 sequence
% Inputs
% 1. params: parameter structure
% 2. Iapp: params.Ngrous x experiment length matrix with input currents for
%          each unit
% 3. init_type: Initialization method to start the network
% 4. memoptimize: 'yes' or 'no' whether or not to save D and s values at 
%                 each timestep
nTimesteps = size(Iapp,2);
erange = 1:params.Ne;
irange = (params.Ne+1):params.Ngroups;
switch init_type
    case 'silent' % all units start with 0 rate
        r = zeros(params.Ngroups,nTimesteps);
        D_ss = ones(params.Ngroups,1);
        s_ss = zeros(params.Ngroups,1);
    case 'random'
        r = zeros(params.Ngroups,nTimesteps);
        r(:,1) = rand(params.Ngroups,1)*params.r_e_max;
        r((r(:,1) < params.r_e_max/2),1) = 0;
        D_ss(erange) = 1./(1 + params.p0_e*r(erange,1)*params.tau_D);
        D_ss(irange) = 1./(1 + params.p0_i*r(irange,1)*params.tau_D);
        s_ss_e_top = params.alpha*params.p0_e*D_ss(erange)*r(erange,1)*params.tau_s_e;
        s_ss_e_bottom = 1 + params.alpha*params.p0_e*D_ss(erange)*r(erange,1)*params.tau_s_e;
        s_ss_i_top = params.alpha*params.p0_i*D_ss(irange)*r(irange,1)*params.tau_s_i;
        s_ss_i_bottom = 1 + params.alpha*params.p0_i*D_ss(irange)*r(irange,1)*params.tau_s_i;
        s_ss(erange) = s_ss_e_top/s_ss_e_bottom;
        s_ss(irange) = s_ss_i_top/s_ss_i_bottom;
        D_ss = D_ss';
        s_ss = s_ss';
    case 'constant' % an additional input current is used to "kick" the network into a starting state
        r = zeros(params.Ngroups,nTimesteps);
        D_ss(erange) = 1./(1 + params.p0_e*r(erange,1)*params.tau_D);
        D_ss(irange) = 1./(1 + params.p0_i*r(irange,1)*params.tau_D);
        D_ss = D_ss';
        s_ss_e_top = params.alpha*params.p0_e*D_ss(erange).*r(erange,1)*params.tau_s_e;
        s_ss_e_bottom = 1 + params.alpha*params.p0_e*D_ss(erange).*r(erange,1)*params.tau_s_e;
        s_ss_i_top = params.alpha*params.p0_i*D_ss(irange).*r(irange,1)*params.tau_s_i;
        s_ss_i_bottom = 1 + params.alpha*params.p0_i*D_ss(irange).*r(irange,1)*params.tau_s_i;
        s_ss(erange) = s_ss_e_top./s_ss_e_bottom;
        s_ss(irange) = s_ss_i_top./s_ss_i_bottom;
        s_ss = s_ss';
        Iapp(1:5:params.Ne,1:300) = 1.1; % currently setting every 5th unit to be on. Must change this line to change starting state
end

switch memoptimize
    case 'yes' % D and s are only vectors not matricies
        D = D_ss; %zeros(params.Ngroups,1);
        s = s_ss;
        eta = randn(params.Ngroups,nTimesteps); % matrix of noise input currents
        for t=1:nTimesteps
            dr = zeros(params.Ngroups,1);
            dD = zeros(params.Ngroups,1);
            ds = zeros(params.Ngroups,1);
            I = params.W'*s + Iapp(:,t) + params.sigma*eta(:,t)/sqrt(params.dt);
            dr(erange) = (params.dt/params.tau_r)*(-r(erange,t) + (params.r_e_max./(1+exp((params.theta_e(erange) - I(erange))/params.Delta_e))));
            dD(erange) = (params.dt/params.tau_D)*(1 - D(erange) - params.p0_e*r(erange,t)*params.tau_D.*D(erange));
            ds(erange) = (params.dt/params.tau_s_e)*(-s(erange) + params.alpha*params.p0_e*r(erange,t)*params.tau_s_e.*D(erange).*(1-s(erange)));
            dr(irange) = (params.dt/params.tau_r)*(-r(irange,t) + (params.r_i_max./(1+exp((params.theta_i - I(irange))/params.Delta_i))));
            dD(irange) = (params.dt/params.tau_D)*(1 - D(irange) - params.p0_i*r(irange,t)*params.tau_D.*D(irange));
            ds(irange) = (params.dt/params.tau_s_i)*(-s(irange) + params.alpha*params.p0_i*r(irange,t)*params.tau_s_i.*D(irange).*(1-s(irange)));

            r(:,t+1) = r(:,t) + dr;
            D = D + dD;
            s = s + ds;

            rover_e = r(erange,t+1) > params.r_e_max;
            rover_i = r(irange,t+1) > params.r_i_max;
            runder = r(:,t+1) < 0;
            r(rover_e,t+1) = params.r_e_max;
            r(rover_i,t+1) = params.r_i_max;
            r(runder,t+1) = 0;
        end
    case 'no' % D and s are matrices
        D = zeros(params.Ngroups,nTimesteps); D(:,1) = D_ss;
        s = zeros(params.Ngroups,nTimesteps); s(:,1) = s_ss;
        eta = randn(params.Ngroups,nTimesteps);
        erange = 1:params.Ne;
        irange = (params.Ne+1):params.Ngroups;
        for t=1:nTimesteps
            dr = zeros(params.Ngroups,1);
            dD = zeros(params.Ngroups,1);
            ds = zeros(params.Ngroups,1);
            I = params.W'*s(:,t) + Iapp(:,t) + params.sigma*eta(:,t)/sqrt(params.dt);
            dr(erange) = (params.dt/params.tau_r)*(-r(erange,t) + (params.r_e_max./(1+exp((params.theta_e(erange) - I(erange))/params.Delta_e))));
            dD(erange) = (params.dt/params.tau_D)*(1 - D(erange,t) - params.p0_e*r(erange,t)*params.tau_D.*D(erange,t));
            ds(erange) = (params.dt/params.tau_s_e)*(-s(erange,t) + params.alpha*params.p0_e*r(erange,t)*params.tau_s_e.*D(erange,t).*(1-s(erange,t)));
            dr(irange) = (params.dt/params.tau_r)*(-r(irange,t) + (params.r_i_max./(1+exp((params.theta_i - I(irange))/params.Delta_i))));
            dD(irange) = (params.dt/params.tau_D)*(1 - D(irange,t) - params.p0_i*r(irange,t)*params.tau_D.*D(irange,t));
            ds(irange) = (params.dt/params.tau_s_i)*(-s(irange,t) + params.alpha*params.p0_i*r(irange,t)*params.tau_s_i.*D(irange,t).*(1-s(irange,t)));

            r(:,t+1) = r(:,t) + dr;
            D(:,t+1) = D(:,t) + dD;
            s(:,t+1) = s(:,t) + ds;

            rover_e = r(erange,t+1) > params.r_e_max;
            rover_i = r(irange,t+1) > params.r_i_max;
            runder = r(:,t+1) < 0;
            r(rover_e,t+1) = params.r_e_max;
            r(rover_i,t+1) = params.r_i_max;
            r(runder,t+1) = 0;
        end
end

