% Testing the matlab linear classification function fitclinear().
% Michael Satchell 09-13-22

%% I want to create a 2D example of a support vector machine classifying data.

% Lets start with 3 data points, each of only 2 dimensions. For fitclinear, 
% data is expected to be input as an n-by-p matrix. I.e, the number of rows 
% corresponds to the number of data points, and the number of columns to the 
% dimensionality of the data. Thus for this example I want a 3 x 2 matrix.

x_data = zeros(3,2);

% Now fill it with some data
x_data(1,:) = [5,3];
x_data(2,:) = [1,7];
x_data(3,:) = [4,5];

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



%% Drawing from distributions
% Now I am going to draw two samples from two distributions and train the
% network on those using supervised learning. Then I am going to get new
% data from one or both of the distributions and test how well my model is
% able to correctly classify the new data as belonging to one distribution
% or the other.


% I play around with normal distributions here

pd1 = makedist('normal','mu',-2,'sigma',2);
pd2 = makedist('normal','mu',2,'sigma',2);

pd_data1 = random(pd1,10,2);
pd_data2 = random(pd2,10,2);

all_data = [pd_data1 ; pd_data2];

x = -10:0.01:10;
pdf1 = pdf(pd1,x);
pdf2 = pdf(pd2,x);

figure(3);
hold on;
plot(x,pdf1,'b')
plot(x,pdf2,'r')
title('proability distributions used for sampling data')
legend('dist1','dist2')
% histogram(pd_data1,'Normalization','pdf','FaceColor','b')
% histogram(pd_data2,'Normalization','pdf','FaceColor','r')
hold off;


% Here we feed the labeled dist data to the SVM.

data1_labels = zeros(size(pd_data1,1),1) + 1;
data2_labels = zeros(size(pd_data2,1),1) + 2;

all_labels = [data1_labels ; data2_labels];

pd_mdl = fitclinear(all_data, all_labels);

w = pd_mdl.Beta;
b = pd_mdl.Bias;

y1 = -10:10;
y2 = -(b+y1.*w(1))/w(2);

figure(4);
hold on;
scatter(pd_data1(:,1),pd_data1(:,2),'b','DisplayName','Dist1');
scatter(pd_data2(:,1),pd_data2(:,2),'r','DisplayName','Dist2');
labelpoints(all_data(:,1),all_data(:,2),all_labels)
plot(y1,y2, 'DisplayName','Hyperplane');
title('training data')
legend('Dist1','Dist2')
hold off;


% Now we want to get new data samples and use the model to predict which
% distribution they are from.

pd_nd1 = random(pd1,10,2); pd_nd2 = random(pd2,10,2);

[predict_1,scores_1] = predict(pd_mdl,pd_nd1);
[predict_2,scores_2] = predict(pd_mdl,pd_nd2);

figure(5);
hold on;
scatter(pd_nd1(:,1),pd_nd1(:,2),'b','DisplayName','Dist1')
scatter(pd_nd2(:,1),pd_nd2(:,2),'r','DisplayName','Dist2')
labelpoints(pd_nd1(:,1),pd_nd1(:,2),predict_1)
labelpoints(pd_nd2(:,1),pd_nd2(:,2),predict_2)
plot(y1,y2,'DisplayName','Hyperplane')
title('testing data')
legend('Dist1','Dist2')


% A continuation would be to evaluate how well the model did at predicting
% the data... The arrays scores_x which is returned by predict() tells us
% the confidence the model has that each data point belongs to a given
% label. There are numbers given for each class (dist1 and dist2 in this
% case), and the more positive the score, the more confident the decision.
% This is based (I believe) off how far each point is from the hyperplane.




