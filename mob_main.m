%   SIM80211  IEEE802 Simulator: a one hop network
%   The script simulates a simplified model for a radio network based on the IEEE 802.11 standard operating in DCF modality.
clear all;  close all;            % clear all workspace

global Sim App Mac Phy Rate Arf Onoe Markov Pk;
global St Trace_time Trace_rate Trace_sc Trace_fc Trace_fail Trace_col Trace_suc Trace_per mobile;
    
rand('state',sum(100*clock)); % randomize properly (even when compiled)
% Input Parameters should be stored somewhere 
warning off;           % some annoying, but harmless warnings

hh=datevec(now);

par_config;

Sim.iternum0=4; % number of iterations for a fixed simulation scenario.
Sim.iternum1=4; % number of iterations for a fixed simulation scenario.
%Sim.node_set=[1:2:15];
Sim.node_set=[1:10];

      %Sim.node_set=[1:10:30];
%Sim.node_set=[1:10:200];
sNode=length(Sim.node_set);
Sim.pk_basic=500;     % Total number of packets to be successfully sent per simulation
Sim.cal_aarf=1; 
Sim.cal_onoe=1;
Sim.debug_onoe_sim=0;
Sim.debug_onoe_mod=0;
x_max=1000;
v=ones(1,10)*50+rand(1,10)*20;
      t=10;
      old_pos=rand(1,10)*x_max;
         new_pos=p_mob(t, v, old_pos);
          for i=1:sNode
          old_pos=new_pos;
      end
matname= [num2str(hh(1)) '-' num2str(hh(2)) '-'  num2str(hh(3)) '-'  num2str(hh(4)) '-'  num2str(hh(5))  '-linkadaptmob'] ;
epsname=matname;
bl_matsave=1;
bl_epssave=1; 

App.lave=1000;      % the average packet length

% SNR and PER 
%Phy.snr_set=[15:10:25];
%Phy.snr_set=[10 15 25 35];
Phy.snr_set=[5 8 10 15];
sSnr=length(Phy.snr_set);

Phy.rate_mode=[1 3 5 6 7 ]; 
Phy.power=10^5; % normalized transmit power, 1 Watt.
%dist = (xpos.^2 + ypos.^2) .^ (1/2);

Rate.all=[3 4.5 12 24 27]*1e6; 
Rate.set=Rate.all;
sRset=length(Rate.set);
Rate.num=sRset;
Rate.min=min(Rate.set); Rate.max=max(Rate.set);
Rate.level_max=sRset;

Startrate_mode=[3 5]; % 0: random; >0: fixed data rate
Startrate_mode=[4]; % 0: random; >0: fixed data rate
sStart=length(Startrate_mode);

