% Sub-Program
%
% FFR_Model.m
%
% This function gives informations about SINR & Capacity of FFR (Modelling)
%

%

function [Fout] = FFR_Model(alpha,Noise_model,de_bs,BW,usernum,xpos,ypos,di_bs_edge)
de_bs1 = de_bs; %density of the Base Station (IFR1)
de_bs3 = de_bs/3; %density of the Base Station (IFR3)
BW_inner = (BW * 2 * pi * ((0.7*di_bs_edge) ^ 2))/(2 * sqrt(3) * di_bs_edge ^2 * 2);
j=0;
dist_FFR = (xpos.^2 + ypos.^2).^(1/2);
while j <= usernum
    j = j + 1;
    if j > usernum
        break
    end
    
    if dist_FFR(1,j) >= 0.7 * di_bs_edge
    FSINR(j,1) = 10 * log10 ((dist_FFR(1,j) ^ -alpha *(alpha - 2))/(Noise_model + ((2 * pi * de_bs3 * (2*di_bs_edge - dist_FFR(1,j))^(2-alpha)))));
    FCapacity(j,2) = 1/3 * (BW - BW_inner) * log2 (1+FSINR(j,1));
    else
    FSINR(j,1) = 10 * log10 ((dist_FFR(1,j) ^ -alpha *(alpha - 2))/(Noise_model+ (2 * pi * de_bs1 * (2*di_bs_edge - dist_FFR(1,j))^(2-alpha))));
    FCapacity(j,2) = BW_inner * log2(1 + FSINR(j,1));        
    end
    Foutput (j,1) = FSINR(j,1);
    Foutput (j,2) = FCapacity(j,2);
end
[Fout] = Foutput;
%******* end of file *********