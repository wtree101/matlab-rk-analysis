% Parameters (matching Phasediagram_T.m)
n = 100; m = 50000;
q = 0.5; beta = 0.2;
trial_num = 20;


% Load data
data_file = sprintf('success_rate_data_n_%d_m_%d_beta_%.4f_q_%.4f', n, m, beta, q);
data_dir = ['data/',data_file,'/finite/']; % Replace with your path

% Create grids
load([data_dir,'/Dgrid.mat'], 'D_all');
load([data_dir,'/Tgrid.mat'], 'lnT_all');
%lnT_all = [9.5,10];
P = zeros(length(D_all),length(lnT_all));
% Initialize success rate matrix
%P = zeros(length(D_all), length(lnT_all));

Tmode = 1;
for i = 1:length(D_all)
    D = D_all(i);
    
    for j = 1:length(lnT_all)
        lnT = lnT_all(j);
        filename = sprintf('D_%d_lnT_%.4f_t_%d.mat', D, lnT,trial_num);
        filepath = fullfile(data_dir, filename);
        
        if exist(filepath, 'file')
            data = load(filepath);
            P(i, j) = log(data.point.e);
            %P(i, j) = -log(data.point.e);
            %P(i, j) = data.point.p;
            %P(i, j) = data.point.t;
        end
    end
end

% Plot heat-map
figure;
imagesc(lnT_all, D_all, P);
set(gca, 'YDir', 'normal');
colorbar;
colormap('gray'); % Black (0) to white (1)
set(gca, 'FontSize', 16);  % Font size for the axes
xlabel('ln(T)', 'FontSize', 18);  % X-axis label
ylabel('D', 'FontSize', 18);  % Y-axis label
cb = colorbar;  % Create color bar
cb.Label.String = 'Success Rate';  % Set the label for the color bar

%title('Phase Transition Diagram', 'FontSize', 18);