% Sub Program
%
% n_capacity_model.m
%
% This function generates the network capacity of modelling


function [ output_modelling ] = n_capacity_model(IFR_M,IFR3_M,FFR_M,TLPC_M,usernum)
z=0;
n = 0;
avg_Capacity_model = mean(IFR_M(:,2));
avg_Capacity_IFR3_model = mean(IFR3_M(:,2));
avg_Capacity_FFR_model = mean (FFR_M(:,2));
avg_Capacity_TLPC_model = mean(TLPC_M(:,2));
while n < usernum
    n = n + 1;
    if n > usernum
        break
    end
    if IFR_M(n,2) > avg_Capacity_model
        capacity_IFR_temp_model(n,1) = IFR_M(n,2);
    else
        capacity_IFR_temp_model(n,1) = 0;
    end
    if IFR3_M(n,2) > avg_Capacity_IFR3_model
        capacity_IFR3_temp_model(n,1) = IFR3_M(n,2);
    else
        capacity_IFR3_temp_model(n,1) = 0;
    end
    if FFR_M(n,2) > avg_Capacity_FFR_model
        capacity_FFR_temp_model(n,1) = FFR_M(n,2);
    else
        capacity_FFR_temp_model(n,1) = 0;
    end
    if TLPC_M(n,2) > avg_Capacity_TLPC_model
        capacity_TLPC_temp_model(n,1) = TLPC_M(n,2);
    else
        capacity_TLPC_temp_model(n,1) = 0;
    end
end   
for x = 1:10:100
    y = x + 10;
    if y == 101;
        y = y - 1;
    elseif y > 100
        break
    end
    z = z + 1;
    % Fairness Time
    capacity_time_model = mean(IFR_M(x:y,2));
    capacity_IFR_time_model = mean(IFR3_M(x:y,2));
    capacity_FFR_time_model = mean(FFR_M(x:y,2));
    capacity_TLPC_time_model = mean(TLPC_M(x:y,2));
    % Fairness Throughput
    capacity_IFR_thr_model = mean(capacity_IFR_temp_model(x:y,1));
    capacity_IFR3_thr_model = mean(capacity_IFR3_temp_model(x:y,1));
    capacity_FFR_thr_model = mean(capacity_FFR_temp_model(x:y,1));
    capacity_TLPC_thr_model = mean(capacity_TLPC_temp_model(x:y,1));
    % Result
    output_modelling(z,1) = capacity_time_model;
    output_modelling(z,2) = capacity_IFR_time_model;
    output_modelling(z,3) = capacity_FFR_time_model;
    output_modelling(z,4) = capacity_TLPC_time_model;
    output_modelling(z,5) = capacity_IFR_thr_model;
    output_modelling(z,6) = capacity_IFR3_thr_model;
    output_modelling(z,7) = capacity_FFR_thr_model;
    output_modelling(z,8) = capacity_TLPC_thr_model;
end
% Distance
for k = 1:10
    di_model = k * 0.1;
    output_modelling(k,9) = di_model;
end
end
%******* end of file *********