Arf.sc_min=10; Arf.sc_max=10; Arf.sc_multi=2; 
Onoe.ratedec_retthr=0.5;           % 1 default           % variable for onoe, threshold to decrease rate based on retries per pk in a observation window.
Onoe.rateinc_creditthr=10;      % variable for onoe, thresh on the credits to increase rate.
Onoe.creditinc_retthr=0.1;      % variable for onoe, thresh on percentage of pks requiring retry to increase or decrease a credit.
Onoe.period=1;                         % observation time: 1 sec in defaul.
Onoe.chn_busy=1;
Onoe.period_set=[0.2];
% Onoe.period_set=[1 0.5 0.2];
sPeriodset=length(Onoe.period_set);
for idx_period=1:sPeriodset
for idx_node=1:sNode
for idx_snr=1:sSnr    
for idx_start=1:sStart    

    Onoe.period=Onoe.period_set(idx_period);
     Sim.n=Sim.node_set(idx_node);                      % number of nodes in the BSS
    Onoe.chn_busy_small=1;
    Sim.pk=ceil(sqrt(Sim.n)*Sim.pk_basic);     % Total number of packets sent per simulation    
  
    Phy.snr=Phy.snr_set(idx_snr);
    Phy.snr_per= snr_per(Phy.snr, Phy.rate_mode);

  if Startrate_mode(idx_start)>0; iter_num=Sim.iternum1; else; iter_num= Sim.iternum0; end;  
  thr_aarf_iter=zeros(1, iter_num);
  eneff_aarf_iter=zeros(1,iter_num);
  col_aarf_iter=zeros(1, iter_num);
  suc_aarf_iter=zeros(1, iter_num);
  delay_aarf_iter=zeros(1, iter_num);
  pk_tx_aarf_iter=zeros(1, iter_num);
  pk_col_aarf_iter=zeros(1, iter_num);
  pk_suc_aarf_iter=zeros(1, iter_num);         
  pk_per_aarf_iter=zeros(1, iter_num); 
  pk_p_loss_aarf_iter=zeros(1, iter_num);
  %pk_delay_aarf_iter=zeros(1, iter_num); 
  
  
  thr_onoe_iter=zeros(1, iter_num);
  eneff_onoe_iter=zeros(1,iter_num);
  col_onoe_iter=zeros(1, iter_num);
  suc_onoe_iter=zeros(1, iter_num);
  delay_onoe_iter=zeros(1, iter_num);
  pk_tx_onoe_iter=zeros(1, iter_num);
  pk_col_onoe_iter=zeros(1, iter_num);
  pk_suc_onoe_iter=zeros(1, iter_num);     
  pk_per_onoe_iter=zeros(1, iter_num); 
  pk_p_loss_onoe_iter=zeros(1, iter_num);
  %pk_delay_onoe_iter=zeros(1, iter_num); 
  
   
      
  for idx_iter=1: iter_num
      disp('---------------------------------------------------------------');
      curr_time=datevec(now);
      disp(['sim.time is: ' num2str(curr_time(2)) '-'  num2str(curr_time(3)) '-'  num2str(curr_time(4)) '-'  num2str(curr_time(5))]);
      disp(['number of packets to be simulated: ' num2str(Sim.pk)]); 
      if Startrate_mode(idx_start)==0
          Rate.level_start= max(1, ceil(rand(1,Sim.n)*sRset));            
          Rate.start=Rate.set(Rate.level_sstart);  
          Rate.startrate_prob=ones(1,Rate.num)/Rate.num;          
      else
          Rate.level_start= Startrate_mode(idx_start)* ones(1,Sim.n);
          Rate.start=Rate.set(Rate.level_start);  
          Rate.startrate_prob=zeros(1,Rate.num); Rate.startrate_prob(Startrate_mode(idx_start))=1;
      end
      

      if Sim.cal_aarf
          disp('---------------------------------------------------------------')
          disp(['Simulation AARF: n=',num2str(Sim.n),', snr=',num2str(Phy.snr) ', startrate=' num2str(Startrate_mode(idx_start)) ...
              ' is running iteration ' num2str(idx_iter) '. Please be patient...']);  % Just in case
         alg_aarf1();
       v=ones(1,10)*50+rand(1,10)*20;
      t=10;
      old_pos=rand(1,10)*x_max;
   new_pos=p_mob(t, v, old_pos);
           thr_aarf_iter(idx_iter)=mobile.through;
          eneff_aarf_iter(idx_iter)=mobile.energyeff;
          col_aarf_iter(idx_iter)=mobile.pk_col;
          suc_aarf_iter(idx_iter)=mobile.pk_suc;
          %delay_aarf_iter(idx_iter)=mobile.pk_delay;
          pk_tx_aarf_iter(idx_iter)=  mean(Pk.tx);
          pk_col_aarf_iter(idx_iter)=  mean(Pk.col);
          pk_suc_aarf_iter(idx_iter)=  mean(Pk.suc);          
          pk_per_aarf_iter(idx_iter)=  mean(Pk.per);
          %pk_delay_aarf_iter(idx_iter)=  mean(Pk.delay);
                   
          
          mobile         
      end

      if Sim.cal_onoe
          disp('---------------------------------------------------------------')
          disp(['Simulation ONOE: n=',num2str(Sim.n),', snr=',num2str(Phy.snr) ', startrate=' num2str(Startrate_mode(idx_start)) ...
              ' is running iteration ' num2str(idx_iter) '. Please be patient...']);  % Just in case
