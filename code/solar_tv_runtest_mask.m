function solar_tv_runtest_mask(s_input, s_output, s_mask, s_outmask, measure)
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

% original image
im = double(importdata(s_input));

% the mask
if (length(s_mask) != 0)
  mask = double(importdata(s_mask));
  H = H * diag(mask(:));
end

% observation
b = H*im(:);
bavg = mean(abs(b));

% add noise
sigma = 0.10;
noise = randn(m,1);
b = b + sigma*bavg*noise;

% solver paramaters
clear opts
opts.mu = 2^9;
opts.beta = 2^6;
opts.mu0 = 2^1;      % trigger continuation shceme
opts.beta0 = 2^-2;    % trigger continuation shceme
opts.maxcnt = 10;
opts.tol_inn = 1e-3;
opts.tol = 1E-6;
opts.maxit = 1025;
opts.TVL2 = true;

% reconstruction
[estIm, out] = TVAL3(H,b,80,80,opts);
estIm = estIm - min(estIm(:));

% save the image
imwrite(uint8(estIm), s_output);
if (length(s_mask) != 0)
  imwrite(uint8(estIm.*mask), s_outmask);
end