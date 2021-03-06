
%   SIM80211  IEEE802 Simulator: a one hop network
%   The script simulates a simplified model for a radio network based on the IEEE 802.11 standard operating in DCF modality.
clear all;  close all;   clc;         % clear all workspace

global Sim App Mac Phy Rate Arf Onoe Markov Pk Sstats Sample;
global St Trace_time Trace_rate Trace_sc Trace_fc Trace_fail Trace_col Trace_suc Trace_per Static;
global Trace_sample;
global matrix_tranz  matrix_tranz_steady vector_startrrate_prob vector_finalrate_prob;
    
rand('state',sum(100*clock)); % randomize properly (even when compiled)
% Input Parameters should be stored somewhere 
warning off;           % some annoying, but harmless warnings

hh=datevec(now);

par_config_all;
ap(1)=150;
ap(2)=0;
Sim.iternum0=4; % number of iterations for a fixed simulation scenario.
Sim.iternum1=4; % number of iterations for a fixed simulation scenario.
Sim.pk_basic=1500;     % Total number of packets to be successfully sent per simulation
Sim.node_set=50;     
sNode=length(Sim.node_set);
 spdavg_set=[20 40 60 80 100 120];
sSpd =length(spdavg_set);
% spd_set = zeros(sSpd, sNode);
% for i=1:sSpd
%     for j=1:sNode
%         spd_set=rand(4,2)*spdavg_set*0.5+spdavg_set*0.75;% This is a 
%     %normal speed distribution
% %   spd_set_avg=mean(spd_set(i));
%     end
%  end

Sim.cal_aarf=1; 
% Sim.cal_onoe=1;
% Sim.debug_onoe_sim=0;
% Sim.debug_onoe_mod=0;
Sim.cal_sample=1;
Sim.debug_sample_sim=1;

matname= [num2str(hh(1)) '-' num2str(hh(2)) '-'  num2str(hh(3)) '-'  num2str(hh(4)) '-'  num2str(hh(5))  '-linkadapt'] ;
epsname=matname;
bl_matsave=1;
bl_epssave=1; 

App.lave=1500;      % the average packet length in bytes 

% SNR and PER 
Phy.snr_set=[30];
sSnr=length(Phy.snr_set);

Phy.rate_mode=[1 3 5 6 7 9 11 13]; 
% Phy.rate_mode=[5]; 
% Phy.power=10^5; % normalized transmit power, 1 Watt.
Phy.power=40*10^(-3); % normalized transmit power in Watt.
Rate.all=[3 4.5 6 9 12 18 24 27]*1e6;
Rate.set=Rate.all;
sRset=length(Rate.set);
Rate.num=sRset;
Rate.min=min(Rate.set); Rate.max=max(Rate.set);
Rate.level_max=sRset;

% Startrate_mode=[3 5]; % 0: random; >0: fixed data rate
Startrate_mode=[5]; % 0: random; >0: fixed data rate
sStart=length(Startrate_mode);

Arf.sc_min=10; Arf.sc_max=10; Arf.sc_multi=2; 
Onoe.ratedec_retthr=0.5;           % 1 default           % variable for onoe, threshold to decrease rate based on retries per pk in a observation window.
Onoe.rateinc_creditthr=10;      % variable for onoe, thresh on the credits to increase rate.
Onoe.creditinc_retthr=0.1;      % variable for onoe, thresh on percentage of pks requiring retry to increase or decrease a credit.
Onoe.period=1;                   % observation time: 1 sec in default.
Onoe.mod_numpk_mode=2; 
Onoe.chn_busy=1;
Onoe.mod_coeff=5;      
Onoe.mod_numpk_init=30;
% Basic_rate*2*Chn_busy*Onoe.period/App.lave/8/One_user: basic number of packets can be tx in a Onoe.period. Chn_busy set to 0.7; 
Onoe.mod_power_num=100;

% Onoe.period_set=[1 0.5 0.2];
Onoe.period_set=[0.2];
sPeriodset=length(Onoe.period_set);

for idx_spd=1:sSpd
for idx_node=1:sNode
for idx_snr=1:sSnr
for idx_start=1:sStart 
for idx_period=1:sPeriodset
Onoe.period=Onoe.period_set(idx_period);
Sim.n=Sim.node_set(idx_node); % number of nodes in the BSS
Onoe.chn_busy_small=1;
if Sim.n==1; Onoe.chn_busy_small=0.7; elseif Sim.n==2; Onoe.chn_busy_small=0.8; elseif Sim.n==3;  Onoe.chn_busy_small=0.85; end;
Onoe.mod_numpk_init=ceil(6*10^6*Onoe.chn_busy*Onoe.chn_busy_small*Onoe.mod_coeff*Onoe.period/(App.lave+Phy.Ls_over)/8/Sim.n); 
Onoe.mod_numpk_new_init= Onoe.mod_numpk_init;
Sim.pk=ceil(sqrt(Sim.n)*Sim.pk_basic);     % Total number of packets sent per simulation    
for ii=1:Rate.num
Onoe.mod_numpk_rate(ii)=ceil(Rate.set(ii)*Onoe.chn_busy*Onoe.chn_busy_small*Onoe.period/(App.lave+Phy.Ls_over)/8/Sim.n); 
Onoe.mod_numpk= Onoe.mod_numpk_rate;    
Onoe.mod_numpk_new= Onoe.mod_numpk_rate;          
end

