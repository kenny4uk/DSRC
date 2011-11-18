% Main Program
%
% ofdmamain.m
%
% Simulation program to measure the performance of OFDMA network


%%%%%%%%%%%%%%%% preparation part %%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all;

Ptb = 40;                  % Transmitted Power from the base station
Ptb_dB = 10 * log10 (Ptb); % Transmitted Power from the base station in dB
BW = 20 * 10 ^ 6; % Bandwidth
usernum = 100;
R = 1;
[xpos,ypos] = randpos(usernum,R); % Position of users generated
[out] =  basest; % Position of base station generated

%%%%%%%%%%%%%%%% Modeling %%%%%%%%%%%%%%%%%%%%%%%%%%%%
Noise_model = 3.981071705534985e-21 * BW; % -174dbm/Hz
alpha = 3.52; % path-loss exponent
sigma = 5; % Power factor between inner region and boarder area
di_bs_edge = cosd(30)*R; % distance between Base Station and the edge
de_bs = 1/(2*sqrt(3)*(di_bs_edge^2)); %density of the Base Station
[IFR_M] = IFR1_Model(alpha,Noise_model,de_bs,BW,di_bs_edge,usernum,xpos,ypos);
[IFR3_M] = IFR3_Model(alpha,Noise_model,de_bs,BW,di_bs_edge,usernum,xpos,ypos);
[FFR_M] = FFR_Model(alpha,Noise_model,de_bs,BW,usernum,xpos,ypos,di_bs_edge);
[TLPC_M] = TLPC_Model(alpha,sigma,Noise_model,de_bs,BW,di_bs_edge,usernum,xpos,ypos);
[Network_Capacity_Model] = n_capacity_model(IFR_M,IFR3_M,FFR_M,TLPC_M,usernum);
%%%%%%%%%%%%%%%% End of Modelling %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%
[shadowloss] = shadow(); % shadowing effect
[pathloss] = p_loss(usernum,xpos,ypos); % Propagation loss
Signal = Ptb ./ (pathloss + shadow); % Signal received by user (W)
[Noise_sim] = Noise_Power(BW); % Noise_sim power (W)
% Interference Power from each base station (W)
[Interference] = Interference_Power(usernum,xpos,ypos,out);

% IFR
    SINR = 10 * log10 (Signal ./ (sum(Interference)' + Noise_sim)); % SINR (db)
    Capacity = BW * log2 (1+SINR); % Link Capacity of each user
    
% IFR3
   % No Interference from base station 2 - 7 of IFR3 scheme
   I_IFR = sum(Interference(8:19,:))'; 
   % Bandwidth has been divided into 3 equal parts
   SINR_IFR3 = 10 * log10 (Signal ./ (I_IFR + (Noise_sim * 1/3)));
   Capacity_IFR = (1/3) * BW * log2 (1+SINR_IFR3);

% FFR   
    [FFR] = FFR_Simulation(BW,Signal,usernum,Noise_sim,Interference,xpos,ypos,di_bs_edge);

% TLPC
    [Signal_T] = TLPC_power(xpos,ypos,Ptb,usernum,sigma,di_bs_edge);
    TLPC_Signal = Signal_T ./ (pathloss + shadow);
    [TLPC] = TLPC_result (BW,TLPC_Signal,usernum,Noise_sim,Interference,xpos,ypos,di_bs_edge,sigma);
    
% Network Capacity (Fairless Time & Fairless throughput)
[Network_Capacity_Sim] = n_capacity_sim(Capacity,Capacity_IFR,TLPC,FFR,usernum);

% Plot
[Result_model] = Result_Modelling(Network_Capacity_Model,xpos,ypos,TLPC_M,IFR_M,IFR3_M,FFR_M);
[Result_sim] = Result_Simulation(Network_Capacity_Sim,xpos,ypos,TLPC,SINR,SINR_IFR3,FFR);
close all
[Result_compare_capacity] = Result_Comparison_Capacity (Network_Capacity_Sim,Network_Capacity_Model);
[Result_compare_SINR] = Result_Comparison_SINR (xpos,ypos,SINR,SINR_IFR3,TLPC,IFR_M,IFR3_M,TLPC_M,FFR_M,FFR);
save ofdma_ifr.mat;
%******* end of file *********