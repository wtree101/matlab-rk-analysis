% filepath: /Users/wutong/Documents/MATLAB/RK/draw_compare_replace.m
clear; clc;
beta_values = [0.01];
n = 100; m = 50000;
q = 0.5;
is_theory_quantile = 1;
trial_num = 10;
output_to_paper = 1;
points_num = 1;
lnT_all = [log(20000)];
D_list_with_replacement = [4,40,5000,50000];
D_list_without_replacement = [4,50000];

% Unified D list for consistent coloring
D_all = unique([D_list_with_replacement, D_list_without_replacement]);
colors = lines(length(D_all));

subdir_with = sprintf('data_2/n_%d_m_%d_beta_%.4f_q_%.2f_theoryQ_%d_repl_1', n, m, beta_values(1), q, is_theory_quantile);
subdir_without = sprintf('data_2/n_%d_m_%d_beta_%.4f_q_%.2f_theoryQ_%d_repl_0', n, m, beta_values(1), q, is_theory_quantile);

figure; 
legend_entries = {};

% Plot with replacement (solid lines)
for i = 1:length(D_list_with_replacement)
    D = D_list_with_replacement(i);
    color_idx = find(D_all == D, 1);
    filename = sprintf('%s/D_%d_lnT_%.4f_t_%d_all.mat', subdir_with, D, lnT_all(1), trial_num);
    if exist(filename, 'file')
        data = load(filename);
        e = data.err_list;
        idx = (1:length(e)) <= 20000;
        semilogy(1:sum(idx), e(idx), '-', 'Color', colors(color_idx,:), 'LineWidth', 2);
        legend_entries{end+1} = sprintf('D = %d', D);
    end
    if i == 1
        hold on; % Hold on for subsequent plots
    end
end

% Plot without replacement (dashed lines, same color as with replacement)
for i = 1:length(D_list_without_replacement)
    D = D_list_without_replacement(i);
    color_idx = find(D_all == D, 1);
    filename = sprintf('%s/D_%d_lnT_%.4f_t_%d_all.mat', subdir_without, D, lnT_all(1), trial_num);
    if exist(filename, 'file')
        data = load(filename);
        e = data.err_list;
        idx = (1:length(e)) <= 20000;
        semilogy(1:sum(idx), e(idx), '--', 'Color', colors(color_idx,:), 'LineWidth', 2);
        legend_entries{end+1} = sprintf('D = %d', D);
    end
end

xlabel('Iteration', 'FontSize', 18);
ylabel('Error (log scale)', 'FontSize', 18);
title('Error vs Iteration', 'FontSize', 20);
legend(legend_entries, 'Location', 'best', 'FontSize', 16);
grid on;
set(gcf, 'PaperPositionMode', 'auto');
hold off;

fig_dir = fullfile('/Users/wutong/Documents/LearningNote/PRKm/67dd28a13466e6105cc5e83d/PR_quantile/figs');
if ~exist(fig_dir, 'dir')
    mkdir(fig_dir);
end

set(gcf, 'Color', 'w'); % Ensure white background for EPS
set(gca, 'ColorOrderIndex', 1); % Reset color order for consistency
print(gcf, '-depsc2', '-painters', fullfile(fig_dir, 'draw_compare_replace_2.eps'));
% saveas(gcf, fullfile(fig_dir, sprintf('error_vs_time_q_%.4f_beta_%.4f_D_%s.png', q, beta_values(1), strjoin(string(D_all), '_'))));
%saveas(gcf, fullfile(fig_dir, 'draw_compare_replace.eps'), 'epsc');
