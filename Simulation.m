% Sub Program
%
% Simulation.m
%
% This function plots the result of simulation


function [result] = Simulation (Network_Capacity,xpos,ypos,TLPC,SINR,SINR_IFR)
result = 1;
dist = (xpos.^2 + ypos.^2) .^ (1/2);
%SINR
figure
plot (dist', SINR, 'ks')
hold on
grid on
plot (dist', SINR_IFR, 'rs')
plot (dist', TLPC(:,1), 'gs')
xlabel('distance from the base station (km)')
ylabel('SINR (dB)')
title ('SINR Comparision between IFR, IFR3 & TLPC')
legend('IFR', 'IFR3', 'TLPC')
print -depsc Comparison_SINR.eps
% Downlink Capacity (Fairless Time)
figure
plot (Network_Capacity(:,7),Network_Capacity(:,1),'ks-')
hold on
grid on
plot (Network_Capacity(:,7),Network_Capacity(:,2),'rs-.')
plot (Network_Capacity(:,7),Network_Capacity(:,3),'gs--')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity of IFR,IFR3 & TLPC (Fairless Time)')
legend ('IFR','IFR3','TLPC')
print -depsc Network_Capacity_Time.eps
% Downlink Capacity (Fairless through)
figure
plot (Network_Capacity(:,7),Network_Capacity(:,4),'ks-')
hold on
grid on
plot (Network_Capacity(:,7),Network_Capacity(:,5),'rs-.')
plot (Network_Capacity(:,7),Network_Capacity(:,6),'gs--')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity of IFR,IFR3 & TLPC (Fairless Throughput)')
legend ('IFR','IFR3','TLPC')
print -depsc Network_Capacity_Throughput.eps
% Downlink Capacity Comparison(IFR)
figure
plot (Network_Capacity(:,7),Network_Capacity(:,1),'ks-')
hold on
grid on
plot (Network_Capacity(:,7),Network_Capacity(:,4),'rs-.')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity (IFR)')
legend ('Time','Throughput')
print -depsc Network_Capacity_IFR.eps
% Downlink Capacity Comparison(IFR3)
figure
plot (Network_Capacity(:,7),Network_Capacity(:,2),'ks-')
hold on
grid on
plot (Network_Capacity(:,7),Network_Capacity(:,5),'rs-.')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity (IFR3)')
legend ('Time','Throughput')
print -depsc Network_Capacity_IFR3.eps
% Downlink Capacity Comparison(IFR)
figure
plot (Network_Capacity(:,7),Network_Capacity(:,3),'ks-')
hold on
grid on
plot (Network_Capacity(:,7),Network_Capacity(:,6),'rs-.')
xlabel ('distance from the base station(km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity (TLPC)')
legend ('Time','Throughput')
print -depsc Network_Capacity_TLPC.eps
% Overall
figure
plot (Network_Capacity(:,7),Network_Capacity(:,1),'ks-')
hold on
grid
plot (Network_Capacity(:,7),Network_Capacity(:,4),'bs-')
plot (Network_Capacity(:,7),Network_Capacity(:,2),'rs-.')
plot (Network_Capacity(:,7),Network_Capacity(:,5),'cs-.')
plot (Network_Capacity(:,7),Network_Capacity(:,3),'ys--')
plot (Network_Capacity(:,7),Network_Capacity(:,6),'ms--')
xlabel ('distance between user and base station (km)')
ylabel ('Downlink Network Capacity (bps)')
title ('Network Capacity of all schemes')
legend('IFR(time)','IFR(through)','IFR3(time)','IFR3(through)','TLPC(time)','TLPC(through)')
print -depsc Network_Capacity.eps
end