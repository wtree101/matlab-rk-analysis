% filepath: /Users/wutong/Documents/LearningNote/PRKm/Theoretical Analysis of Subsampled Linear Randomized Kaczmarz Iterative Method/PR_quantile/code/drawPR_beta.m

% Parameters (matching Phasediagram_beta.m)
n = 100; m = 50000;
q = 0.5; lnT = 9.5; % Set T to match your experiment
betamin = 0.01;


% Create grids
beta_list = [0.01,0.05,0.1,0.15,0.2];
D_list = 2:2:20;
invlnbeta_list = 1 ./ log(1 ./ beta_list); % 1/ln(1/beta)






% Initialize success rate matrix
P = zeros(length(D_list), length(beta_list));

% Load data from files
for i = 1:length(D_list)
    D = D_list(i);
    for j = 1:length(beta_list)
        beta = beta_list(j);
        % Load data
        data_file = sprintf('success_rate_data_n_%d_m_%d_beta_%.4f_q_%.4f', n, m, beta, q);
        data_dir = ['data/',data_file,'/finite3/']; % Replace with your path
        
        % Find all files matching the pattern
        pattern = sprintf('D_%d_lnT_%.4f_t_*.mat', D, lnT);
        file_list = dir(fullfile(data_dir, pattern));
        
        if ~isempty(file_list)
            % Extract t values from filenames and find the maximum
            t_values = [];
            for k = 1:length(file_list)
                [~, name, ~] = fileparts(file_list(k).name);
                tokens = regexp(name, 'D_\d+_lnT_[\d.]+_t_(\d+)', 'tokens');
                if ~isempty(tokens)
                    t_values(end+1) = str2double(tokens{1}{1});
                end
            end
            
            if ~isempty(t_values)
                max_t = max(t_values);
                filename = sprintf('D_%d_lnT_%.4f_t_%d.mat', D, lnT, max_t);
                filepath = fullfile(data_dir, filename);
                if exist(filepath, 'file')
                    data = load(filepath);
                    P(i, j) = data.point.p;
                end
            end
        end
    end
end



% To avoid log(0), set zeros to a small positive value (e.g., 1e-6)
%P_log = log10(max(P, 1e-16));

% Map values in (0,1) to log10 scale, keep 1 as max color
% Plot heat-map with log-scaled color data using pcolor
P_plot = P;
imagesc(invlnbeta_list, D_list, P_plot);

% P_plot(P_plot < 1) = log10(max(P_plot(P_plot < 1), 1e-2)); % log10 for (0,1)
% P_plot(P_plot >= 1) = 0; % 0 will be the max color (since log10(1)=0)
% 
% % Use imagesc for centered bins
% imagesc(invlnbeta_list, D_list, P_plot);
set(gca, 'YDir', 'normal');
colormap("gray");
% set(gca, 'FontSize', 16);
% xlabel('1/ln(1/\beta)', 'FontSize', 18);
% ylabel('D', 'FontSize', 18);
% 
% cb = colorbar;
% cb.Ticks = [log10(0.001), log10(0.01), log10(0.1), 0];
% cb.TickLabels = {'0.001', '0.01', '0.1', '1'};
% cb.Label.String = 'log_{10}(Error)';
% % 

% [X, Y] = meshgrid(invlnbeta_list, D_list);
% h = pcolor(X, Y, P_plot);
% set(h, 'EdgeColor', 'none');
% set(gca, 'YDir', 'normal');
% colormap(gray);
% set(gca, 'FontSize', 16);
% xlabel('1/ln(1/\beta)', 'FontSize', 18);
% ylabel('D', 'FontSize', 18);