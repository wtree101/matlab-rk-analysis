% Script to compare error vs Iteration for empirical/theoretical quantile
clear; clc;
beta_values = [0.01];
n = 100; m = 50000;
q = 0.75;
trial_num = 10;
output_to_paper = 0;
points_num = 1;
lnT_all = [log(20000)];
D_list = [8,12,5000,50000];

quantile_modes = [1, 0]; % 1: theoretical, 0: empirical
quantile_labels = {'theoretical quantile', 'empirical quantile'};
styles = {'-', '--'}; % Solid for theoretical, dashed for empirical

rep = 1; % You can also loop over replacement if needed
rep_str = 'repl_1'; % or 'repl_0'

figure; 

% Draw D_list(1) first for both quantile modes
for qmode = 1:2
    is_theory_quantile = quantile_modes(qmode);
    if qmode==1
    subdir = sprintf('data_2/n_%d_m_%d_beta_%.4f_q_%.2f_theoryQ_%d_%s', ...
        n, m, beta_values(1), q, is_theory_quantile, rep_str);
    filename = sprintf('%s/D_%d_lnT_%.4f_t_%d_all.mat', subdir, D_list(1), lnT_all(1), trial_num);
    else
         subdir = sprintf('data3/n_%d_m_%d_beta_%.4f_q_%.2f', ...
        n, m, beta_values(1), 1-q);
    filename = sprintf('%s/D_%d_lnT_%.4f_t_%d_all.mat', subdir, D_list(1), lnT_all(1), trial_num);
    end
    if exist(filename, 'file')
        data = load(filename);
        e = data.err_list;
        idx = (1:length(e)) <= 20000;
        semilogy(1:sum(idx), e(idx), styles{qmode}, 'LineWidth', 2);
    end
    if qmode ==1
        hold on;
    end
end

% Draw the rest of D_list for both quantile modes
for qmode = 1:2
    is_theory_quantile = quantile_modes(qmode);
     if qmode==1
    subdir = sprintf('data_2/n_%d_m_%d_beta_%.4f_q_%.2f_theoryQ_%d_%s', ...
        n, m, beta_values(1), q, is_theory_quantile, rep_str);
    filename = sprintf('%s/D_%d_lnT_%.4f_t_%d_all.mat', subdir, D_list(1), lnT_all(1), trial_num);
    else
         subdir = sprintf('data3/n_%d_m_%d_beta_%.4f_q_%.2f', ...
        n, m, beta_values(1), 1-q);
    filename = sprintf('%s/D_%d_lnT_%.4f_t_%d_all.mat', subdir, D_list(1), lnT_all(1), trial_num);
    end
    for i = 2:length(D_list)
        filename = sprintf('%s/D_%d_lnT_%.4f_t_%d_all.mat', subdir, D_list(i), lnT_all(1), trial_num);
        if exist(filename, 'file')
            data = load(filename);
            e = data.err_list;
            idx = (1:length(e)) <= 20000;
            semilogy(1:sum(idx), e(idx), styles{qmode}, 'LineWidth', 2);
        end
    end
end

D_labels = arrayfun(@(D) sprintf('D = %d', D), D_list, 'UniformOutput', false);
legend_entries = [strcat(D_labels(1), ', ', quantile_labels), ...
                  strcat(D_labels(2:end), ', ', quantile_labels(1)), ...
                  strcat(D_labels(2:end), ', ', quantile_labels(2))];
xlabel('Iteration', 'FontSize', 18);
ylabel('Error (log scale)', 'FontSize', 18);
title('Error vs Iteration (theoretical/empirical quantile)', 'FontSize', 20);
legend(legend_entries, 'Location', 'best', 'FontSize', 12);
grid on;
set(gcf, 'PaperPositionMode', 'auto');
hold off;