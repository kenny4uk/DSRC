function alg_aarf(speed)

global Sim App Mac Phy Rate Arf Onoe Markov Pk;
global St Trace_time Trace_rate Trace_sc Trace_fc Trace_fail Trace_col Trace_suc Trace_per Static;
 global sNode;
par_init;
%Initialization
Sim.tstart = clock;
Sim.time = 0:0;  
t=0; %simulation starts at this time
x_max=1000;% maximum range within which nodes can transmit
 v= 0;% speed of vehicle at the very begining
old_pos= 0;
Phy.Ts=0;
while sum([Pk.suc])<=Sim.pk,
    if 0
                  Sim.time
                  ii
                  Rate
                  Onoe
                  pause;    
              end
    if (rem(sum([Pk.tx]),10000)==0) & 0,
        deltaT = etime(clock,Sim.tstart);
        disp(['Expected time to conclusion: ',num2str(round(deltaT/sum([Pk.suc])*(Sim.pk- sum([Pk.suc])))),' sec...'])
    end; % if rem...
    
dt_temp = min(Mac.Bk_cnt);% Txnode = IDs of the nodes that attempt the transmission
 Phy.Ts=0.001;
%  v= 20;
%  v=rand(1,20)*70;
old_pos= rand(1,sNode)*1000;
Txnode = find(Mac.Bk_cnt==dt_temp);% find the time of the first transmission attempt 
Mac.Bk_cnt=Mac.Bk_cnt-dt_temp-1;% all backoff counters are decremented 
Sim.time= Sim.time+ dt_temp*Phy.sigma;% update the simulation time accordingly
w =p_mob(Phy.Ts,v,old_pos,x_max);
sTxnode = length(Txnode);% sTxnode = number of simultaneously transmitting nodes
Pk.tx(Txnode)=Pk.tx(Txnode)+1;
old_pos=w;
% spdavg_set=v;
speed=v;
 % we distringuish two possible events at this slot time 
if Txnode>1% if sTxnode > 1 => Collision occurs
St.fail(Txnode)=1; 
St.col(Txnode)=1;
Pk.col(Txnode) = Pk.col(Txnode)+ 1;% total number of collided packets is updated;
Phy.Tc(Txnode)=(Phy.Lc_over+ 8*App.lave)./Rate.curr(Txnode);
Pk.power(Txnode)=Pk.power(Txnode)+Phy.Tc(Txnode)*Phy.power;
maxTc=max(Phy.Tc(Txnode)); % we need to know how long the collision is going to last 
Sim.time= Sim.time + maxTc;% and update the simulation time subsequently

Mac.nRetry(Txnode)= Mac.nRetry(Txnode)+1;% Add a collision to the number of successive collisions experienced by colliding packets
              
 elseif Txnode==1
        
 % process BER and check if pkt can be accepted due to ber.
 Bper=0; 
 Per_temp= Phy.snr_per(Rate.level(Txnode));
 if rand()<Per_temp; Bper=1; end;
 if Bper==1                     
St.fail(Txnode)=1; 
St.col(Txnode)=0;
St.per(Txnode)=1; 
Phy.Ts=0.002;
% v=30;
%  v=rand(1,20)*70;
w =p_mob(Phy.Ts,v,old_pos,x_max);
Pk.per(Txnode)=Pk.per(Txnode)+1;
old_pos=w;
Phy.Ts(Txnode)=(Phy.Lc_over+8*App.lave)./Rate.curr(Txnode);% how long does it take to transmit it with success? 
Pk.power(Txnode)=Pk.power(Txnode)+Phy.Tc(Txnode)*Phy.power;  

Sim.time = Sim.time + Phy.Ts(Txnode);% update the simulation time 
% spdavg_set=v;
speed=v;
                    
%-----------------------------------------------------------------
 else   % if sTxnode == 1 & Bper==0 => Successfull transmission occurs
St.fail(Txnode)=0; 
St.col(Txnode)=0;
St.per(Txnode)=0;        
Pk.suc(Txnode) = Pk.suc(Txnode)+1;% update number of sent packets  
Phy.Ts=0.003;
%  v= 40;
%  v=rand(1,20)*70;
w =p_mob(Phy.Ts,v,old_pos,x_max);
old_pos=w;
Phy.Ts(Txnode)=(Phy.Ls_over+8*App.lave)./Rate.curr(Txnode);% how long does it take to transmit it with success? 
Pk.bit(Txnode)=Pk.bit(Txnode)+8*App.lave;
Pk.power(Txnode)=Pk.power(Txnode)+Phy.Ts(Txnode)*Phy.power;          
Phy.Ts=0.004;   
%  v= 50;
%  v=rand(1,20)*70;
w =p_mob(Phy.Ts,v,old_pos,x_max);
old_pos=w;
Sim.time = Sim.time + Phy.Ts(Txnode);% update the simulation time 
% spdavg_set=v;
speed=v;

%ws(Pksuc) = Sim.time-birthtime(Txnode); % compute the service time of this packet 
App.birthtime(Txnode) = Sim.time;  % and store the time this packet entered service

 end; % if Bper
