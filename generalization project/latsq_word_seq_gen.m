function [seqs] = latsq_word_seq_gen(nseqs)
% generates a set of nseqs unique sequences such that each stimulus type
% appears an equal number of times in each serial position across the
% sequences. Note this code is especially meant for sequences of length 7
% Inputs
% 1. nseqs: number of sequences to generate
nsquares = 100;
for i=1:nsquares
    M{i} = my_latsq(10);
end
nono_list = [];
count = 0;
for i=1:length(M)
    if (ismember(i,nono_list))
        continue;
    end
    for j=1:length(M)
        if (i == j)
            continue;
        end
        for k=1:7
            for l=1:7
                if (M{i}(k,:) == M{j}(l,:))
                    if (~ismember(j,nono_list))
                        nono_list = [nono_list j];
                    end
                end
            end
        end    
    end
    if (~ismember(i,nono_list))
        count = count+1;
        M2{count} = M{i};
    end
end
duplicates = 0;
for i=1:length(M2)
    for j=1:length(M2)
        if (i == j)
            continue;
        end
        for k=1:7
            for l=1:7
                if (M2{i}(k,:) == M2{j}(l,:))
                    disp([num2str(i) ' shares a row with ' num2str(j)])
                    duplicates = duplicates+1;
                end
            end
        end    
    end
end
if (duplicates == 0)
    disp('duplicates check passed!')
end
pos_seqs = [];
for i=1:length(M2)
    pos_seqs = [pos_seqs; M2{i}];
end
seqs = pos_seqs(1:nseqs,:);

end