alg_onoe1();
     v=ones(1,10)*50+rand(1,10)*20;
      t=10;
      old_pos=rand(1,10)*x_max;
   new_pos=p_mob(t, v, old_pos);
          thr_onoe_iter(idx_iter)=mobile.through;
         eneff_onoe_iter(idx_iter)=mobile.energyeff;          
          col_onoe_iter(idx_iter)=mobile.pk_col;
          suc_onoe_iter(idx_iter)=mobile.pk_suc;
          per_onoe_iter(idx_iter)=mobile.pk_per; 
         %delay_onoe_iter(idx_iter)=mobile.pk_delay;
          pk_tx_onoe_iter(idx_iter)= mean(Pk.tx);
          pk_col_onoe_iter(idx_iter)=  mean(Pk.col);
          pk_suc_onoe_iter(idx_iter)=  mean(Pk.suc);          
          pk_per_onoe_iter(idx_iter)=  mean(Pk.per); 
          %pk_delay_onoe_iter(idx_iter)=  mean(Pk.delay); 

          mobile
      end
      
  end % for idx_iter

  if Sim.cal_aarf
      v=ones(1,10)*50+rand(1,10)*20;
      t=10;
      old_pos=rand(1,10)*x_max;
   new_pos=p_mob(t, v, old_pos);
      thr_aarf(idx_node, idx_snr, idx_start)= mean(thr_aarf_iter);
      eneff_aarf(idx_node, idx_snr, idx_period, idx_start)= mean(eneff_aarf_iter);      
      col_aarf(idx_node, idx_snr, idx_period, idx_start)= mean(col_aarf_iter);
      suc_aarf(idx_node, idx_snr, idx_period, idx_start)= mean(suc_aarf_iter);
      %delay_aarf(idx_node, idx_snr, idx_period, idx_start)= mean(delay_aarf_iter);

      pk_tx_aarf(idx_node, idx_snr, idx_period, idx_start)=mean(pk_tx_aarf_iter); 
      pk_col_aarf(idx_node, idx_snr, idx_period, idx_start)=mean(pk_col_aarf_iter); 
      pk_suc_aarf(idx_node, idx_snr, idx_period, idx_start)=mean(pk_suc_aarf_iter); 
     per_aarf(idx_node, idx_snr, idx_period, idx_start)=mean(pk_per_aarf_iter); 
      %pk_delay_aarf(idx_node, idx_snr, idx_period, idx_start)=mean(pk_delay_aarf_iter); 
             
             
            
      thr_aarf_std(idx_node, idx_snr, idx_start)= std(thr_aarf_iter);
      eneff_aarf_std(idx_node, idx_snr, idx_period, idx_start)= std(eneff_aarf_iter);      
      col_aarf_std(idx_node, idx_snr, idx_period, idx_start)= std(col_aarf_iter);
      suc_aarf_std(idx_node, idx_snr, idx_period, idx_start)= std(suc_aarf_iter);
      %delay_aarf_std(idx_node, idx_snr, idx_period, idx_start)= std(delay_aarf_iter);

      pk_tx_aarf_std(idx_node, idx_snr, idx_period, idx_start)=std(pk_tx_aarf_iter); 
      pk_col_aarf_std(idx_node, idx_snr, idx_period, idx_start)=std(pk_col_aarf_iter); 
      pk_suc_aarf_std(idx_node, idx_snr, idx_period, idx_start)=std(pk_suc_aarf_iter); 
      per_aarf_std(idx_node, idx_snr, idx_period, idx_start)=std(pk_per_aarf_iter); 
      %pk_delay_aarf_std(idx_node, idx_snr, idx_period, idx_start)=std(pk_delay_aarf_iter); 
         
            
      % disp('---------------------------------------------------------------');
      disp(['Simulation AARF: n=',num2str(Sim.n),', snr=',num2str(Phy.snr) ', startrate=' num2str(Startrate_mode(idx_start)) ...
          ', throughput=', num2str(mean(thr_aarf_iter))]);  % Just in case
  end
  
  if Sim.cal_onoe
     v=ones(1,10)*50+rand(1,10)*20;
      t=10;
      old_pos=rand(1,10)*x_max;
   new_pos=p_mob(t, v, old_pos);
      thr_onoe(idx_node, idx_snr, idx_period, idx_start)= mean(thr_onoe_iter);
      eneff_onoe(idx_node, idx_snr, idx_period, idx_start)= mean(eneff_onoe_iter);      
      col_onoe(idx_node, idx_snr, idx_period, idx_start)= mean(col_onoe_iter);
      suc_onoe(idx_node, idx_snr, idx_period, idx_start)= mean(suc_onoe_iter);
      per_onoe(idx_node, idx_snr, idx_period, idx_start)= mean(per_onoe_iter);
      %delay_onoe(idx_node, idx_snr, idx_period, idx_start)= mean(delay_onoe_iter);
      
      pk_tx_onoe(idx_node, idx_snr, idx_period, idx_start)=mean(pk_tx_onoe_iter); 
      pk_col_onoe(idx_node, idx_snr, idx_period, idx_start)=mean(pk_col_onoe_iter); 
      pk_suc_onoe(idx_node, idx_snr, idx_period, idx_start)=mean(pk_suc_onoe_iter); 
      pk_per_onoe(idx_node, idx_snr, idx_period, idx_start)=mean(pk_per_onoe_iter); 
      %pk_delay_onoe(idx_node, idx_snr, idx_period, idx_start)=mean(pk_delay_onoe_iter); 
            
      
      
      thr_onoe_std(idx_node, idx_snr, idx_period, idx_start)= mean(thr_onoe_iter);
      eneff_onoe_std(idx_node, idx_snr, idx_period, idx_start)= mean(eneff_onoe_iter);      
      col_onoe_std(idx_node, idx_snr, idx_period, idx_start)= mean(col_onoe_iter);
      suc_onoe_std(idx_node, idx_snr, idx_period, idx_start)= mean(suc_onoe_iter);
      per_onoe_std(idx_node, idx_snr, idx_period, idx_start)= mean(per_onoe_iter);
      %delay_onoe_std(idx_node, idx_snr, idx_period, idx_start)= mean(delay_onoe_iter);
      
      pk_tx_onoe_std(idx_node, idx_snr, idx_period, idx_start)=mean(pk_tx_onoe_iter); 
      pk_col_onoe_std(idx_node, idx_snr, idx_period, idx_start)=mean(pk_col_onoe_iter); 
      pk_suc_onoe_std(idx_node, idx_snr, idx_period, idx_start)=mean(pk_suc_onoe_iter); 
      pk_per_onoe_std(idx_node, idx_snr, idx_period, idx_start)=mean(pk_per_onoe_iter);
      %pk_delay_onoe_std(idx_node, idx_snr, idx_period, idx_start)=mean(pk_delay_onoe_iter);  
           
            
      % disp('---------------------------------------------------------------');
      disp(['Simulation ONOE: n=',num2str(Sim.n),', snr=',num2str(Phy.snr) ', startrate=' num2str(Startrate_mode(idx_start)) ...
          ', throughput=', num2str(mean(thr_onoe_iter))]);  % Just in case
  end
  
  
end % for idx_start
end % for idx_snr  
end % for idx_node
end % for idx_period;
% save(datafile,'n','ws','Pksuc','Sim.time','mws','pcoll','Pkcol','Pktx','Amode','Pstat','App.lave','t_E','pws_E','Fws_E');

curr_time=datevec(now);
disp(['current time is: ' num2str(curr_time(2)) '-'  num2str(curr_time(3)) '-'  num2str(curr_time(4)) '-'  num2str(curr_time(5))]);
disp('Done, bye.');
disp('---------------------------------------------------------------');

if bl_matsave==1;     eval( ['save ' matname]); end;

linkadaptmob