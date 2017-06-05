function solar_l1_runtest_mask(s_input, s_output, s_mask, s_outmask, measure)
% s_input: test case file name.
% s_output: reconstructed file name.
% s_mask: mask file name, or empty string if there is not mask.
% s_outmask: file name to store reconstructed masked result.
%            if s_mask is empty, this would be ignored silently.
% measure: the proportion of measurement.

% problem size
xsize = [80,80];
n = prod(xsize);
m = floor(measure*n);
im = double(importdata(s_input));
H = randi([0,1],m,n);
H(H==0) = -1;
H /= sqrt(m);

% the mask
if (length(s_mask) != 0)
  mask = double(importdata(s_mask));
  H = H * diag(mask(:));
end

% \Phi = H \Psi
A.times = @(x) Phi(x, xsize, H, 0);
A.trans = @(x) Phi(x, xsize, H, 1);

% noise
b = H * im(:);
bavg = mean(abs(b));
sigma = 0.10;  % noise std
noise = randn(m,1);
b = b + sigma*bavg*noise;

% solver parameters
clear opts;
opts.tol = 0.002;
opts.rho = 1;
opts.nonorth = 1;
opts.stepfreq = 10;

% reconstruction
estIm = yall1(A, b, opts);

% save the image
imwrite(uint8(ifwt2(reshape(estIm, [80,80]), 'dB8', 4)), s_output);
if (length(s_mask) != 0)
  imwrite(uint8(mask.*ifwt2(reshape(estIm, [80,80]), 'dB8', 4)), s_outmask);
end