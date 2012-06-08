clc ;
clear all;
close all;
n = 10 ; 
spdavg_set=[10 15 20 25 30 40 56];%average speed set in m/s
sSpd =length(spdavg_set);
for i=1:sSpd
    v=rand(1,n)*spdavg_set(i)*0.5+spdavg_set(i)*0.75;% vechicles selects speed uniformly
end
%% test case 1
S = 30; % speed Normalizer
ctx = struct('v', 60 , 'distanceFromRx', 1000);
alpha = max(0, min(1,v/S));
len = 1500; % length of packet 
rate = CARS_GetRate(ctx, alpha, len );



%% test case 2
% ctx.speed = 30;
S = 30; % speed Normalizer
ctx.distanceFromRx = 12;% distance from AP
alpha = max(0, min(1,v/S));
len = 1500; % length of packet 
rate = CARS_GetRate(ctx, alpha, len);



%% test case 3
% ctx.speed = 30;
S = 30; % speed Normalize
ctx.distanceFromRx = 12;
alpha = max(0, min(1,v/S));
len = 1500 % length of packet 
rate = CARS_GetRate(ctx, alpha, len);



%% test case 4 
% ctx.speed = 30;
S = 30; % speed Normalize
ctx.distanceFromRx = 12;%
alpha = max(0, min(1,v/S));
len = 1500; % length of packet 
rate = CARS_GetRate(ctx, alpha, len);