end % if sTxnode>1
for ii=1:sTxnode
      iTx=Txnode(ii);
      Rate.timer(iTx)=Rate.timer(iTx)-1;
      Trace_rate(iTx).list=[Trace_rate(iTx).list Rate.level(iTx)];
      Trace_sc(iTx).list=[Trace_sc(iTx).list Arf.sc(iTx)];
      Trace_fc(iTx).list=[Trace_fc(iTx).list Arf.fc(iTx)];
      Trace_fail(iTx).list=[Trace_fail(iTx).list St.fail(iTx)];
      Trace_col(iTx).list=[Trace_col(iTx).list St.col(iTx)];
      Trace_per(iTx).list=[Trace_per(iTx).list St.per(iTx)];
 check_more_pk=0;        
 if St.fail(iTx)==0
        Arf.sc(iTx)=min(Arf.sc(iTx)+1, Arf.sc_thr(iTx));
        Arf.fc(iTx)=0;
        if Rate.level(iTx)<Rate.level_max & (Arf.sc(iTx)==Arf.sc_thr(iTx) | Rate.timer(iTx)==0)
          Rate.level(iTx)=Rate.level(iTx)+1;
          Rate.curr(iTx)=Rate.set(Rate.level(iTx)); 
          Arf.Brecover(iTx)=1; 
          Arf.sc(iTx)=0; 
          Rate.timer(iTx)=Arf.inc_timer;
                 else
if Arf.Brecover(iTx)==1
    Arf.sc_thr(iTx)=Arf.sc_min;
end
Arf.Brecover(iTx)=0;
end % Rate.curr<Rate.max
check_more_pk=1;
 else % if St_tx(Txnode...
    Mac.nRetry(iTx)=Mac.nRetry(iTx)+1;
     %old_pos=new_pos;
Arf.sc(iTx)=0;
Arf.fc(iTx)=min(Arf.fc(iTx)+1,Arf.fc_norm);
 
if Arf.Brecover(iTx)==1
Rate.level(iTx)=Rate.level(iTx)-1;
Rate.curr(iTx)=Rate.set(Rate.level(iTx));
Arf.fc(iTx)=0;
Arf.sc_thr(iTx)=min(2*Arf.sc_thr(iTx), Arf.sc_max);
Rate.timer(iTx)=Arf.inc_timer;
 elseif Arf.Brecover(iTx)==0
 if Rate.level(iTx)>1 & Arf.fc(iTx)==Arf.fc_norm
Rate.level(iTx)=Rate.level(iTx)-1;
Rate.curr(iTx)=Rate.set(Rate.level(iTx));
Arf.sc_thr(iTx)=Arf.sc_min;
Rate.timer(iTx)=Arf.inc_timer;
 elseif Rate.timer(iTx)==0 & Rate.level(iTx)<Rate.level_max
Rate.curr(iTx)=Rate.set(Rate.level(iTx));
Arf.sc(iTx)=0;
Arf.fc(iTx)=0;
Arf.Brecover(iTx)=1;
Rate.timer(iTx)=Arf.inc_timer;
end
end % if Arf.Brecover==1if Mac.nRetry(iTx)> Mac.nRetry_max
  if Mac.nRetry(iTx)> Mac.nRetry_max
              check_more_pk=1;
              Pk.drop(iTx)=Pk.drop(iTx)+1;
          else
              Mac.W(iTx)=min(Mac.Wmin*2^Mac.nRetry(iTx), Mac.Wmax);
              Mac.Bk_cnt(iTx)=floor(rand()* Mac.W(iTx));
          end % if nRetry>Ret_thr
          Arf.Brecover(iTx)=0;                    
      end
      
if check_more_pk==1
if 1 % if more pk available in queue
Mac.nRetry(iTx)=0;
Mac.W(iTx)= Mac.Wmin;
Arf.fc(iTx)=0; 
Mac.Bk_cnt(iTx)=floor(rand()*Mac.W(iTx));
else
    Mac.Bk_cnt(iTx)=10^20;
      end
      end % if check_more_pk

    end % for iTx
end; %   while sum(Pksuc)<n*mpck,...,end
% disp('end of period loop, paused')
% pause
  Static.pk_col = sum([Pk.col])/( sum([Pk.tx]));                  % collision probability
Static.pk_suc = sum([Pk.suc])/( sum([Pk.tx]));                  % collision probability
Static.pk_per = sum([Pk.per])/( sum([Pk.tx]));                  % collision probability  
Static.Pk_thr=sum([Pk.suc])*App.lave*8/Sim.time;            % average throughput.
Static.energyeff=sum([Pk.power])/sum([Pk.bit]);            % average energy efficiency.

if 0
    figure(1); for ii=1:Sim.n; plot(Trace_rate(ii).list, Trace_sc(ii).list, Trace_fc(iix).list, Trace_col(ii).list, Trace_per(ii).list);
        hold on; end; hold off;
end
return;