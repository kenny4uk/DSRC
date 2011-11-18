% Sub-Program
%
% IFR_reuse1.m
%
% Simulation program to analyze Integer Frequency Reuse 1 scheme
%


function [IFRout] = IFR1_Model(alpha,Noise_model,de_bs,BW,di_bs_edge,usernum,xpos,ypos)
de_bs_IFR = de_bs; %density of the Base Station
j = 0;
while j <= usernum
    j = j + 1;
    if j > usernum
        break
    end
    dist_ifr = (xpos(1,j)^2 + ypos(1,j)^2)^1/2; % distance between user and the base station
        SINR = 10 * log10 ((dist_ifr ^ -alpha * (alpha - 2))/(Noise_model + (2 * pi * de_bs_IFR * (2*di_bs_edge - dist_ifr)^(2-alpha))));
    Capacity = BW * log2(1+SINR);
    output1 (j,1) = SINR;
    output1 (j,2) = Capacity;
end
IFRout = output1;
end
%******* end of file *********