Phy.snr=Phy.snr_set(idx_snr);
Phy.snr_per= snr_per(Phy.snr, Phy.rate_mode);

  % if Startrate_mode(idx_start)>0; iter_num=1; else; iter_num= Sim.iternum; end;
  if Startrate_mode(idx_start)>0; iter_num=Sim.iternum1; else; iter_num= Sim.iternum0; end;  

 thr_sample_iter=zeros(1, iter_num);
 eneff_sample_iter=zeros(1,iter_num);
 col_sample_iter=zeros(1, iter_num);
 suc_sample_iter=zeros(1, iter_num);%   thr_aarf_iter=zeros(1, iter_num);
 eneff_aarf_iter=zeros(1,iter_num);
 thr_aarf_iter=zeros(1, iter_num);
 col_aarf_iter=zeros(1, iter_num);
 suc_aarf_iter=zeros(1, iter_num);
 pk_tx_aarf_iter=zeros(1, iter_num);
 pk_col_aarf_iter=zeros(1, iter_num);
 pk_suc_aarf_iter=zeros(1, iter_num);         
 pk_per_aarf_iter=zeros(1, iter_num);          
 
 pk_tx_sample_iter=zeros(1, iter_num);
 pk_col_sample_iter=zeros(1, iter_num);
 pk_suc_sample_iter=zeros(1, iter_num);     
 pk_per_sample_iter=zeros(1, iter_num);                  

for idx_iter=1: iter_num
    disp('---------------------------------------------------------------');
   curr_time=datevec(now);
  disp(['current time is: ' num2str(curr_time(2)) '-'  num2str(curr_time(3)) '-'  num2str(curr_time(4)) '-'  num2str(curr_time(5))]);
  disp(['number of packets to be simulated: ' num2str(Sim.pk)]); 
 if Startrate_mode(idx_start)==0
  Rate.level_start= max(1, ceil(rand(1,Sim.n)*sRset));            
   Rate.start=Rate.set(Rate.level_start);  
          Rate.startrate_prob=ones(1,Rate.num)/Rate.num;          
      else
       Rate.level_start= Startrate_mode(idx_start)* ones(1,Sim.n);
       Rate.start=Rate.set(Rate.level_start);  
       Rate.startrate_prob=zeros(1,Rate.num); Rate.startrate_prob(Startrate_mode(idx_start))=1;
  end
           
      if Sim.cal_sample
        if idx_start>1 | idx_period>1; continue; end;
        
          disp('---------------------------------------------------------------')
%           curr_time=datevec(now);
%           disp(['current time is: ' num2str(curr_time(2)) '-'  num2str(curr_time(3)) '-'  num2str(curr_time(4)) '-'  num2str(curr_time(5))]);
          disp(['Simulation Sample: n=',num2str(Sim.n),', snr=',num2str(Phy.snr) ', startrate=' num2str(Startrate_mode(idx_start)) ...
              ' is running iteration ' num2str(idx_iter) '. Please be patient...']);  % Just in case
for ii=1:Sim.n; 
Trace_sample(ii).time=[]; Trace_sample(ii).rate=[]; Trace_sample(ii).fail=[];
Trace_sample(ii).suc=[]; Trace_sample(ii).col=[]; Trace_sample(ii).per=[]; 
end;
%          
alg_sample(spdavg_set(idx_spd),length(Sim.node_set));
thr_sample_iter(idx_iter)=Static.through;
eneff_sample_iter(idx_iter)=Static.energyeff;          
col_sample_iter(idx_iter)=Static.pk_col;
suc_sample_iter(idx_iter)=Static.pk_suc;
per_sample_iter(idx_iter)=Static.pk_per;          
pk_tx_sample_iter(idx_iter)= mean(Pk.tx);
pk_col_sample_iter(idx_iter)=  mean(Pk.col);
pk_suc_sample_iter(idx_iter)=  mean(Pk.suc);          
 pk_per_sampe_iter(idx_iter)=  mean(Pk.per);
 
      Static
 end
       if Sim.cal_aarf
          disp('---------------------------------------------------------------')
          disp(['Simulation AARF: n=',num2str(Sim.n),', snr=',num2str(Phy.snr) ', startrate=' num2str(Startrate_mode(idx_start)) ...
              ' is running iteration ' num2str(idx_iter) '. Please be patient...']);  % Just in case
alg_aarf(spdavg_set(idx_spd),Sim.node_set);
thr_aarf_iter(idx_iter)=Static.through;
eneff_aarf_iter(idx_iter)=Static.energyeff;
col_aarf_iter(idx_iter)=Static.pk_col;
suc_aarf_iter(idx_iter)=Static.pk_suc;
pk_tx_aarf_iter(idx_iter)=  mean(Pk.tx);
pk_col_aarf_iter(idx_iter)=  mean(Pk.col);
pk_suc_aarf_iter(idx_iter)=  mean(Pk.suc);          
pk_per_aarf_iter(idx_iter)=  mean(Pk.per);
       
     Static        
