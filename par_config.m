function par_config

global Sim App Mac Phy Rate Arf Onoe;
global Pk St Trace_time Trace_rate Trace_sc Trace_fc Trace_fail Trace_col Trace_suc Trace_per Static;

Pstat='constant';           % packet length statistics
%Pstat='uniform';               
%Pstat='exponential';

Lave=500;   % the average packet length used in [2]
%Lave=600;   % the average packet length used in [2]

Mac.m= inf;     % infinite retransmissions are allowed 
Mac.nRetry_max= 400;      % finite number of retransmissions

Tmode = 'DSSS';        % Transmission Mode, takes values in ['FHSS','DSSS','IR']
Amode = 'BASIC';       % Access mode, takes values in ['BASIC','CA']; 
delta = 0;    % propagation delay

HMAC = 272;   % MAC header length (bits)
HPHY = 192;

HEADER = HMAC+HPHY;

DIFS = 50;         %DIFS length [# bits at the basic rate]    
%SIFS = 10;         %SIFS length [# bits at the basic rate]
SIFS = 32;         %SIFS length [# bits at the basic rate]

ACK  = 112 + HPHY;      % ACK length
RTS  = 160 + HPHY;       % RTS length
CTS  = 112 + HPHY;       % CTS length 

%Phy.sigma= 20e-6;        % slot time

Phy.sigma= 13e-6;        % slot time
%Mac.Wmin=64;               % basic contention window dimension
%Mac.m=5;
Mac.Wmin=7;               % basic contention window dimension
Mac.m=225;
AIFS=6;
%Mac.Wmin=7;               % basic contention window dimension
%Mac.m=15;
%AIFS=6;
Mac.Wmax=Mac.m*Mac.Wmin;   % number of backoff stages



switch Amode 
case 'BASIC', 
    Phy.Ls_over= HEADER+DIFS+ACK+SIFS+2*delta;                           %  Successful transmission time in seconds, see [1]
    Phy.Lc_over= HEADER+DIFS+delta;                                                     %  Collision time in seconds see [1]
case 'RTS/CTS', 
    Phy.Ls_over= RTS+CTS+HEADER+ACK+3*SIFS+4*delta+DIFS;  %  Successful transmission time in seconds, see [1]
    Phy.Lc_over= RTS+DIFS+delta;                                                              %  Collision time in seconds see [1]
end;
