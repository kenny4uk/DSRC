% Sub Program
%
% Result_Comparison_Capacity.m
%
% This function plots the Comparsion of Capacity

function [result] = Result_Comparison_Capacity (Network_Capacity_Sim,Network_Capacity_Model)
result = 1;
% Downlink Capacity (Fairness Time) (IFR)
figure
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,1),'ks-')
hold on
grid on
plot (Network_Capacity_Model(:,9),Network_Capacity_Sim(:,1),'rs-.')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity Comparison (IFR) (Fairness Time)')
legend ('Model','Simulation')
print -depsc Network_Capacity_Comparison_Time_IFR.eps
% Downlink Capacity (Fairness Time) (IFR3)
figure
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,2),'ks-')
hold on
grid on
plot (Network_Capacity_Model(:,9),Network_Capacity_Sim(:,2),'rs-.')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity Comparison (IFR3) (Fairness Time)')
legend ('Model','Simulation')
print -depsc Network_Capacity_Comparison_Time_IFR3.eps
% Downlink Capacity (Fairness Time) (FFR)
figure
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,3),'ks-')
hold on
grid on
plot (Network_Capacity_Model(:,9),Network_Capacity_Sim(:,3),'rs-.')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity Comparison (FFR) (Fairness Time)')
legend ('Model','Simulation')
print -depsc Network_Capacity_Comparison_Time_FFR.eps
% Downlink Capacity (Fairness Time) (TLPC)
figure
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,4),'ks-')
hold on
grid on
plot (Network_Capacity_Model(:,9),Network_Capacity_Sim(:,4),'rs-.')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity Comparison (TLPC) (Fairness Time)')
legend ('Model','Simulation')
print -depsc Network_Capacity_Comparison_Time_TLPC.eps
% Downlink Capacity (Fairness Throughput) (IFR)
figure
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,5),'ks-')
hold on
grid on
plot (Network_Capacity_Model(:,9),Network_Capacity_Sim(:,5),'rs-.')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity Comparison (IFR) (Fairness Throughput)')
legend ('Model','Simulation')
print -depsc Network_Capacity_Comparison_Throughput_IFR.eps
% Downlink Capacity (Fairness Throughput) (IFR3)
figure
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,6),'ks-')
hold on
grid on
plot (Network_Capacity_Model(:,9),Network_Capacity_Sim(:,6),'rs-.')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity Comparison (IFR3) (Fairness Throughput)')
legend ('Model','Simulation')
print -depsc Network_Capacity_Comparison_Throughput_IFR3.eps
% Downlink Capacity (Fairness Throughput) (FFR)
figure
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,7),'ks-')
hold on
grid on
plot (Network_Capacity_Model(:,9),Network_Capacity_Sim(:,7),'rs-.')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity Comparison (FFR) (Fairness Throughput)')
legend ('Model','Simulation')
print -depsc Network_Capacity_Comparison_Throughput_FFR.eps
% Downlink Capacity (Fairness Throughput) (TLPC)
figure
plot (Network_Capacity_Model(:,9),Network_Capacity_Model(:,8),'ks-')
hold on
grid on
plot (Network_Capacity_Model(:,9),Network_Capacity_Sim(:,8),'rs-.')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity Comparison (TLPC) (Fairness Throughput)')
legend ('Model','Simulation')
print -depsc Network_Capacity_Comparison_Throughput_TLPC.eps
end
%******* end of file *********