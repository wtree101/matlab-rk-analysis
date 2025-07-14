%% test_quantileRK: test script for quantileRK.m
close all
clc
clear


%% Parameters
mm = 500;
nn = 10;
corruptrate = .01;
paras.maxiter = 1000;
paras.samplesize = 10;
paras.quantileq = .5;

%% Set up systems
numCorrupt = floor(mm*corruptrate);
AA = randn(mm,nn);
xx = randn(nn,1);
ee = zeros(mm,1);
ee(1:numCorrupt) = unifrnd(-5,5, [numCorrupt 1])+3;
yy = AA*xx + ee;

%% Run RK 
[xhat, err, cpu_time] = quantileRK(AA, xx, yy, paras);

%% Plot results
semilogy(err/norm(xx))
xlabel('Iteration')
ylabel('Approximation Error')