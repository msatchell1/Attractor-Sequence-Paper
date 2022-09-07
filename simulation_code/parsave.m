function [] = parsave(fname,savevar,varname)
% for saving files within a parfor loop
% Inputs
% 1. fname: name of file to same (including any paths to directories)
% 2. savevar: actual variable carrying the data to save
% 3. varname: name of variable to save (will be the name of variable stored
%             in .mat file
switch varname
    case 'p'
        p = savevar;
        save(fname,'p','-mat')
    case 'seqs'
        seqs = savevar;
        save(fname,'seqs','-mat')
    case 'cm'
        cm = savevar;
        save(fname,'cm','-mat')
    case 'accuracy'
        accuracy = savevar;
        save(fname,'accuracy','-mat')
    case 'accuracies'
        accuracies = savevar;
        save(fname,'accuracies','-mat')
    case 'net'
        net = savevar;
        save(fname,'net','-mat')
    case 'y'
        y = savevar;
        save(fname,'y','-mat')
    case 'seqs2train'
        seqs2train = savevar;
        save(fname,'seqs2train','-mat')
    case 'seqs2test'
        seqs2test = savevar;
        save(fname,'seqs2test','-mat')
    case 'test_target'
        test_target = savevar;
        save(fname,'test_target','-mat')
    case 'train_target'
        train_target = savevar;
        save(fname,'train_target','-mat')
    case 'rates'
        rates = savevar;
        save(fname,'rates','-mat')
    case 'primacy'
        primacy = savevar;
        save(fname,'primacy','-mat')
    case 'recency'
        recency = savevar;
        save(fname,'recency','-mat')
end
end

