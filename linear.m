
y = [0.2171, 0.3338, 0.4343];
D = [2, 6, 10];

% Find linear fit coefficients [k, b]
coeffs = polyfit(y, D, 1);
k = coeffs(1);
b = coeffs(2);

fprintf('D = %.4f*y + %.4f\n', k, b);

% Verify the fit
D_fit = k*y + b;
fprintf('Original D: [%.1f, %.1f, %.1f]\n', D);
fprintf('Fitted D:   [%.1f, %.1f, %.1f]\n', D_fit);