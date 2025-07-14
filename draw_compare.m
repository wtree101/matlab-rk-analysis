
% Script to run Phasediagram_T.m with multiple beta values
clear; clc;
% Define beta values to test
beta_values = [0.01];
% Store original parameters from Phasediagram_T.m
n = 100; m = 50000;

q = 0.5; % in the algorithm, it is <= 1 - q -> <= qq.
is_theory_quantile = 1; % Use empirical quantile
is_replacement = 1; % Use replacement in sampling

beta = beta_values(1); % Use first beta value
trial_num = 10;
output_to_paper = 1;
points_num = 1;
lnT_all = [log(20000)];

subdir = sprintf('data_2/n_%d_m_%d_beta_%.4f_q_%.2f_theoryQ_%d_repl_%d', ...
                    n, m, beta, q, is_theory_quantile, is_replacement);
%subdir = sprintf('data6/n_%d_m_%d_beta_%.4f_q_%.2f', n, m, beta, q);
D_list = [4,8,12,0];

figure;
%hold on;
filename = sprintf('%s/D_%d_lnT_%.4f_t_%d_all.mat', subdir, D_list(1), lnT_all(1), trial_num);
% Plot e vs iter
% Create directory for figures if it doesn't exist
if output_to_paper==1
    fig_dir = fullfile('/Users/wutong/Documents/LearningNote/PRKm/67dd28a13466e6105cc5e83d/PR_quantile/figs');
    if ~exist(fig_dir, 'dir')
        mkdir(fig_dir);
    end
end


% Plot e vs iter
figure;
data = load(filename);
max_time_D4 = data.T;
t = data.time_list;
e = data.err_list;

%thresh = t(min(20000, length(t)));
thresh = inf;
idx = (1:length(t)) <= 20000;

semilogy(1:sum(idx), e(idx), 'LineWidth', 2); % Increased line width
hold on
for i = 2:length(D_list)
    filename = sprintf('%s/D_%d_lnT_%.4f_t_%d_all.mat', subdir, D_list(i), lnT_all(1), trial_num);
    data = load(filename);
    t = data.time_list;
    e = data.err_list;
    %idx = t <= max_time_D4; % Only keep points within threshold
    semilogy(1:sum(idx), e(idx), 'LineWidth', 2); % Increased line width
end
D_labels = cell(size(D_list));
for i = 1:length(D_list)
    if D_list(i) == 0
        D_labels{i} = 'RK';
    else
        D_labels{i} = sprintf('D = %d', D_list(i));
    end
end
xlabel('Iteration', 'FontSize', 18);
ylabel('Error (log scale)', 'FontSize', 18);
title('Error vs Iteration', 'FontSize', 20);
legend(D_labels, 'Location', 'best', 'FontSize', 16);
grid on;
set(gcf, 'PaperPositionMode', 'auto');
pause(1)
if output_to_paper==1
set(gcf, 'Color', 'w'); % Ensure white background for EPS
set(gca, 'ColorOrderIndex',1); % Reset color order for consistency
print(gcf, '-depsc2', '-painters', fullfile(fig_dir, sprintf('error_vs_iter_q_%.4f_beta_%.4f_D_%s.eps', q,beta, strjoin(string(D_list), '_'))));
saveas(gcf, fullfile(fig_dir, sprintf('error_vs_iter_q_%.4f_beta_%.4f_D_%s.png', q,beta, strjoin(string(D_list), '_'))));
end
hold off;


% Plot e vs time
figure;
filename = sprintf('%s/D_%d_lnT_%.4f_t_%d_all.mat', subdir, D_list(1), lnT_all(1), trial_num);
data = load(filename);
t = data.time_list;
e = data.err_list;
%idx = t <= thresh;
semilogy(t(idx), e(idx), 'LineWidth', 2); % Increased line width
hold on
for i = 2:length(D_list)
    filename = sprintf('%s/D_%d_lnT_%.4f_t_%d_all.mat', subdir, D_list(i), lnT_all(1), trial_num);
    data = load(filename);
    t = data.time_list;
    e = data.err_list;
    %idx = t <= thresh;
    semilogy(t(idx), e(idx), 'LineWidth', 2); % Increased line width
end
xlabel('Time (s)', 'FontSize', 18);
ylabel('Error (log scale)', 'FontSize', 18);
title('Error vs Time', 'FontSize', 20);
legend(D_labels, 'Location', 'best', 'FontSize', 16);
grid on;
%set(gca, 'FontSize', 16, 'LineWidth', 2); % Increase axes font size and line width
set(gcf, 'PaperPositionMode', 'auto');
if output_to_paper==1
set(gcf, 'Color', 'w'); % Ensure white background for EPS
set(gca, 'ColorOrderIndex',1); % Reset color order for consistency
print(gcf, '-depsc2', '-painters', fullfile(fig_dir, sprintf('error_vs_time_q_%.4f_beta_%.4f_D_%s.eps', q,beta, strjoin(string(D_list), '_'))));
saveas(gcf, fullfile(fig_dir, sprintf('error_vs_time_q_%.4f_beta_%.4f_D_%s.png', q,beta, strjoin(string(D_list), '_'))));
end
hold off;
%hold off;