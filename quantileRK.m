function [xhat, err, cpu_time] = quantileRK(AA, xx, yy, paras)
% Quantile Randomized Kaczmarz - solve linear system Ax=y

% Inputs
%   AA: mxn measurement matrix
%   yy: mxn measurement vector 
%   xx: unkown solution
%   paras:
%       .maxiter: maximum number of iterations
%       .samplesize: quantile check sample size
%       .quantileq: quantile value q 
%       
% Outputs
%   xhat: approximation of solution to system
%   err: (paras.maxiter)x1 vector containing approximation errr at each iteration
%   cpu_time: (paras.maxiter)x1 vector containing elapsed cpu time at each iteration

%% Parameters
[mm,~] = size(AA);
[nn,~] = size(xx);
maxiter = paras.maxiter;
qq = paras.quantileq;
ss = paras.samplesize;
if_theory_quantile = paras.if_theory_quantile;
if_replacement = paras.if_replacement;

%% Initializations I
xhat = zeros(nn,1);
err = [];
cpu_time = [];

%% Row selection prob dist
rnorm = sum(AA'.^2);
fnorm = norm(AA, 'fro')^2;

%probDistr = rnorm/fnorm;
probDistr = rnorm/fnorm;

%% Initialization II (cpu time)
tt = cputime;

indXi = [];
normResidi = [];


%% Main loop
for iter=1:maxiter
    
    %% Randomly select measurement
    ii = randsample(1:mm, 1, 'true', probDistr);
    residi_signed = yy(ii)-AA(ii,:)*xhat;
    residi = abs(residi_signed);

    %% Quantile Check
    
    if (ss>0)
        if if_replacement
            tau = randsample(1:mm, ss, true);  %even prob here... and true means with replacement
        else
            tau = randsample(1:mm, ss, false);
        end
        %tau = randsample(1:mm, ss);
        subResid = abs(AA(tau,:)*xhat - yy(tau));
        if if_theory_quantile
            if mod(ss*qq, 1) ~= 0
                warning('Theoretical quantile index is not an integer.');
            end
            qvalue = quantile(subResid, (ss*qq - 0.5)/ss); % quantile in theory
        else
            qvalue = quantile(subResid, qq); 
        % here the quantile is not the same as in theory. careful. e.g. mean
        end
    else
       qvalue = inf; 
    end
    

    %% Update
    if(residi <= qvalue) % < and \leq?
        %indXi = [indXi; ii];
        %[aa,bb] = sort(subResid);
        % ii = randsample(tau(subResid<qvalue),1);
        % residi = yy(ii)-AA(ii,:)*xhat;
        % dx = residi .* AA(ii,:)'/rnorm(ii);
        % xhat = xhat + dx;
        % subResid2 = abs(AA(tau,:)*xhat - yy(tau));
        %  ii = randsample(tau(subResid<qvalue),1);
        % residi = yy(ii)-AA(ii,:)*xhat;
        dx = residi_signed .* AA(ii,:)'./rnorm(ii);
        xhat = xhat + dx;
        %subResid2 = abs(AA(tau,:)*xhat - yy(tau))
    else
        dx = zeros(nn,1);
        xhat = xhat + dx;
    end
    
    

    %% Update step - Original Kacz
    %dx = (yy(ii)-AA(ii,:)*xhat)'*AA(ii,:)/mm;
    %dx = ((yy(ii)-AA(ii,:)*xhat)*AA(ii,:)/rnorm(ii));
    
    %% Metrics
    err(iter) = norm(xx-xhat);
    cpu_time(iter) = cputime-tt;

    
end

end