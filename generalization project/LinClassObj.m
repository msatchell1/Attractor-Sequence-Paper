classdef LinClassObj
% Linear classification object class, for holding a linear classification
% model, fit parameters, and relevant data.
    properties

        % Unformatted data from simulations and parameter scans
        types
        r_avg

        X % Formatted avg firing rates so that each row is a data point X.

        X_types = []; % Formatted type combs where each row holds stimulus info 
        % used in that simulation. Row data in X correspond to the same row in
        % X_types.

        X_labels = []; % Binary labels for SVM indicating whether data cointains 
        % "correct" choice or not.

    end
end
