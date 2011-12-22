function alg_onoemob

global Sim App Mac Phy Rate Arf Onoe;
global Pk St Trace_time Trace_rate Trace_sc Trace_fc Trace_fail Trace_col Trace_suc Trace_per mobile;

par_init;

  % Simulation stops when all packets have been transmitted. Each iteration corresponds to a transmission attempt   
  Sim.tstart = clock;
  Sim.time = 0.0;                  % simulation time 
  Sim.ratetime=0.0;
  x_max=1000;
  ap=[500 0];
  max_speed= 70;
   min_speed= 50;
  
 
  while sum([Pk.suc])<=Sim.pk,
%       Rate.level
%       Phy.snr_per
%       pause;
      
     if (Sim.time-Sim.ratetime)>Onoe.period      
       %  Rate.level
         
       Sim.ratetime=Sim.time; % - mod(Sim.time, Onoe.period);
       % process the link rate adaptation for every Onoe.period.
        for ii=1:Sim.n
          if (Onoe.win_nretry(ii)>Onoe.ratedec_retthr* Onoe.win_tx_all(ii))   &  (Onoe.win_tx_all(ii)>=10) % | (Onoe.win_tx==0 &  Onoe.win_nretry>0 ))
              if 0
                  Sim.time
                  ii
                  Rate
                  Onoe
                  pause;    
              end
              if Rate.level(ii)>1
                  Rate.level(ii)=Rate.level(ii)-1;
                  Rate.curr(ii)=Rate.set(Rate.level(ii));
                  Onoe.credit(ii)=0;
                end % if Rate.curr(ii)
          end % if (Onoe.win_nretry
          
          if Onoe.win_nretry(ii)>=(Onoe.creditinc_retthr*Onoe.win_tx_all(ii))
            if Onoe.credit(ii)>0; Onoe.credit(ii)=max(0,Onoe.credit(ii)-1); end;
          elseif Onoe.win_nretry(ii)<(Onoe.creditinc_retthr*Onoe.win_tx_all(ii))
            Onoe.credit(ii)=Onoe.credit(ii)+1;
          end % if (Onoe.win_retired

          if Onoe.credit(ii)>=Onoe.rateinc_creditthr; 
            if Rate.level(ii)<Rate.level_max;
              Rate.level(ii)=Rate.level(ii)+1;
              Rate.curr(ii)=Rate.set(Rate.level(ii)); 
              Onoe.credit(ii)=0;
            end
          end

          Onoe.win_tx_all(ii)=0; % including both new and retransmitted packets.
          Onoe.win_tx(ii)=0; % new packets only
          Onoe.win_nretry(ii)=0;
          Onoe.win_retried(ii)=0;
        for ii=1:n
        end % for ii=1:n
     end % if Sim.time

     % process the transmission events
      if (rem(sum([Pk.tx]),10000)==0) & 0,
          deltaT= etime(clock,Sim.tstart);
          disp(['Expected time to conclusion: ', num2str(round(deltaT/sum([Pk.suc])*(Sim.pk- sum([Pk.suc])))),' sec...'])
      end; % if rem...

      dt_temp = min(Mac.Bk_cnt);                                   % Txnode = IDs of the nodes that attempt the transmission
      Txnode = find(Mac.Bk_cnt==dt_temp);                % find the time of the first transmission attempt 
      Mac.Bk_cnt=Mac.Bk_cnt-dt_temp-1;                   % all backoff counters are decremented 
      Sim.time = Sim.time+ dt_temp*Phy.sigma;       % update the simulation time accordingly
      sTxnode = length(Txnode);                                       % sTxnode = number of simultaneously transmitting nodes
      Pk.tx(Txnode)=Pk.tx(Txnode)+1;
      Onoe.win_tx_all(Txnode)=Onoe.win_tx_all(Txnode)+1;      
      
      % we distringuish two possible events at this slot time 
      if sTxnode>1        % if sTxnode > 1 => Collision occurs
        St.fail(Txnode)=1; 
        St.col(Txnode)=1;
        Pk.col(Txnode)= Pk.col(Txnode)+ 1;     % total number of collided packets is updated;
  
        Phy.Tc(Txnode)=(Phy.Lc_over+ 8*App.lave)./Rate.curr(Txnode);
        Pk.power(Txnode)=Pk.power(Txnode)+Phy.Tc(Txnode)*Phy.power;
        maxTc=max(Phy.Tc(Txnode));                  % we need to know how long the collision is going to last 
        Sim.time= Sim.time + maxTc;                   % and update the simulation time subsequently
            
            p_mob();
      elseif sTxnode==1
          
        % process BER and check if pkt can be accepted due to ber.
        Bper=0; 
            Per_temp= Phy.snr_per(Rate.level(Txnode)); 
        
        if rand()<Per_temp; Bper=1; end;
      
                if Bper==1
                        
          St.fail(Txnode)=1; 
          St.col(Txnode)=0;
          St.per(Txnode)=1;        
          Pk.per(Txnode)=Pk.per(Txnode)+1;

          Phy.Tc(Txnode)=(Phy.Lc_over+8*App.lave)./Rate.curr(Txnode);                  % how long does it take to transmit it with success? 
          Pk.power(Txnode)=Pk.power(Txnode)+Phy.Tc(Txnode)*Phy.power; 
           p_mob();
          Sim.time = Sim.time + Phy.Tc(Txnode);                 % update the simulation time 
          
                                                   
                  else   % if sTxnode == 1 & Bper==0 => Successfull transmission occurs
          St.fail(Txnode)=0; 
          St.col(Txnode)=0;
          St.per(Txnode)=0;        
          Pk.suc(Txnode)= Pk.suc(Txnode)+1;           % update number of sent packets          
          Phy.Ts(Txnode)=(Phy.Ls_over+8*App.lave)./Rate.curr(Txnode);                  % how long does it take to transmit it with success? 
          Pk.bit(Txnode)=Pk.bit(Txnode)+8*App.lave;
          Pk.power(Txnode)=Pk.power(Txnode)+Phy.Ts(Txnode)*Phy.power;          
          Sim.time= Sim.time + Phy.Ts(Txnode);            % update the simulation time 
           p_mob();
                       
          
                 % ws(Pksuc) = Sim.time-birthtime(Txnode); % compute the service time of this packet 
          App.birthtime(Txnode)= Sim.time;                    % and store the time this packet entered service
        end; % if Bper
        
      end % if sTxnode>1
      
      for ii=1:sTxnode
        iTx=Txnode(ii);
        Rate.timer(iTx)=Rate.timer(iTx)-1;
        Trace_time(iTx).list=[Trace_time(iTx).list Sim.time];
        Trace_rate(iTx).list=[Trace_rate(iTx).list Rate.level(iTx)];
        Trace_fail(iTx).list=[Trace_fail(iTx).list St.fail(iTx)];
        Trace_col(iTx).list=[Trace_col(iTx).list St.col(iTx)];
        Trace_per(iTx).list=[Trace_per(iTx).list St.per(iTx)];

        check_more_pk=0;        
        if Mac.nRetry(iTx)==0; 
          Onoe.win_tx(iTx)=Onoe.win_tx(iTx)+1;
          % disp('tx+1');
        end

        if St.fail(iTx)==0
            check_more_pk=1;
        else % if St_tx(Txnode...
            Mac.nRetry(iTx)=Mac.nRetry(iTx)+1;
            Onoe.win_nretry(iTx)=Onoe.win_nretry(iTx)+1;          
            if Mac.nRetry(iTx)==1; 
                Onoe.win_retried(iTx)=Onoe.win_retried(iTx)+1;
            end
            if Mac.nRetry(iTx)>Mac.nRetry_max
                check_more_pk=1;
                Pk.drop(iTx)=Pk.drop(iTx)+1;
            else
                Mac.W(iTx)=min(Mac.Wmin*2^Mac.nRetry(iTx), Mac.Wmax);
                Mac.Bk_cnt(iTx)=floor(rand()*Mac.W(iTx));
            end % if Mac.nRetry>Ret_thr
        end

        if check_more_pk==1
            if 1 % if more pk available in queue
             Mac.nRetry(iTx)=0;
             Mac.W(iTx)=Mac.Wmin;
             Mac.Bk_cnt(iTx)=floor(rand()*Mac.W(iTx));
            else
                Mac.Bk_cnt(iTx)=10^20;
            end
        end % if check_more_pk

      end % for iTx
  end; %   while sum(Pksuc)<n*mpck,...,end
   p_mob();

  mobile.pk_col = sum([Pk.col])/( sum([Pk.tx]));                  % collision probability
 mobile.pk_suc = sum([Pk.suc])/( sum([Pk.tx]));                  % collision probability
  mobile.pk_per = sum([Pk.per])/( sum([Pk.tx]));                  % collision probability  
  mobile.through=sum([Pk.suc])*App.lave*8/Sim.time;            % average throughput.
  mobile.energyeff=sum([Pk.power])/sum([Pk.bit]);            % average energy efficiency.
  
  if Sim.debug_onoe_sim==1
      figure(2);  
      for ii=1:Sim.n; 
          plot(Trace_time(ii).list, Trace_rate(ii).list); 
          pause; 
      end; % hold on; end; hold off; 
      
  end
  
return; 