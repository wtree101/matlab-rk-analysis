%%%%%%%%%% parameters setting
% fixed T and change beta
n = 100; m = 500;
q = 0.5; 
Tmin = 5*n; %reach a low accuracy
trans_estimate_c = 1 / (1 - q) * log(T); 
betamin = 0.01;
lnbetamin = 1/log(1/betamin);
Dmin = trans_estimate_c * lnbetamin; %safe: integer times 1/q
Dnum = 10;
Dmax = Dmin + Dnum;
lnbetamax = Dmax / trans_estimate_c;

trial_num = 20; verbose = 1;
add_flag = 1;

data_file = sprintf('success_rate_data_n_%d_m_D(%d-%d)_%d_T_%d_q_%f', n, m, Dmin, Dmax, T, q);

full_path = fullfile('data', data_file);
if ~exist(full_path, 'dir')
    mkdir(full_path);
end

dist = ['data/',data_file,'/2/'];
if ~exist(dist, 'dir')
    mkdir(dist);
end

%%%%%%%%%%%%%%%%%%%%%%

ln_all = linspace(lnbetamin,lnbetamax,Dnum);
save([full_path,'/betagrid.mat'],"ln_all")

%%%%%%%%%%%%%%%%%%%%%%
points_num = Dnum;
for D = Dmin:Dmax
    points_DvslnBeta = cell(points_num, 1);
     % Display the parameters being used for debugging
    disp(['Running experiment with ', ...
          'n = ', num2str(n), ...
          ', m = ', num2str(m), ...
          ', trials = ', num2str(trial_num), ...
          ', q = ', num2str(q), ...
          ', T = ', num2str(T)]);
    tic;
    
    for i = 1:points_num
        lnbeta = ln_all(i);
        beta = exp(-1/lnbeta);
        %Xstar = groundtruth(d1,d2,r,kappa);
        p = multipletrial(n,m,q,beta,T,trial_num,verbose);
        point = struct();
        point.D = D; point.lnbeta = lnbeta; point.p = p;
        %points.Xstar = Xstar; 
        point.trial_num = trial_num;
        
        points_DvslnBeta{i} = point;
        %save the data for graph
         
    end
     t = toc;
        disp(['Execution time: ', num2str(t), ' seconds']);
    for i = 1:points_num
        point = points_DvslnBeta{i};
        point_name = sprintf('D_%d_lnbeta_%d_t_%d.mat', point.D, point.lnbeta, point.trial_num);
        if add_flag==0
            save([dist, point_name], "point");
             disp(['Save ', point_name])
        else
                   % Load existing point data
            old_data = load([dist, point_name], 'point');
            data_old = old_data.point;
            
            % Update probability: weighted average
            p_new = (data_old.p * data_old.trial_num + point.p * point.trial_num) / ...
                    (data_old.trial_num + point.trial_num);
            
            % Update the point structure
            point.p = p_new;
            point.trial_num = data_old.trial_num + point.trial_num; % Combine trial counts
            
            % Save updated point back to the same file
            save([dist, point_name], 'point');
            disp(['Updated ', point_name, ' with p = ', num2str(p_new)]);
        end
       
    end

end

%%%%%%%%%%%%%%%%%