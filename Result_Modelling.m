% Sub Program
%
% Result_Modelling.m
%
% This function plots the result of modelling



function [result] = Result_Modelling(Network_Capacity_Model,xpos,ypos,TLPC_M,IFR_M,IFR3_M,FFR_M)
result = 1;
dist = (xpos.^2 + ypos.^2) .^ (1/2);
%SINR
figure
plot (dist',IFR_M(:,1) , 'ks')
hold on
grid on
plot (dist', IFR3_M(:,1), 'rs')
plot (dist',FFR_M(:,1) , 'ms')
plot (dist', TLPC_M(:,1), 'gs')
xlabel('distance from the base station (km)')
ylabel('SINR (dB)')
title ('SINR Comparision between IFR, IFR3, FFR & TLPC (Model)')
legend('IFR', 'IFR3','FFR', 'TLPC')
print -depsc Comparison_SINR.eps
% Downlink Capacity (Fairness Time)
figure
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,1),'ks-')
hold on
grid on
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,2),'rs-.')
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,3),'ms:')
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,4),'gs--')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity of IFR,IFR3 & TLPC (Fairness Time)(Model)')
legend ('IFR','IFR3','TLPC')
print -depsc Network_Capacity_Model_Time.eps
% Downlink Capacity (Fairness through)
figure
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,5),'ks-')
hold on
grid on
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,6),'rs-.')
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,7),'ms:')
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,8),'gs--')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity of IFR,IFR3,FFR & TLPC (Fairness Throughput)(Model)')
legend ('IFR','IFR3','FFR','TLPC')
print -depsc Network_Capacity_Model_Throughput.eps
% Downlink Capacity Comparison(IFR)
figure
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,1),'ks-')
hold on
grid on
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,5),'rs-.')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity (IFR)(Model)')
legend ('Time','Throughput')
print -depsc Network_Capacity_Model_IFR.eps
% Downlink Capacity Comparison(IFR3)
figure
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,2),'ks-')
hold on
grid on
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,6),'rs-.')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity (IFR3)(Model)')
legend ('Time','Throughput')
print -depsc Network_Capacity_Model_IFR3.eps
% Downlink Capacity Comparison(FFR)
figure
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,3),'ks-')
hold on
grid on
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,7),'rs-.')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity (FFR)(Model)')
legend ('Time','Throughput')
print -depsc Network_Capacity_Model_FFR.eps
% Downlink Capacity Comparison(TLPC)
figure
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,4),'ks-')
hold on
grid on
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,8),'rs-.')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity (TLPC)(Model)')
legend ('Time','Throughput')
print -depsc Network_Capacity_Model_TLPC.eps
% Overall
figure
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,1),'ks-')
hold on
grid
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,5),'bs-')
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,2),'rs-.')
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,6),'cs-.')
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,3),'ks:')
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,7),'gs:')
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,4),'ys--')
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,8),'ms--')
xlabel ('distance between user and base station (km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity of all schemes(Model)')
legend('IFR(time)','IFR(through)','IFR3(time)','IFR3(through)','FFR(time)','FFR(through)','TLPC(time)','TLPC(through)')
print -depsc Network_Capacity_Model.eps
end
%******* end of file *********