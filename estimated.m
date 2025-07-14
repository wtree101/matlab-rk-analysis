n = 10; m = 500;
q = 0.5; beta = 0.1;

Tmin = 100*n; 
trans_estimate_c = 1 / (1 - q) / log(1/beta); 
Dmin = floor(trans_estimate_c * log(Tmin)); %safe: integer times 1/q
%reach a low accuracy
Dnum = 5;
Dmax = Dmin + (Dnum-1)*2; %Ps 2 for q = 0.5
lnTmax = Dmax / trans_estimate_c;
points_num = Dnum;
fprintf('Dmin = %d\n', Dmin);
fprintf('Dmax = %d\n', Dmax);
fprintf('lnTmin = %.4f\n', log(Tmin));
fprintf('lnTmax = %.4f\n', lnTmax);
