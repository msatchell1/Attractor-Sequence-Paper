% function [dotp] = run_trainings(tp)
% For running linear classification model trainings on provided random
% seeds, classification specifications, etc.
% Inputs:
% tp - Parameters to cover all the simulations.

%% Single 2-model comparison
% tp = make_train_params("clsf_index_array",[1,1 ; 2,2]); % tp for parameters across simulations.
% [LCOs] = Train_LinClass(tp); % Runs simulations.
% 
% W1 = LCOs(1).Mdl.Beta; W2 = LCOs(2).Mdl.Beta;
% % Normalize the hyperplane vectors to unit length
% W1 = W1/norm(W1); W2 = W2/norm(W2);
% % Calculate dot product between the vectors
% dotp = dot(W1, W2)



%% Multiple 2-model comparisons
tp = make_train_params();



% List of stim_seeds to loop through.
stim_seed_list = 10:1:25;

% dotp_same_chartype = [];
dotp_same_char = [];
dotp_diff_char = [];

% Array to hold correlation coefficients for each model. Each column are
% the correlation coefficients for each of the data points used in the
% model.
% For same characteristics:
mdl_corr_coeffs_same = zeros(tp.num_sweeps*tp.num_mdls*(tp.num_type^tp.num_char), 0);
% For different characteristics:
mdl_corr_coeffs_diff = zeros(tp.num_sweeps*tp.num_mdls*(tp.num_type^tp.num_char), 0);

% Loops over stimulus seeds
for s = 1:(length(stim_seed_list)-1)
    
    % To loop through all possible comparisons between SVM hyperplanes. In the 
    % loop in run_main the stimulus seed simulation is varied as size(type_combs,2) = num_type^num_char
    % number of simulations are run, each time using one of the possible
    % stimulus input combinations (held in type_combs). These simulations
    % comprise the data points used in a single SVM analysis. This loop here
    % runs through combinations of 2 SVM hyperplanes, calculating the dot
    % product between their normal vectors each time. This work could be made a
    % lot faster if I didn't rerun the simulations to create the data each
    % time, instead I could make the data once, then calculate hyperplanes off
    % the data in a seperate loop. 
    for i = 1:2
        for j = 1:2
    
            
            % Remember that clsf_index_array holds the classifications for the
            % two SVM models that will be compared later on with a dotp.
            % clsf_index_array needs to be set up so that each row is a
            % char-type pair, and that the first column holds the char and the
            % second holds the type to classify the data based on. The two rows
            % of clsf_index_array will be the classifications with which to
            % create the SVM hyperplanes that will be compared. It doesn't
            % matter what type is used for classifying the data when there are
            % only 2 types.
            tp.clsf_index_array = [i,1 ; j,1];
%             [i,1 ; j,1]

            % Changes stim_seeds for simulations
            tp.stim_seeds = [stim_seed_list(s), stim_seed_list(s+1)];

            [LCOs] = Train_LinClass(tp); % Runs simulations.
    
            W1 = LCOs(1).Mdl.Beta; W2 = LCOs(2).Mdl.Beta;
            % Normalize the hyperplane vectors to unit length
            W1 = W1/norm(W1); W2 = W2/norm(W2);
            % Calculate dot product between the vectors
            dotp = dot(W1, W2);
    
            if i == j % if chars are equal
                dotp_same_char(end+1) = abs(dotp);
                mdl_corr_coeffs_same(:,end+1) = [LCOs(1).corr_coeffs; LCOs(2).corr_coeffs];
    
            else % if chars are not equal
                dotp_diff_char(end+1) = abs(dotp);
                mdl_corr_coeffs_diff(:,end+1) = [LCOs(1).corr_coeffs; LCOs(2).corr_coeffs];
    
            end
    
    
        end
    end
end

