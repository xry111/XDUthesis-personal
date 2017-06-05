function y = Phi(x, size, H, trans)
  if ~trans % y = \Phi x = H wavelet^{-1} (x)
    Y = ifwt2(reshape(x, size), 'db8', 4);
    y = H * Y(:);
  else % x = wavelet(H'y)
    Y = fwt2(reshape(H' * x, size), 'db8', 4);
    y = Y(:);
  end
  