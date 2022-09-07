% parameter sweep
nnets = 10;
param1 = 'W_e0'; % 1st parameter to be varied. Must be a field in the parameter structure
param2 = 'W_ee_max'; % 2nd parameter to be varied
sweep_dir = 'data/We0_Wee_Iapp_generalization'; mkdir(sweep_dir); % top level directory 
param1_range = 80:5:100; % set of values to test param1 at
param2_range = .28:.07:.56; % set of values to test param2 at
% make a run log to keep track of varied parameters and their values
run_log.param1 = param1; run_log.param2 = param2;
run_log.param1_range = param1_range; run_log.param2_range = param2_range;
run_log.nnets = nnets; % # of nets at each parameter value to test
startMode = 'silent';
save([sweep_dir '/run_log.mat'],'run_log','-mat')

parfor ind=1:(length(param1_range)*length(param2_range)) % parallelized loop
    [i,j] = ind2sub([length(param1_range) length(param2_range)],ind); % get param1 and param2 indices from linear index
    for k=1:nnets
        savedir = [sweep_dir '/' num2str(i) '/' num2str(j) '/net' num2str(k)];
        if (~exist(savedir,'dir'))
            mkdir(savedir)
        end
        % Make parameters
        p = make_params(param1,param1_range(i),param2,param2_range(j),'sigma',0);
        % Make sequences
        seqs = generate_sequences(p,'permutations'); nseqs = size(seqs,1);
        % Run the experiment
        run_expt(p,seqs,savedir,startMode,'yes','yes');
    end
end
send_text_message('908-721-2166','AT&T','Finished Parameter Sweep',['Job = ' sweep_dir])