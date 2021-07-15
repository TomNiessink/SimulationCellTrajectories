function [H,grH2]=H_field(x,h)

a = 3.176E57;
b = -1081;

y = 110E-3+h/2+200E-6+x;

H=a*exp(b*y);
grH = a*b*exp(b*y);
grH2 = grH.^2/1000; %unit conversion