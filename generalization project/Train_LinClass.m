% function [] = Train_LinClass(all_r_avg)
% Function to create a linear classification object and train it on
% provided data. 
%
% Inputs: all_r_avg
% all_r_avg - matrix containing the avg firing rate for all possible
% combinations of num_type over a parameter range. Should have size:
% (length param range) x (num type combinations) x (num E units)


% Extract all individual data points that will sit in firing rate space by reshaping
% the existing matrix. DO the exact same operation on the labels to retain 
% information on which data used which types.
X = reshape(LCp.r_avg, [(size(LCp.r_avg,1)*size(LCp.r_avg,2)), size(LCp.r_avg,3)]);
X_labels = reshape(LCp.types, [(size(LCp.types,1)*size(LCp.types,2)), size(LCp.types,3)]);

LCp.X = X;
LCp.X_labels = X_labels;

% X = zeros((size(all_r_avg,1)*size(all_r_avg,2)), size(
% 
% for i = 1:size(all_r_avg,1)
%     for j = 1:size(all_r_avg,2)
%         
%         x_val = squeeze(all_r_avg(i,j,:));
%         
%     end
% end


% end