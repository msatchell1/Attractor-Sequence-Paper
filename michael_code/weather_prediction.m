function [] = weather_prediction()
%%%%% For performing the weather-prediction tutorial from Paul Miller's
%%%%% book, tutorial 8.3.

% In a different file, I have defined a class for holding firing units and
% for parameters. I initialize instances of these classes below.

fp = param;
units(fp.num_units,1) = funit;

% for i = 1:length(fp.num_units)
%     units(i) = funit;
% end


    function drdt = odefun(t,r)
        % Diff eq for unit firing rate
        drdt = (1/fp.tau)*(-r + fp.r_max/(1+exp((fp.I_th - funit.I)/fp.I_sigma)));
    end



end