% Sub-program
%
% IFR_reuse3.m
%
% This function gives informations of SINR & Capacity of IFR3 (Modelling)


function [IFR3out] = IFR3_Model(alpha,Noise_model,de_bs,BW,di_bs_edge,usernum,xpos,ypos)
de_bs_IFR3 = de_bs/3; %density of the Base Station
j = 0;
while j <= usernum
    j = j + 1;
    if j > usernum
        break
    end
    dist_ifr3 = (xpos(1,j)^2 + ypos(1,j)^2)^1/2; % distance between user and the base station
    SINR3 = 10 * log10 ((dist_ifr3 ^ -alpha *(alpha - 2))/((Noise_model) + ((2 * pi * de_bs_IFR3 * (2*di_bs_edge - dist_ifr3)^(2-alpha)))));
    Capacity3 = (BW/3) * log2(1 + SINR3);
    output3 (j,1) = SINR3;
    output3 (j,2) = Capacity3;
end
IFR3out = output3;
end
%******* end of file *********