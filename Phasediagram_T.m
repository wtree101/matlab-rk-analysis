%%%%%%%%%% parameters setting
n = 10; m = 50;
q = 0.5; beta = 0.01;

new = 1;

% a script output recommended D T setting; 


Dmin = 2;
Dmax = 20;
Dnum = 1;
points_num = Dnum; %or, say, Tnum. 
data_file = sprintf('success_rate_data_n_%d_m_%d_beta_%.4f_q_%.4f', n, m, beta, q);
%load(['data/',data_file,'/2/','/Tgrid.mat'], 'lnT_all')
lnT_min = 7;
lnT_max = 12;
D_all = Dmin:2:Dmax;
lnT_all = linspace(lnT_min,lnT_max,Dnum);
%end

dist = ['data/',data_file,'/7/'];
if ~exist(dist, 'dir')
    mkdir(dist);
end
save([dist,'/Tgrid.mat'],"lnT_all")
save([dist,'/Dgrid.mat'],"D_all")
%lnTmax = Dnum + lnTmin;
%%%%%%%%%%%%



%%%%%%%%%%%%%%%
trial_num = 5; 
verbose = 0; 
add_flag = 0;

%%%%%%%%%%% AA xx can be fixed!
AA = randn(m,n);
AA = AA ./ vecnorm(AA, 2, 2);
xx = randn(n,1);
ee = zeros(m,1);
%yy fixed for fixed beta experiment
numCorrupt = floor(m*beta);











%%%%%%%%%%%%%%%%%%%%%%

for D = D_all
    points_DvslnT = cell(points_num, 1);
     % Display the parameters being used for debugging
    disp(['Running experiment with ', ...
          'n = ', num2str(n), ...
          ', m = ', num2str(m), ...
          ', trials = ', num2str(trial_num), ...
          ', q = ', num2str(q), ...
          ', beta = ', num2str(beta), ...
          ', D = ', num2str(D)] );
    

   
    lnTmax = lnT_all(end);
    Tmax = round(exp(lnTmax));
    ee(1:numCorrupt) = 2^Tmax; % not large enough?? or...?
    yy = AA*xx + ee;
    tic;
     % Load data from files
    % two Tmodes
    % 1 T from differet trials
    % 2 T from the same trials
    Tmode=2;
    if Tmode==1
        for i = 1:points_num
            lnT = lnT_all(i);
            T = round(exp(lnT));
            %ee(1:numCorrupt) = unifrnd(-1000,1000, [numCorrupt 1])+3;
           
            %Xstar = groundtruth(d1,d2,r,kappa);
            disp (['Running for D = ', num2str(D), ', lnT = ', num2str(lnT), ', T = ', num2str(T)]);
            p = multipletrial(n,m,q,beta,T,D,trial_num,AA,xx,yy,verbose);
            point = struct();
            point.D = D; point.lnT = lnT; point.p = p;
            %points.Xstar = Xstar; 
            point.trial_num = trial_num;
            
            points_DvslnT{i} = point;
            %save the data for graph
             
        end
    else
        p_list = multipletrial_T(n,m,q,beta,lnT_all,D,trial_num,AA,xx,yy,verbose);
        for i = 1:points_num
            lnT = lnT_all(i);
            T = round(exp(lnT));
            point = struct();
            point.D = D; point.lnT = lnT; point.p = p_list(i);
            %points.Xstar = Xstar; 
            point.trial_num = trial_num;
            
            points_DvslnT{i} = point;
            %save the data for graph 
        end
    end
     t = toc;
        disp(['Execution time: ', num2str(t), ' seconds']);
    for i = 1:points_num
        point = points_DvslnT{i};
        point_name = sprintf('D_%d_lnT_%.4f_t_%d.mat', point.D, point.lnT, point.trial_num);
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




