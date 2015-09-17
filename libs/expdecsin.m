function y = expdecsin(x,amp0,amp1,omeg,lambda,x0)
% phi=-3.1415;
% x0=0;
% omeg=45;
y=amp0+amp1.*cos(2*pi./(omeg).*(x-x0)).*exp(-1./(lambda).*(x-x0));
end