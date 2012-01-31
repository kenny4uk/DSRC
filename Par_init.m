function Par_init

  global Sim App Mac Phy Rate Arf Onoe;
  global Pk St Trace_time Trace_rate Trace_sc Trace_fc Trace_fail Trace_col Trace_suc Trace_per Static;

  % Initialization variables
  Static=[];
  Mac.W=Mac.Wmin*ones(1,Sim.n);
  Mac.Bk_cnt=   floor(Mac.Wmin*rand(1,Sim.n));   % congestion window size vector: one row per node
  Sim.ws=   zeros(1,Sim.pk);              % service waiting time matrix: one row per node; one column per packet
  App.birthtime  =   zeros(1,Sim.n);            % birth time vector: time each pending packet started being served
  Mac.nRetry      =  zeros(1,Sim.n);             % number of successive collisions per node

  Rate.curr=Rate.start; 
  Rate.level=Rate.level_start;  
  
  Arf.sc_thr=Arf.sc_min*ones(1,Sim.n); Arf.sc=zeros(1,Sim.n); 
  Arf.fc=zeros(1,Sim.n); Arf.fc_norm=2; Arf.fc_recover=1;
  Arf.Brecover=zeros(1,Sim.n); 
  Arf.inc_timer=100; Rate.timer=Arf.inc_timer*ones(1,Sim.n);

  Onoe.credit=zeros(1,Sim.n);
  Onoe.win_nretry=zeros(1,Sim.n);
  Onoe.win_retried=zeros(1,Sim.n);
  Onoe.win_tx=zeros(1,Sim.n);           % variable for onoe, new pk transmitted in a observation window.
  Onoe.win_tx_all=zeros(1,Sim.n);    % all the transmissions (new and retransmissions).  
  Onoe.win_nretry=zeros(1,Sim.n);
  Onoe.win_retried=zeros(1,Sim.n);
    
  Pk=[];
  Pk.suc= zeros(1,Sim.n);          % total number of sent packets, no packet at the very beginning
  Pk.col= zeros(1,Sim.n);          % total number of collided packets      
  Pk.tx= zeros(1,Sim.n);            % total number of transmission attempts
  Pk.drop= zeros(1,Sim.n);        % total number of packets dropped due to excessive retries.
  Pk.per= zeros(1,Sim.n);
  Pk.power=zeros(1,Sim.n);     % total transmit power consumed for transmitting the packets.
  Pk.bit=zeros(1,Sim.n);
  
  St=[];
  for ii=1:Sim.n
    St.fail(ii)=0;  St.col(ii)=0; St.per(ii)=0;        
  end

  for ii=1:Sim.n
      Trace_time(ii).list=[]; 
      Trace_rate(ii).list=[];
      Trace_sc(ii).list=[];
      Trace_fc(ii).list=[];
      Trace_fail(ii).list=[];
      Trace_col(ii).list=[];
      Trace_per(ii).list=[];
  end
  % Everybody has one packet, thus generate n packets
  Phy.Tc(1:Sim.n)=zeros(1,Sim.n);                                           % time taken by collisions
  Phy.Ts(1:Sim.n)=zeros(1,Sim.n);                                           % time taken by transmissions

return;