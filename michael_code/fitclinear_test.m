% Testing the matlab linear classification function fitclinear().

%% I want to create a 2D example of a support vector machine classifying data.

% Lets start with 3 data points, each of only 2 dimensions. For fitclinear, 
% data is expected to be input as an n-by-p matrix. I.e, the number of rows 
% corresponds to the number of data points, and the number of columns to the 
% dimensionality of the data. Thus for this example I want a 3 x 2 matrix.

x_data = zeros(3,2);

% Now fill it with some data
x_data(1,:) = [2,2];
x_data(2,:) = [4,4];
x_data(3,:) = [6,6];

% 