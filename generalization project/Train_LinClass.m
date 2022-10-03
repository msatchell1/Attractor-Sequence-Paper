% function [] = Train_LinClass(all_r_avg)
% Function to create a linear classification object and train it on
% provided data. 
%
% Inputs: all_r_avg
% all_r_avg - matrix containing the avg firing rate for all possible
% combinations of num_type over a parameter range. Should have size:
% (length param range) x (num type combinations) x (num E units)


% Extract all individual data points that will sit in firing rate space by reshaping
% the existing matrix. Do the exact same operation on the labels to retain 
% information on which data used which types. The reshaping seems to be
% done by running through each parameter set, taking the first simulation
% data and appending that to the new array such that the new matrix is
% ordered like:
% [ [params1 typecomb1 data] , [params2 typecomb1 data] , [params1
% typecomb2 data] , ... ]
X = reshape(LCp.r_avg, [(size(LCp.r_avg,1)*size(LCp.r_avg,2)), size(LCp.r_avg,3)]);
X_types = reshape(LCp.types, [(size(LCp.types,1)*size(LCp.types,2)), size(LCp.types,3)]);

% Assigns this data to the linear classification parameters structure:
LCp.X = X;
LCp.X_types = X_types;

% For LC and SVM purposes, we need to turn the information in X_types into
% binary classification data, i.e. 1s and 0s, so that the SVM can seperate
% the data into two classes. To do this, we simply need to select a
% given characteristic-type combination that would indicate the "correct" experimental
% choice, and label those data points 1. All other points are labeled 0.
X_labels = zeros(size(X_types, 1), 1);

% cc is the correct choice for the experiment, i.e. the characteristic-tyoe
% combination that will be seperated out in linear classification. 
% Format: [ char , type ]
% Note cc(1) cannot be greater than p.num_char, and cc(2) not greater than
% p.num_type.
cc = [1,3];

for char = 1:size(X_types, 2)
   if char == cc(1)
       % Finds the index locations in the column of X_types that have
       % correct type labels.
      indices = find(X_types(:,char) == cc(2));
      
      X_labels(indices) = 1; % Assigns labels to these "correct" data points.
      
   end
end

LCp.X_labels = X_labels; 


% Using fitclinear to do the SVM analysis. Returns the created model
% (hyperplane) and fitting information. The data needs to be an n x p
% matrix, where each n is a data point and p is the dimensionality of the
% data.
[Mdl, FitInfo] = fitclinear(LCp.X, LCp.X_labels);



% end