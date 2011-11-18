% Sub Program
%
% Result_Comparison_SINR.m
%
% This function plots Comparison of SINR


function [result] = Result_Comparison_SINR (xpos,ypos,SINR,SINR_IFR3,TLPC,IFR_M,IFR3_M,TLPC_M,FFR_M,FFR)
result = 1;
dist = (xpos.^2 + ypos.^2).^(1/2);
% SINR Comparison (IFR)
figure
plot (dist',IFR_M(:,1),'ks')
hold on
grid on
plot (dist',SINR,'rd')
xlabel ('distance from the base station(km)')
ylabel ('SINR (dB)')
title ('SINR Comparison (IFR)')
legend ('Model','Simulation')
print -depsc SINR_Comparison_IFR.eps
% SINR Comparison (IFR3)
figure
plot (dist',IFR3_M(:,1),'ks')
hold on
grid on
plot (dist',SINR_IFR3,'rd')
xlabel ('distance from the base station(km)')
ylabel ('SINR (dB)')
title ('SINR Comparison (IFR3)')
legend ('Model','Simulation')
print -depsc SINR_Comparison_IFR3.eps
% SINR Comparison (FFR)
figure
plot (dist',FFR_M(:,1),'ks')
hold on
grid on
plot (dist',FFR(:,1),'rd')
xlabel ('distance from the base station(km)')
ylabel ('SINR (dB)')
title ('SINR Comparison (FFR)')
legend ('Model','Simulation')
print -depsc SINR_Comparison_FFR.eps
% SINR Comparison (TLPC)
figure
plot (dist',TLPC_M(:,1),'ks')
hold on
grid on
plot (dist',TLPC(:,1),'rd')
xlabel ('distance from the base station(km)')
ylabel ('SINR (dB)')
title ('SINR Comparison (TLPC)')
legend ('Model','Simulation')
print -depsc SINR_Comparison_TLPC.eps
% SINR Comparison (Overall_Sim)
figure
plot (dist',SINR,'gs')
hold on
grid on
plot (dist',SINR_IFR3,'md')
plot (dist',FFR(:,1),'b^')
plot (dist',TLPC(:,1),'rh')
xlabel ('distance from the base station(km)')
ylabel ('SINR (dB)')
title ('SINR Comparison (Simulation)')
legend ('IFR','IFR3','FFR','TLPC')
print -depsc SINR_Comparison_Sim.eps
end
%******* end of file *********