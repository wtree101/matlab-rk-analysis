function success_rate = multipletrial(n, m, q, beta, T, D, trial_num, AA, xx, yy, verbose)
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
    
    
    
    paras.maxiter = T;
    paras.samplesize = round(D);
    paras.quantileq = q;
    if nargin < 10
        verbose = false;
    end
    
    success_list = zeros(trial_num); 
    %output PR transition graph
    for i = 1:trial_num
        [xhat, err, cpu_time] =  quantileRK(AA, xx, yy, paras);
        if err(T)/norm(xx) < 1e-2
            Is_success = 1; % Assuming success if error is below threshold
        else
            Is_success = 0;
        end
        if verbose
            fprintf('Trial %d: Success = %d, Error = %.4f, CPU Time = %.4f seconds\n', i, Is_success, err(T), cpu_time(T));
        end
        success_list(i) = Is_success; % Assuming 'err' is the success indicator
    end

    success_rate = sum(success_list,"all") / trial_num;
    if verbose==1
        figure(1);
        semilogy(err/norm(xx))
    end
    % for one trial and test

end