function [Best_Rate] = alg_CARS( speed, alpha,  n , EH)

%% initialization
Max_Thr = 0; 
MIN_RATE = 3;
Best_Rate = [];
Best_RateOP = [];
N = 4; % max no of Retransmission 
rho = 8;
Rate = [1 2 3 4 5 6 7 8 ];
bitrate = [3 4.5 6 9 12 18 24 27]*1e6; 
x_max  = 1000; % in meters
ap = 500;     % in meters 
% n = 10        % no of vehicles ...
old_pos = rand(1, n) * x_max;
t = rand();

spdavg_set=[10 15 20 25 30 40 56];%average speed set in m/s
sSpd =length(spdavg_set);
for i=1:sSpd
    v=rand(1,n)*spdavg_set(i)*0.5+spdavg_set(i)*0.75;% vechicles selects speed uniformly
end

commRange=300;

%% Algorithm 
for i = 1 : size(Rate, 2)
    rate = Rate(i);
    
    % calculation  for each car
    PER = [];
    avg_retries = [];
    for pp =1 : n-1
        % PER = alpha * EC(ctx, rate, len) + (1 - alpha) * EH(rate, len);
        % PER = alpha * EC(t, v, old_pos, ap, commRange, n, x_max) + (1 - alpha) * EH;
        temp = EC(t, v, old_pos, ap, commRange, n, x_max, pp);
        temp = alpha * temp;
        PER(pp) = temp + ((1 - alpha) * EH) ;   
    end
    
    avg_retries = ((N .* (PER .^(N+1))) - (((N+1).*(PER .^N)) + 1)) ./ ((1 - PER) + (N .* (PER .^ N)));
    
    ThrDenom = (avg_retries .* ((1 - (PER .^ N)) .^ rho));
    
    for j = 1 : size(ThrDenom, 2)
        Thr(j) = bitrate(rate) / ThrDenom(j);
    end
    
    for j = 1 : size(Thr, 2)
        if Thr(j) > Max_Thr
            Best_Rate(j) = bitrate(rate);
            Max_Thr = Thr(j);
        else
            Best_Rate(j) = -1;
        end
    end
    Best_RateOP(:,i) = Best_Rate';
end
end