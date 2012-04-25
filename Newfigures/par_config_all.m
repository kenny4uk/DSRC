function par_config_all

global Sim App Mac Phy Rate Arf Onoe;
global Pk St Trace_time Trace_rate Trace_sc Trace_fc Trace_fail Trace_col Trace_suc Trace_per Static;

Pstat='constant';           % packet length statistics
%Pstat='uniform';               
%Pstat='exponential';

Mac.m= 3;     % infinite retransmissions are allowed 
Mac.nRetry_max= Mac.m;      % finite number of retransmissions

Tmode = 'DSSS';        % Transmission Mode, takes values in ['FHSS','DSSS','IR']
Amode = 'BASIC';       % Access mode, takes values in ['BASIC','CA']; 
delta = 0;    % propagation delay

HMAC = 272;   % MAC header length (bits)
HPHY = 192;

HEADER = HMAC+HPHY;

DIFS = 50;         %DIFS length [# bits at the basic rate]    
SIFS = 10;         %SIFS length [# bits at the basic rate]

ACK  = 112 + HPHY;      % ACK length
RTS  = 160 + HPHY;       % RTS length
CTS  = 112 + HPHY;       % CTS length 

Phy.sigma= 9e-6;        % slot time
Mac.Wmin=32;               % basic contention window dimension
Mac.Wmax=2^Mac.m* Mac.Wmin;   % number of backoff stages

mu_sec=10^(-6);
p11a.t_slot=9*mu_sec; % 802.11a parameters, time slot in mu second.
p11a.t_sifs=16*mu_sec;
p11a.t_difs=28*mu_sec;
p11a.ack_duration=200*mu_sec; % 30?
p11a.header_duration=20*mu_sec; % 802.11 header
p11a.mretry=4; % max retry.

switch Amode 
case 'BASIC', 
    Phy.Ls_over= HEADER+DIFS+ACK+SIFS; %+2*delta;                           
    Phy.Lc_over= HEADER+DIFS+delta;                                                     
    Phy.Ts_over=p11a.t_sifs+ p11a.t_difs+ p11a.header_duration+ p11a.ack_duration;%  Successful transmission time in seconds, see [1]
    Phy.Tc_over=p11a.t_sifs+ p11a.t_difs+ p11a.header_duration+ p11a.ack_duration;%  Collision time in seconds see [1]
case 'RTS/CTS', 
    Phy.Ls_over= RTS+CTS+HEADER+ACK+3*SIFS+4*delta+DIFS;  %  Successful transmission time in seconds, see [1]
    Phy.Lc_over= RTS+DIFS+delta;                          %  Collision time in seconds see [1]
end;
