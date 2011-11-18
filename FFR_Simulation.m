% Sub Program
%
% FFR_Simulation.m
%
% This function generates SINR and Capacity of each user (FFR) (Simulation)
%

%
function [ FFR_S ] = FFR_Simulation(BW,Signal,usernum,Noise_sim,Interference,xpos,ypos,di_bs_edge)
dis = (xpos.^2 + ypos.^2 ) .^ (1/2);
m = 0;
BW_inner = (BW * 2 * pi * ((0.7*di_bs_edge) ^ 2))/(2 * sqrt(3) * di_bs_edge ^2 * 2);
while m < usernum
    m = m + 1;
    if m > usernum
        break
    end
    if dis(1,m) >= 0.7 * di_bs_edge
        FFR_S(m,1) = 10 * log10 (Signal(m,1) / (sum(Interference(8:19,m)) + (1/3)*Noise_sim*(BW-BW_inner)/BW));
        FFR_S(m,2) = (1/3 * (BW - BW_inner)) * log2 (1 + FFR_S(m,1));
    else
        FFR_S(m,1) = 10 * log10 (Signal(m,1) / (sum(Interference(:,m)) + Noise_sim*BW_inner/BW));
        FFR_S(m,2) = BW_inner * log2 (1 + FFR_S(m,1));        
    end 
end
end
%******* end of file *********