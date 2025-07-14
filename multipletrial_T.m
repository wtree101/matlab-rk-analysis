function [success_rate_T, err_list_T, cpu_time_T] = multipletrial_T(n, m, q, beta, lnT_all, D, trial_num, AA, xx, yy, is_theory_quantile, is_replacement, verbose, collectmode)
    % MULTIPLETRIAL - Performs multiple trials of an algorithm
    % Inputs:
    %   n - problem dimension
    %   m - number of equations/samples
    %   q - quantile parameter
    %   beta - algorithm parameter
    %   T - number of iterations
    %   trial_num - number of trials to run
    %   verbose - display progress (true/false)
    %   AA - measurement matrix
    %   xx - true solution vector
    
    T_all = round(exp(lnT_all));
    T = T_all(end);
    Tnum = length(T_all);
    paras.maxiter = T;
    paras.samplesize = round(D);
    paras.quantileq = q;
    paras.if_theory_quantile = is_theory_quantile; % Use theoretical quantile
    paras.if_replacement = is_replacement; % Use replacement in sampling
    if nargin < 13
        verbose = false;
    end
    if nargin < 14
        collectmode = 0; % Default to no collection mode
    end
    if collectmode == 1
        T_all = 1:T;
        Tnum = T;
    end
    success_list_T = zeros(trial_num, Tnum); 
    err_list_T = zeros(trial_num, Tnum);
    cpu_time_T = zeros(trial_num, Tnum);

    if collectmode == 0
        parfor i = 1:trial_num
            [xhat, err, cpu_time] = quantileRK(AA, xx, yy, paras);
            Is_success_list = err(T_all) / norm(xx) < 1e-2;
            success_list_T(i, :) = Is_success_list; % Store success for each trial
            err_list_T(i, :) = err(T_all); % Store errors for each trial
            cpu_time_T(i, :) = cpu_time(T_all); % Store CPU time for each trial
        end
    else
        for i = 1:trial_num
            [xhat, err, cpu_time] = quantileRK(AA, xx, yy, paras);
            Is_success_list = err(T_all) / norm(xx) < 1e-2;
            success_list_T(i, :) = Is_success_list; % Store success for each trial
            err_list_T(i, :) = err(T_all); % Store errors for each trial
            cpu_time_T(i, :) = cpu_time(T_all); % Store CPU time for each trial
        end
    end

    success_rate_T = sum(success_list_T, 1) / trial_num; % Aggregate success rates
    err_list_T = mean(err_list_T, 1); % Average errors across trials
    cpu_time_T = mean(cpu_time_T, 1); % Average CPU times across trials
    if verbose==1
        figure(1);
        semilogy(err/norm(xx))
    end
    % for one trial and test


end