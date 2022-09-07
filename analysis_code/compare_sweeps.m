function [] = compare_sweeps(sweep1,sweep2,Sweep1Label,Sweep2Label,useinterp,saveFigs,saveStr)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% This function is a tool for comparing the performance of networks across
% 2 different parameter sweeps. The function determines whether the
% parameter sweeps specified by sweep1 and sweep2 are 1D or 2D parameter
% sweeps and calls the functions compare_sweeps2D or compare_sweeps1D
% depending on the result
%
% Inputs:
% 1. sweep1: path to the top level directory of the 1st parameter sweep
% 2. sweep2: path to the top level directory of the 2nd parameter sweep
% 3. Sweep1Label: string used to label the axes in the generated plots
%                 associated with sweep1
% 4. Sweep2Label: string used to label the axes in the generated plots
%                 associated with sweep2
% 5. useinterp: "yes" or "no" option to interpolate values across the space of sampled
%               parameters. NOTE: Only use "yes" if the sweeps being
%               analyzed were 2D sweeps
% 6. saveFigs: "yes" or "no" option to save the generated figures
% 7. saveStr: string specifying the path and filename at which to save the
%             figures
rl1 = load([sweep1 '/run_log.mat']); rl1 = rl1.run_log;
rl2 = load([sweep2 '/run_log.mat']); rl2 = rl2.run_log;
if (isfield(rl1,'param1') && isfield(rl1,'param2') && isfield(rl2,'param1') && isfield(rl2,'param2'))
    compare_sweeps2D(sweep1,sweep2,Sweep1Label,Sweep2Label,useinterp,saveFigs,saveStr)
elseif (isfield(rl1,'param') && isfield(rl2,'param'))
    compare_sweeps1D(sweep1,sweep2,Sweep1Label,Sweep2Label,useinterp,saveFigs,saveStr)
else
    error('Sweeps do not have the same number of variables')
end
end

