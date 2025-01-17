function [LCOs] = Train_LinClass(tp)
% Function to create a linear classification object and train it on
% provided data. 
%
% INPUTS: 
% num_mdls - number of SVM models to create.
% clsf_index_arrays - classifications for labelling for each model.
%
% OUTPUTS:
% LCOs - object array of LinClassObj objects.


LCOs(1,tp.num_mdls) = LinClassObj; % Creates num_mdls objects are stores them in 
% object array LCOs.

for i = 1:length(LCOs) % Assigns properties to LCOs

    LCOs(i).stim_seed = tp.stim_seeds(i);
    % clsf_index is the correct choice for the experiment, i.e. the characteristic-type
    % combination that will be seperated out in linear classification. 
    % Format: [ char , type ]
    % Note clsf_index(1) cannot be greater than p.num_char, and clsf_index(2) not greater than
    % p.num_type.
    LCOs(i).clsf_index = tp.clsf_index_array(i,:);
end


for i = 1:length(LCOs) % Loops over all hyperplane models to be calculated.
    
    LCOs(i) = param_sweep_genr(LCOs(i),tp);



    % Extract all individual data points that will sit in firing rate space by reshaping
    % the existing matrix. Do the exact same operation on the labels to retain 
    % information on which data used which types. The reshaping seems to be
    % done by running through each parameter set, taking the first simulation
    % data and appending that to the new array such that the new matrix is
    % ordered like:
    % [ [params1 typecomb1 data] , [params2 typecomb1 data] , [params1
    % typecomb2 data] , ... ]
    X = reshape(LCOs(i).r_avg, [(size(LCOs(i).r_avg,1)*size(LCOs(i).r_avg,2)), size(LCOs(i).r_avg,3)]);
    X_types = reshape(LCOs(i).types, [(size(LCOs(i).types,1)*size(LCOs(i).types,2)), size(LCOs(i).types,3)]);

    % Assigns this data to the linear classification parameters structure:
    LCOs(i).X = X;
    LCOs(i).X_types = X_types;

    % For LC and SVM purposes, we need to turn the information in X_types into
    % binary classification data, i.e. 1s and 0s, so that the SVM can seperate
    % the data into two classes. To do this, we simply need to select a
    % given characteristic-type combination that would indicate the "correct" experimental
    % choice, and label those data points 1. All other points are labeled 0.
    X_labels = zeros(size(X_types, 1), 1);

    for char = 1:size(X_types, 2)
       if char == LCOs(i).clsf_index(1)
           % Finds the index locations in the column of X_types that have
           % correct type labels.
          indices = find(X_types(:,char) == LCOs(i).clsf_index(2));

          X_labels(indices) = 1; % Assigns labels to these "correct" data points.

       end
    end

    LCOs(i).X_labels = X_labels; 


    % Using fitclinear to do the SVM analysis. Returns the created model
    % (hyperplane) and fitting information. The data needs to be an n x p
    % matrix, where each n is a data point and p is the dimensionality of the
    % data.
    [LCOs(i).Mdl, LCOs(i).FitInfo] = fitclinear(LCOs(i).X, LCOs(i).X_labels);
    
    
    % I need to calculate the correlation coefficient for each firing rate
    % data (X) and stim_units pair. First get the sitm units data in the
    % same format as X:
    LCOs(i).stim_units_reshaped = reshape(LCOs(i).stim_units,...
        [(size(LCOs(i).r_avg,1)*size(LCOs(i).r_avg,2)), size(LCOs(i).r_avg,3)]);
    
    corr_coeffs = zeros(size(X,1),1);
    % Loop through each simulation and find the correlation coefficient
    for k = 1:length(corr_coeffs)
        % Calculates matrix of coefficients
        corr_mat = corrcoef(LCOs(i).stim_units_reshaped(k,:), X(k,:));
        corr_coeffs(k) =  corr_mat(1,2); % grabs off-diagonal element.
    end
    
    LCOs(i).corr_coeffs = corr_coeffs;
    
end




end