end
end % for idx_iter

if Sim.cal_sample
thr_sample(idx_spd,idx_node,idx_snr,idx_start,idx_period)= mean(thr_sample_iter);
eneff_sample(idx_spd,idx_node,idx_snr,idx_start,idx_period)= mean(eneff_sample_iter);      
col_sample(idx_spd,idx_node,idx_snr,idx_start,idx_period)= mean(col_sample_iter);
suc_sample(idx_spd,idx_node,idx_snr,idx_start,idx_period)= mean(suc_sample_iter);
per_sample(idx_spd,idx_node,idx_snr,idx_start,idx_period)= mean(per_sample_iter);
      
pk_tx_sample(idx_spd,idx_node,idx_snr,idx_start,idx_period)=mean(pk_tx_sample_iter); 
pk_col_sample(idx_spd,idx_node,idx_snr,idx_start,idx_period)=mean(pk_col_sample_iter); 
pk_suc_sample(idx_spd,idx_node,idx_snr,idx_start,idx_period)=mean(pk_suc_sample_iter); 
pk_per_sample(idx_spd,idx_node,idx_snr,idx_start,idx_period)=mean(pk_per_sample_iter);       
      
thr_sample_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)= mean(thr_sample_iter);
eneff_sample_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)= mean(eneff_sample_iter);      
col_sample_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)= mean(col_sample_iter);
suc_sample_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)= mean(suc_sample_iter);
per_sample_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)= mean(per_sample_iter);
      
pk_tx_sample_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)=mean(pk_tx_sample_iter); 
pk_col_sample_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)=mean(pk_col_sample_iter); 
pk_suc_sample_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)=mean(pk_suc_sample_iter); 
pk_per_sample_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)=mean(pk_per_sample_iter);  

 % disp('---------------------------------------------------------------');
disp(['Simulation Sample: n=',num2str(Sim.n),', snr=',num2str(Phy.snr) ', startrate=' num2str(Startrate_mode(idx_start)) ...
    ', throughput=', num2str(mean(thr_sample_iter))]);  % Just in case
end
   
if Sim.cal_aarf
thr_aarf(idx_spd,idx_node,idx_snr,idx_start,idx_period)= mean(thr_aarf_iter);
eneff_aarf(idx_spd,idx_node,idx_snr,idx_start,idx_period)= mean(eneff_aarf_iter);      
col_aarf(idx_spd,idx_node,idx_snr,idx_start,idx_period)= mean(col_aarf_iter);
suc_aarf(idx_spd,idx_node,idx_snr,idx_start,idx_period)= mean(suc_aarf_iter);

pk_tx_aarf(idx_spd,idx_node,idx_snr,idx_start,idx_period)=mean(pk_tx_aarf_iter); 
pk_col_aarf(idx_spd,idx_node,idx_snr,idx_start,idx_period)=mean(pk_col_aarf_iter); 
pk_suc_aarf(idx_spd,idx_node,idx_snr,idx_start,idx_period)=mean(pk_suc_aarf_iter); 
pk_per_aarf(idx_spd,idx_node,idx_snr,idx_start,idx_period)=mean(pk_per_aarf_iter);       
      
thr_aarf_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)= std(thr_aarf_iter);
eneff_aarf_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)= std(eneff_aarf_iter);      
col_aarf_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)= std(col_aarf_iter);
suc_aarf_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)= std(suc_aarf_iter);

pk_tx_aarf_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)=std(pk_tx_aarf_iter); 
pk_col_aarf_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)=std(pk_col_aarf_iter); 
pk_suc_aarf_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)=std(pk_suc_aarf_iter); 
pk_per_aarf_std(idx_spd,idx_node,idx_snr,idx_start,idx_period)=std(pk_per_aarf_iter);       
       
% disp('---------------------------------------------------------------');
disp(['Simulation AARF: n=',num2str(Sim.n),', snr=',num2str(Phy.snr) ', startrate=' num2str(Startrate_mode(idx_start)) ...
          ', throughput=', num2str(mean(thr_aarf_iter))]);  % Just in case
end

end %for idx_period
end % for idx_start
end% for idx_snr
end % for idx_node;
end % for idx_spd
 

% save(datafile,'n','ws','Pksuc','Sim.time','mws','pcoll','Pkcol','Pktx','Amode','Pstat','App.lave','t_E','pws_E','Fws_E');

curr_time=datevec(now);
disp(['current time is: ' num2str(curr_time(2)) '-'  num2str(curr_time(3)) '-'  num2str(curr_time(4)) '-'  num2str(curr_time(5))]);
disp('Done, bye.');
disp('---------------------------------------------------------------');

if bl_matsave==1;     eval( ['save ' matname]); end;
linkadaptall;
