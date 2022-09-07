function [param_str] = get_param_string(param)
% Written by Benjamin Ballintyn (2018) email: bbal@brandeis.edu
% Simple helper function that takes in the string representation of a
% parameter (the one used by make_params()) and returns the LATEX version
% of that parameter name to be used in a plot
switch param
    case 'W_e0'
        param_str = 'W_{EE}^{self}';
    case 'W_ee_max'
        param_str = 'W_{EE}^{max}';
    case 'W_ei'
        param_str = 'W_{EI}';
    case 'W_ie'
        param_str = 'W_{IE}';
end

