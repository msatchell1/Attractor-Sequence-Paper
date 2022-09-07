function [s] = generate_sequences(p,genType)
% Generate the sequences for the experiment
% Inputs
% 1. p: parameter structure from make_params()
% 2. genType: Type of experiment e.g. 'permutations', 'latin square', etc.
switch genType
    % returns all permutations of sequences of length p.sequence_length
    % made up of two stimulus types (0 or 1)
    case 'permutations'
        s = [];
        for i=0:p.sequence_length
            temp = ones(1,p.sequence_length); temp(1:i) = 2;
            s = [s; unique(perms(temp),'rows')];
        end
    % generates a p.nseqs X p.nseqs matrix of unique sequences (each row is a sequence) made up of
    % p.nseqs different stimulus types such that each stimulus type appears
    % in each serial position the same number of times
    case 'latin square'
        s = latsq_word_seq_gen(p.nseqs);
    case 'nearest-neighbor' % not used in the paper
        s = [1 2 3 4 5 6 7;
             2 3 4 5 6 7 1;
             3 4 5 6 7 1 2;
             4 5 6 7 1 2 3;
             5 6 7 1 2 3 4;
             6 7 1 2 3 4 5;
             7 1 2 3 4 5 6];
    case 'random subset' % not used in the paper
        s = [];
        nUnique = 0;
        while (size(s,1) < p.nseqs)
            randseq = randperm(p.n_dif_stims);
            seq = randseq(1:p.Nstims);
            if (~ismember(seq,s,'rows'))
                nUnique = nUnique+1;
                s(nUnique,:) = seq;
            end
        end
end
end

