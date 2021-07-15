function [murp] = calc_murp(m_max,H,Vp)



H=H;
H_max=250000;

if H/H_max >= 1
    f=1;
else
    f=sqrt(sin((H/H_max)*pi/2));
end

murp = 1+f*m_max/(Vp*H);