% % To loop through all possible comparisons between SVM hyperplanes.
% % This for loop assumes there are only 2 SVM models calculated.
% for char1 = 1:tp.num_char
%     for char2 = 1:tp.num_char
% 
%         % To loop through all possible comparisons between SVM hyperplanes.
% % This for loop assumes there are only 2 SVM models calculated.
% for i = 1:size(tp.type_combs,2)
%     for j = 1:size(tp.type_combs,2)
% 
%         
%         % Remember that clsf_index_array holds the classifications for the
%         % two SVM models that will be compared later on with a dotp.
%         % clsf_index_array needs to be set up so that each row is a
%         % char-type pair, and that the first column holds the char and the
%         % second holds the type to classify the data based on.
%         tp.clsf_index_array = [tp.type_combs(:,i),tp.type_combs(:,j)];
%         [tp.type_combs(:,i),tp.type_combs(:,j)]
%         [LCOs] = Train_LinClass(tp); % Runs simulations.
% 
%         W1 = LCOs(1).Mdl.Beta; W2 = LCOs(2).Mdl.Beta;
%         % Normalize the hyperplane vectors to unit length
%         W1 = W1/norm(W1); W2 = W2/norm(W2);
%         % Calculate dot product between the vectors
%         dotp = dot(W1, W2)
% 
%         if tp.type_combs(1,i) == tp.type_combs(1,j) % if chars are equal
% 
%             if tp.type_combs(2,i) == tp.type_combs(2,j) % if types are equal
%                dotp_same_chartype(end+1) = dotp
%             else % if types are not equal
%                 dotp_same_char(end+1) = dotp
%             end
% 
%         else % if chars are not equal
%             dotp_diff_char(end+1) = dotp
% 
%         end
% 
% 
%     end
% end



%% Plots
% Plots the dot products with bar graph mean
figure();
hold on;
% bar([1 3],[mean(dotp_same_char) mean(dotp_diff_char)],'w');
bar([1 3],[median(dotp_same_char) median(dotp_diff_char)],'w');
plot(zeros(length(dotp_same_char),1)+1, dotp_same_char, 'go')
plot(zeros(length(dotp_diff_char),1)+3, dotp_diff_char, 'ro')
set(gca,'xtick',[1 3]);
xticklabels(["Same char", "Different char"]);
ylabel("Dot Product")
title(strcat("Comparing SVM vectors | stim dur = ",num2str(tp.stim_dur)))% | stim seeds = ",num2str(tp.stim_seeds)));
xlim([0,4]);
% Use the Wilcoxon rank sum test to determine if two samples x and y have
% equal medians
dotp_median_p = ranksum(dotp_same_char, dotp_diff_char);
txtline = ['WRS p = ', num2str(dotp_median_p)];
text(2,max(dotp_same_char),txtline);
hold off;

% % Plots all correlation coefficients vs dot product
% figure();
% hold on;
% % Fills xvals with the same char dotps for plotting
% xvals = zeros(size(mdl_corr_coeffs_same,1),1) + dotp_same_char;
% for i = 1:length(dotp_same_char)
%     scatter(xvals(:,i), mdl_corr_coeffs_same(:,i));
% end
% title("Effect of Stimulus-Final State Correlation on Hyperplane Dot Product")
% ylabel("Correlation Coefficient")
% xlabel("Dot Product Same Char")
% hold off;


% Plots avg correlation coefficient vs dot product
figure();
hold on;
avg_corr_coeffs = mean(mdl_corr_coeffs_same,1);
std_cc = std(mdl_corr_coeffs_same,0,1);
SEM_cc = std_cc./sqrt(size(mdl_corr_coeffs_same,1));

errorbar(dotp_same_char, avg_corr_coeffs, SEM_cc, "o");
ylabel("Avg Correlation Coefficient")
xlabel("Dot Product Same Char")
title("Effect of Avg Stimulus-Final State Correlation on Hyperplane Dot Product")
% I also want to find the correlation (if any) between these stimulus
% correlation values and the dot product.
[dotp_cc, dotp_cc_p] = corrcoef(dotp_same_char, avg_corr_coeffs);
txtline = ['r = ', num2str(round(dotp_cc(1,2),3)), ', p = ', num2str(round(dotp_cc_p(1,2),4))];
text(max(dotp_same_char)/2, max(avg_corr_coeffs), txtline);

hold off;

% figure();
% hold on;
% bar([1 3 5],[mean(dotp_same_chartype) mean(dotp_same_char) mean(dotp_diff_char)],'w');
% plot(zeros(length(dotp_same_chartype),1)+1, dotp_same_chartype, 'bo')
% plot(zeros(length(dotp_same_char),1)+3, dotp_same_char, 'go')
% plot(zeros(length(dotp_diff_char),1)+5, dotp_diff_char, 'ro')
% set(gca,'xtick',[1 3 5]);
% xticklabels(["Same char/type", "Same char only", "Different char"]);
% ylabel("Dot Product")
% title(strcat("stim seeds = ",num2str(tp.stim_seeds)));
% xlim([0,6]);

