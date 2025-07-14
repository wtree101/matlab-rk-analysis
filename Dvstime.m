% Parameters (matching Phasediagram_T.m)
n = 100; m = 50000;
q = 0.5; beta = 0.05;
tiral_num = 1;

% Load data
data_file = sprintf('success_rate_data_n_%d_m_%d_beta_%.4f_q_%.4f', n, m, beta, q);
data_dir = ['data/',data_file,'/10/']; % Replace with your path

% Create grids
load([data_dir,'/Dgrid.mat'], 'D_all');
load([data_dir,'/Tgrid.mat'], 'lnT_all');

% Fix lnT to the first value
fixed_lnT = lnT_all(2);
lnT_index = 1; % Index for the first lnT value

% Initialize array to store running times
running_times = zeros(length(D_all), 1);

% Extract running times for each D value at fixed lnT
for d_idx = 1:length(D_all)
    % Load running time data for this D and lnT combination
     time_file = sprintf('%sD_%d_lnT_%.4f_t_%d.mat', data_dir,D_all(d_idx), fixed_lnT, trial_num);
    
    if exist(time_file, 'file')
        load(time_file, 'point'); % Assuming variable is named 'runtime'
        running_times(d_idx) = point.t;
    else
        fprintf('Warning: File not found: %s\n', time_file);
        running_times(d_idx) = NaN;
    end
end

% Create the comparison graph
figure;
plot(D_all, running_times, 'bo-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('D values');
ylabel('Running Time (seconds)');
title(sprintf('Running Time vs D (fixed lnT = %.4f)', fixed_lnT));
grid on;

% Remove NaN values for better visualization
valid_indices = ~isnan(running_times);
if sum(valid_indices) < length(running_times)
    fprintf('Note: %d data points were missing\n', sum(~valid_indices));
end