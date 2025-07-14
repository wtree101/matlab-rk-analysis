% Script to run Phasediagram_T.m with multiple beta values
clear; clc;

% Define beta values to test
beta_values = [0.01, 0.05, 0.1, 0.15,0.2];
%beta_values = [0.01];
%beta_values = [0.15, 0.2];
%beta_values = [0.02201648, 0.03847748, 0.05831439, 0.08043959,
      % 0.10393383, 0.12808618, 0.15237467, 0.1764301];
% Store original parameters from Phasediagram_T.m
n = 100; m = 50000;
q = 0.5;
Dmin = 2;
Dmax = 20;
Dgap = 2;
Dnum = (Dmax - Dmin)/Dgap + 1;
D_all = Dmin:Dgap:Dmax;

% lnT_min = floor(log(10000));
% lnT_max = ceil(log(10000));
% lnT_all = linspace(lnT_min, lnT_max, points_num);
lnT_all = 7:0.5:11;
points_num = length(lnT_all);

% Experiment settings
trial_num = 20; 
verbose = 0; 
add_flag = 0;
old_trialnum = 0;

% Fixed measurement matrix and solution (as in original code)
AA = randn(m,n);
AA = AA ./ vecnorm(AA, 2, 2);
xx = randn(n,1);
xx =  xx./ norm(xx);
%Initialize pool with default settings
if isempty(gcp('nocreate'))
    fprintf('Starting parallel pool...\n');
    parpool(8);
    fprintf('Parallel pool started with %d workers\n', gcp().NumWorkers);
else
    fprintf('Parallel pool already running with %d workers\n', gcp().NumWorkers);
end

% Loop through each beta value
for beta_idx = 1:length(beta_values)
    beta = beta_values(beta_idx);
    
    fprintf('\n=== Running experiment with beta = %.4f ===\n', beta);
    
    % Create data directory for this beta
    data_file = sprintf('success_rate_data_n_%d_m_%d_beta_%.4f_q_%.4f', n, m, beta, q);
    dist = ['data/', data_file, '/finite3/'];
    if ~exist(dist, 'dir')
        mkdir(dist);
    end
    
    % Save grids for this beta experiment
    save([dist, '/Tgrid.mat'], "lnT_all");
    save([dist, '/Dgrid.mat'], "D_all");
    
    % Calculate corruption for this beta
    numCorrupt = floor(m*beta);
    ee = zeros(m,1);
    ee(1:numCorrupt) = 10;
    %unifrnd(-5,5, [numCorrupt 1])+3;
    yy = AA*xx + ee;

    lnTmax = lnT_all(end);
    Tmax = round(exp(lnTmax));
    % Run experiment for each D value
    parfor D_idx = 1:length(D_all)
        D = D_all(D_idx);
        points_DvslnT = cell(points_num, 1);
        
        % Display current parameters
        disp(['Running experiment with ', ...
              'n = ', num2str(n), ...
              ', m = ', num2str(m), ...
              ', trials = ', num2str(trial_num), ...
              ', q = ', num2str(q), ...
              ', beta = ', num2str(beta), ...
              ', D = ', num2str(D)]);
        
        % Set up corruption
        
        
        %ee(1:numCorrupt) = 2^Tmax;
        
        tic;
        
        % Use Tmode=2 (same as original code)
        [p_list, e_list, t_list] = multipletrial_T(n, m, q, beta, lnT_all, D, trial_num, AA, xx, yy, verbose);
        %p_list = multipletrial_T(n, m, q, beta, lnT_all, D, trial_num, AA, xx, yy, verbose);
        for i = 1:points_num
            lnT = lnT_all(i);
            T = round(exp(lnT));
            point = struct();
            point.D = D; 
            point.lnT = lnT; 
            point.p = p_list(i);
            point.e = e_list(i);
            point.t = t_list(i);
            point.trial_num = trial_num;
            
            points_DvslnT{i} = point;
        end
        
        t = toc;
        disp(['Execution time: ', num2str(t), ' seconds']);
        
        % Save results
        for i = 1:points_num
            point = points_DvslnT{i};
            point_name = sprintf('D_%d_lnT_%.4f_t_%d.mat', point.D, point.lnT, point.trial_num + old_trialnum*add_flag);
            if add_flag == 0
                parsave([dist, point_name], point);
                %save();
                disp(['Save ', point_name]);
            else
                old_pointname = sprintf('D_%d_lnT_%.4f_t_%d.mat', point.D, point.lnT, old_trialnum);
                % Load existing point data and update
                old_data = load([dist, old_pointname], 'point');
                data_old = old_data.point;
                
                % Update probability: weighted average
                p_new = (data_old.p * data_old.trial_num + point.p * point.trial_num) / ...
                        (data_old.trial_num + point.trial_num);
                
                % Update error: weighted average
                e_new = (data_old.e * data_old.trial_num + point.e * point.trial_num) / ...
                        (data_old.trial_num + point.trial_num);
                
                % Update time: sum of times
                t_new = data_old.t + point.t;
                
                % Update the point structure
                point.p = p_new;
                point.e = e_new;
                point.t = t_new;
                point.trial_num = data_old.trial_num + point.trial_num;
                
                % Save updated point back to the same file
                %save([dist, point_name], 'point');
                parsave([dist, point_name], point);
                disp(['Updated ', point_name, ' with p = ', num2str(p_new)]);
            end
        end
    end
    
    fprintf('=== Completed experiment with beta = %.4f ===\n\n', beta);
end

fprintf('All experiments completed!\n');
% Close the current parallel pool
delete(gcp('nocreate'));

% Define parsave function (put this at the top of your script or in a separate file)
function parsave(filename, point)
    save(filename, 'point');
end

% Initialize pool with default settings

