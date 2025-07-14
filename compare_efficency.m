% Script to run Phasediagram_T.m with multiple beta values
clear; clc;

% Define beta values to test
beta_values = [0.01,0.05];
% Store original parameters from Phasediagram_T.m
n = 100; m = 50000;
q_list = [0.5];
trial_num = 10;
D_all =  [100,200,500,1000,2000];
D_all_extended = [100,200,500,1000,2000];
is_theory_quantile_list = [1];
is_replacement_list = [0];
%D_all = [0];
points_num = 1;
lnT_all = [log(20000)];
AA = randn(m,n);
AA = AA ./ vecnorm(AA, 2, 2);
xx = randn(n,1);
xx = xx./ norm(xx);

if isempty(gcp('nocreate'))
    fprintf('Starting parallel pool...\n');
    parpool(8);
    fprintf('Parallel pool started with %d workers\n', gcp().NumWorkers);
else
    fprintf('Parallel pool already running with %d workers\n', gcp().NumWorkers);
end

for tq_idx = 1:length(is_theory_quantile_list)
    is_theory_quantile = is_theory_quantile_list(tq_idx);
    for rep_idx = 1:length(is_replacement_list)
        is_replacement = is_replacement_list(rep_idx);
        for qidx = 1:length(q_list)
            q = q_list(qidx);
            for bidx = 1:length(beta_values)
                beta = beta_values(bidx);
                fprintf('Running experiments for beta = %.4f, q = %.2f, is_theory_quantile = %d, is_replacement = %d\n', ...
                    beta, q, is_theory_quantile, is_replacement);

                % Fixed measurement matrix and solution (as in original code)
                numCorrupt = floor(m*beta);
                ee = zeros(m,1);

                ee(1:numCorrupt) = unifrnd(-5,5, [numCorrupt 1])*1;
                yy = AA*xx + ee;
                % Storage for results
                time_results = cell(length(D_all), 1);
                error_results = cell(length(D_all), 1);
                D_labels = cell(length(D_all), 1);
                % Create a subdirectory for each experiment configuration
                subdir = sprintf('data_2/n_%d_m_%d_beta_%.4f_q_%.2f_theoryQ_%d_repl_%d', ...
                    n, m, beta, q, is_theory_quantile, is_replacement);
                if ~exist(subdir, 'dir')
                    mkdir(subdir);
                end
                % Run experiments for each D value
                T = exp(lnT_all(1));

                %beta = 0.01 run all
                if beta==0.01
                    D_now = D_all_extended;
                else
                    D_now = D_all;
                end
                parfor i = 1:length(D_now)
                    D = D_now(i);

                    fprintf('  Running experiment for D = %g\n', D);

                    tic;
                    [success_list, err_list, time_list] = multipletrial_T(n, m, q, beta, lnT_all, D, trial_num, AA, xx, yy, is_theory_quantile, is_replacement,0,1);
                    elapsed_time = toc;
                    fprintf('    Time elapsed for D = %g: %.2f seconds\n', D, elapsed_time);

                    filename = sprintf('%s/D_%d_lnT_%.4f_t_%d_all.mat', subdir, D, lnT_all(1), trial_num);
                    parsave(filename, success_list, err_list, time_list, D, T, beta);
                end
            end
        end
    end
end


% % Save results to a .mat file
% save('compare_efficency_results.mat', 'time_results', 'error_results', 'D_labels', 'D_all', 'beta_values');

% Create comparison plots

%colors = ['b', 'r', 'g', 'm']; % Different colors for each D value

% for i = 1:length(D_all)
%     semilogy(time_results{i}, error_results{i}, [colors(i) '-'], 'LineWidth', 2);
% end
% for i = 1:length(D_all)
%     plot(time_results{i}, error_results{i}, [colors(i) '-'], 'LineWidth', 2);
% end
function parsave(filename, success_list, err_list, time_list, D, T, beta)
    save(filename, 'success_list', 'err_list', 'time_list', 'D', 'T', 'beta');
end