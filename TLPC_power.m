% Sub Program
%
% TLPC_power.m
%
% This program Caluclates TLPC coefficient
%


function [TLPC_w] = TLPC_power(xpos,ypos,Ptb,usernum,sigma,di_bs_edge)
t = 0;
t_dist = (xpos.^2 + ypos.^2).^(1/2);
while t <= usernum
    t = t + 1;
    if t > usernum
        break
    end
    if t_dist(1,t) >= 0.7 * di_bs_edge
        TLPC_Ptb(t,1) = Ptb * sigma;
    else
        TLPC_Ptb(t,1) = Ptb;
    end
    TLPC_w (t,1) = TLPC_Ptb (t,1);
end
end
%******* end of file *********