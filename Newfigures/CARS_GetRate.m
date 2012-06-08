function [Best_Rate] = CARS_GetRate(ctx, alpha, len)

%% initialization
Max_Thr = 0; 
MIN_RATE = 3;
Best_Rate = MIN_RATE ;
N = 4; % max no of Retransmission 
rho = 8;% this is the value that signifies the penalty of unsuccessful tx pkt
Rate = [1 2 3 4 5 6 7 8 ];
bitrate = [3 4.5 6 9 12 18 24 27]*1e6; % bit rate for 802.11p
x_max  = 1000; %length of the road in meters
ap = 500;     % position of Access point  in meters 
n = 10 ;      % no of vehicles 
old_pos = rand(1, n) * x_max;% randomly generated node positions
t = rand();

spdavg_set=[10 15 20 25 30 40 56];%average speed set in m/s
sSpd =length(spdavg_set);
for i=1:sSpd
    v=rand(1,n)*spdavg_set(i)*0.5+spdavg_set(i)*0.75;% vehicles selects speed uniformly
end

commRange=300;

%% Algorithm 
for i = 1 : size(Rate, 2)
    rate = Rate(i);
    
    % PER = alpha * EC(ctx, rate, len) + (1 - alpha) * EH(rate, len);
    PER = alpha * EC(t, v, old_pos, ap, commRange, n, x_max) + (1 - alpha) * alg_sample(rate, len);
    
    avg_retries = ((N .* PER .^(N+1)) - ((N+1).*(PER .^N) + 1)) / ((1 - PER) + (N .* (PER .^ N)));
    temp1 = (avg_retries .* ((1 - (PER .^ N) .^ rho)));
    
    for j = 1 : size(temp1, 2)
        Thr = bitrate(rate) / temp1(j);
    end
    
    if Thr > Max_Thr
        Best_Rate = bitrate(rate);
        Max_Thr = Thr;
    
    end   
end



end

