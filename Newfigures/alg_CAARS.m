function [Best_Rate] = alg_CAARS( speed, alpha,  n , EH)

%% initialization
Max_Thr = 0; 
MIN_RATE = 3;
Best_Rate = MIN_RATE ;
N = 4; % max no of Retransmission 
rho = 8;
Rate = [1 2 3 4 5 6 7 8 ];
bitrate = [3 4.5 6 9 12 18 24 27]*1e6;%tranmission rate for 802.11p
x_max  = 1000; %Length of road in meters
ap = 500;     %position of RSU in meters 
old_pos = rand(1, n) * x_max;%initialo position of the vehicles are generated
t = rand();% randomly generated time
len=1500;
% spdavg_set=[10 15 20 25 30 40 56];%average speed set in m/s
spdavg_set=[1:5:56];%average speed set in m/s
sSpd =length(spdavg_set);
for i=1:sSpd
    v=rand(1,n)*spdavg_set(i)*0.5+spdavg_set(i)*0.75;% vechicles selects speed uniformly
end

commRange=300;

%% Algorithm 
for i = 1 : size(Rate, 2)
    rate = Rate(i);
    
    % PER = alpha * EC(ctx, rate, len) + (1 - alpha) * EH(rate, len);
%     PER = alpha * EC(t, v, old_pos, ap, commRange, n, x_max) + (1 - alpha) *EH;
    PER = alpha * EC(t, v, old_pos, ap, commRange, n, x_max)   
    avg_retries = ((N .* PER .^(N+1)) - ((N+1).*(PER .^N) + 1)) / ((1 - PER) + (N .* (PER .^ N)));
  temp1 = (avg_retries .* ((1 - (PER .^ N) .^ rho)));
      
    for j = 1 : size(temp1, 2)
        Thr = bitrate(rate) / temp1(j);
    end
    
    if Thr > Max_Thr
        Best_Rate = bitrate(rate)
        Max_Thr = Thr;
    
    end   
end



end