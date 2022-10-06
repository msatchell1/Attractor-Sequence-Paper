% function [dotp] = run_trainings(tp)
% For running linear classification model trainings on provided random
% seeds, classification specifications, etc.
% Inputs:
% tp - Parameters to cover all the simulations.

%% Single 2-model comparison
% tp = make_train_params("clsf_index_array",[1,1 ; 2,2]); % all parameters across simulations.
% [LCOs] = Train_LinClass(tp); % Runs simulations.
% 
% W1 = LCOs(1).Mdl.Beta; W2 = LCOs(2).Mdl.Beta;
% % Normalize the hyperplane vectors to unit length
% W1 = W1/norm(W1); W2 = W2/norm(W2);
% % Calculate dot product between the vectors
% dotp = dot(W1, W2);



%% Multiple 2-model comparisons
tp = make_train_params();


dotp_same_chartype = [];
dotp_same_char = [];
dotp_diff_char = [];

% To loop through all possible comparisons between SVM hyperplanes.
% This for loop assumes there are only 2 SVM models calculated.
for i = 1:size(tp.type_combs,2)
    for j = 1:size(tp.type_combs,2)

        
        % Remember that clsf_index_array holds the classifications for the
        % two SVM models that will be compared later on with a dotp.
        tp.clsf_index_array = [tp.type_combs(:,i),tp.type_combs(:,j)];
        
        [LCOs] = Train_LinClass(tp); % Runs simulations.

        W1 = LCOs(1).Mdl.Beta; W2 = LCOs(2).Mdl.Beta;
        % Normalize the hyperplane vectors to unit length
        W1 = W1/norm(W1); W2 = W2/norm(W2);
        % Calculate dot product between the vectors
        dotp = dot(W1, W2);

        if tp.type_combs(1,i) == tp.type_combs(1,j) % if chars are equal

            if tp.type_combs(2,i) == tp.type_combs(2,j) % if types are equal
               dotp_same_chartype(end+1) = dotp
            else % if types are not equal
                dotp_same_char(end+1) = dotp
            end

        else % if chars are not equal
            dotp_diff_char(end+1) = dotp

        end


    end
end

%% Plots

figure();
hold on;
bar([1 2 3],[mean(dotp_same_chartype) mean(dotp_same_char) mean(dotp_diff_char)],'w');
plot(zeros(length(dotp_same_chartype),1)+1, dotp_same_chartype, 'bo')
plot(zeros(length(dotp_same_char),1)+2, dotp_same_char, 'go')
plot(zeros(length(dotp_diff_char),1)+3, dotp_diff_char, 'ro')
set(gca,'xtick',[1 2 3]);
xticklabels(["Same char/type", "Same char only", "Different char"]);
ylabel("Dot Product")
title(strcat("stim seeds = ",num2str(tp.stim_seeds)));
xlim([0,4]);

