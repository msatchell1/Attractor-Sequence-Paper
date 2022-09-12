% Testing the matlab linear classification function fitclinear().

%% I want to create a 2D example of a support vector machine classifying data.

% Lets start with 3 data points, each of only 2 dimensions. For fitclinear, 
% data is expected to be input as an n-by-p matrix. I.e, the number of rows 
% corresponds to the number of data points, and the number of columns to the 
% dimensionality of the data. Thus for this example I want a 3 x 2 matrix.

x_data = zeros(3,2);

% Now fill it with some data
x_data(1,:) = [5,3];
x_data(2,:) = [1,1];
x_data(3,:) = [7,8];

% Lets plot this data
figure(1);
sc1 = scatter(x_data(:,1), x_data(:,2));
xlim([0,10]);
ylim([0,10]);
title('SVM Linear Classification');
ylabel('x2')
xlabel('x1')


%% Lets first try to do supervised learning, where the SVM is fed both the
% data and their classifications.

x_class = zeros(3,1);
% I am giving the data a binary classification of either 1 or 0. 
x_class(1) = 0; x_class(2) = 1; x_class(3) = 1;

% Lets add the data classifications to the plot.
figure(1);
hold on;
labelpoints(x_data(:,1), x_data(:,2), x_class)
hold off;
% Now for the SVM.
[Mdl,FitInfo] = fitclinear(x_data,x_class);

% This returns a model object that has information about the linear
% classification that the fit came up with. 

% It seems that the parameter beta of the model object are coefficients for
% the normal vector to the hyperplane that separates the data.
beta = Mdl.Beta;
bias = Mdl.Bias;

% x1*beta1 + x2*beta2 - bias = 0 ?
% --> x2 = ( bias - x1*beta1 )/beta2
x1 = 1:0.1:10;
x2 =  -(bias+x1.*beta(1))/beta(2);

figure(1);
hold on;
plot(x1,x2)
hold off;

% It works! The data is separated based on classification. 

%% Now say I want to use this model to classify new data.
% I can feed the function predict() both my model and the new data and it
% will spit out the classifications (called labels).
x_new = zeros(3,2);
x_new(1,:) = [3,6];
x_new(2,:) = [2,2];
x_new(3,:) = [5,1];

[labels, score] = predict(Mdl,x_new);

figure(1);
hold on;
scatter(x_new(:,1),x_new(:,2));
labelpoints(x_new(:,1),x_new(:,2),labels)
hold off;


%% Lets try and do this for both a larger training dataset and larger prediction dataset.
% Lets call our new data matrix y. Lets make y a random group of data
% points and attempt to cluster them automatically before running the SVM.

a_rand = 0;
b_rand = 10;
y = (b_rand-a_rand).*rand(10,2) + a_rand;

% Runs k-means clustering analysis on the random data, separating it into k
% clusters. The indices of the data from clustering are stored in the
% output 'idx'.
idx = kmeans(y,2);

figure(2);
hold on;
sy1 = scatter(y(:,1),y(:,2),'b','DisplayName','Training Data');
labelpoints(y(:,1),y(:,2), idx)
title('clustering and then classification')
ylabel('y2')
xlabel('y1')
xlim([0,10]);
ylim([0,10]);


% Now train a new model on this labeled data.
[Mdl_y,FitInfo_y] = fitclinear(y,idx);

% Lets try using the other convential variable names for the model
% parameters.

w = Mdl_y.Beta;
b = Mdl_y.Bias;

y1 = 1:10;
y2 = -(b+y1.*w(1))/w(2);

py1 = plot(y1,y2, 'DisplayName','Hyperplane');



%  Now create new points and assign them labels based on model.
y_new = (b_rand-a_rand).*rand(10,2) + a_rand;

labels_y = predict(Mdl_y,y_new);
sy2 = scatter(y_new(:,1),y_new(:,2),'g', 'DisplayName','Testing Data');
labelpoints(y_new(:,1),y_new(:,2), labels_y)

legend()
hold off;




