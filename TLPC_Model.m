% Sub-Program
%
% TLPC_Model.m
%
% This function gives informations of SINR & Capacity of TLPC (Modelling)
%


function [Tout] = TLPC_Model(alpha,sigma,Noise_model,de_bs,BW,di_bs_edge,usernum,xpos,ypos)
de_bs1 = de_bs; %density of the Base Station (IFR1)
de_bs3 = de_bs/3; %density of the Base Station (IFR3)
j = 0;
while j <= usernum
    j = j + 1;
    if j > usernum
        break
    end
    dist_tlpc = (xpos(1,j)^2 + ypos (1,j)^2)^(1/2);
    if dist_tlpc <= 0.7*di_bs_edge
    TSINR(j,1) = 10 * log((2/(1+sigma)) * ((dist_tlpc ^ -alpha *(alpha - 2))/(Noise_model + (2 * pi * de_bs1 * (2*di_bs_edge - dist_tlpc)^(2-alpha)))));
    TCapacity (j,2) = (2/3) * BW * log2(1+TSINR(j,1));
    else
    TSINR(j,1) = 10 * log (1/((1/sigma)*(1/((dist_tlpc ^ -alpha *(alpha - 2))/(Noise_model + (2 * pi * de_bs1 * (2*di_bs_edge - dist_tlpc)^(2-alpha)))))+(1-(1/sigma))*(1/((dist_tlpc ^ -alpha *(alpha - 2))/(Noise_model + ((2 * pi * de_bs3 * (2*di_bs_edge - dist_tlpc)^(2-alpha))))))));
    TCapacity (j,2) = (1/3) * BW * log2 (1+TSINR(j,1));
    end
    Toutput (j,1) = TSINR (j,1);
    Toutput (j,2) = TCapacity (j,2);
end
Tout = Toutput;    
end
%******* end of file *********