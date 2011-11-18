% Sub Program
%
% TLPC_result.m
%
% This function generates SINR and Link Capacity of each user


function [ T_result ] = TLPC_result (BW,TLPC_Signal,usernum,Noise_sim,Interference,xpos,ypos,di_bs_edge,sigma)
dis = (xpos.^2 + ypos.^2 ) .^ (1/2);
m = 0;
while m <= usernum
    m = m + 1;
    if m > usernum
        break
    end
    if dis(1,m) >= 0.7 * di_bs_edge
        T_result(m,1) = 10 * log10 (TLPC_Signal(m,1) / (sigma*sum(Interference(:,m)) + (1/3)*Noise_sim));
        T_result(m,2) = (1/3 * BW) * log2 (1 + T_result(m,1));
    else
        T_result(m,1) = 10 * log10 (TLPC_Signal(m,1) / (sigma*sum(Interference(:,m)) + (2/3)*Noise_sim));
        T_result(m,2) = (2/3 * BW) * log2 (1 + T_result(m,1));

    end 
end
%******* end of file *********