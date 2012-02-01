function alg_sample

global Sim App Mac Phy Rate Arf Onoe Sstats Sample;
global Pk St Trace_sample Static;

par_init;

% parameters for algorithm Sample===================================================
Sample.bl_debug= 0;
Sample.frame_bin=[250 1000 3000]; Sample.num_frame_bin=length(Sample.frame_bin);  % num of bins and packet size for each bin; max frame length is 3000 byte.
Sample.frame_bin=[1500]; Sample.num_frame_bin=length(Sample.frame_bin);  % num of bins and packet size for each bin; max frame length is 3000 byte.
Sample.rates=[3 6 9 24 27]; 
Sample.num_rate=length(Sample.rates); % num of tx rate and bit rate.
Sample.sample_time=10/100; % 10% of transmission time used for sampling, sending at a different bit-rate.
Sample.stale_failure_timeout=10; % stale consecutive 4 failures timeout 10 seconds;
Sample.min_switch=1; % minimal switch time 1 second.
Sample.smoothing_rate=0.95; % ewma percentage (out of 100) 
Sample.rate_first_series=5; % set up the transmit rate for first serier of transmissions with the sampling rate. the remaining rate set to the lowest one.

  % Simulation stops when all packets have been transmitted. Each iteration corresponds to a transmission attempt   
  Sim.tstart = clock;
  Sim.time = 0.0;                  % simulation time 
  Sim.ratetime=0.0;

Sample.t_slot = 9*10^(-6);
Sample.t_sifs = 16*10^(-6);
Sample.t_difs = 28*10^(-6);
Sample.ack_duration=200*10^(-6);
Sample.header_duration=20*10^(-6);
Sample.rts_duration= 200*10^(-6); % to be changed later
Sample.cts_duration=200*10^(-6); % to be changed later.
Sample.frame_len=App.lave; 
Sample.avg_bk_slot(1)=Mac.Wmin/2;
Sample.Ts_over=Sample.t_sifs+Sample.t_difs+Sample.header_duration+Sample.ack_duration;
Sample.Tc_over=Sample.t_sifs+Sample.t_difs+Sample.header_duration+Sample.ack_duration;

for ii=2:(Mac.nRetry_max+1)
  Sample.avg_bk_slot(ii)=Sample.avg_bk_slot(ii-1)+ min(Mac.Wmax, Mac.Wmin*2^(ii-1))/2;
end

  % sample parameter initialization
  node_ctl_reset();
  
  while sum([Pk.suc])<=Sim.pk,
%       Rate.level
%       Phy.snr_per
%       pause;
      
     % process the transmission events
      if (rem(sum([Pk.tx]),10000)==0)   % &0,
          deltaT= etime(clock,Sim.tstart);
          disp(['Expected time to conclusion: ', num2str(round(deltaT/sum([Pk.suc])*(Sim.pk- sum([Pk.suc])))),' sec...'])
      end; % if rem...
  
      if Sample.bl_debug
        disp('Start of a packet tx:'); disp(Sim.time);
      end
      
      dt_temp = min(Mac.Bk_cnt);                                   % Txnode = IDs of the nodes that attempt the transmission
      Txnode = find(Mac.Bk_cnt==dt_temp);                % find the time of the first transmission attempt 
      Mac.Bk_cnt=Mac.Bk_cnt-dt_temp-1;                   % all backoff counters are decremented 
      Sim.time = Sim.time+ dt_temp*Sample.t_slot;       % update the simulation time accordingly
      sTxnode = length(Txnode);                                       % sTxnode = number of simultaneously transmitting nodes
      Pk.tx(Txnode)=Pk.tx(Txnode)+1;
      Onoe.win_tx_all(Txnode)=Onoe.win_tx_all(Txnode)+1;      
      
      % find rate for each transmission node if the transmission is the first attempt;
      for ii=1:sTxnode
        node_id=Txnode(ii);
        
        Sstats.last_tx_suc(node_id)=0;        
        Sstats.last_tx_tries(node_id)=Sstats.last_tx_tries(node_id)+ 1;          
        Sstats.last_tx_frame_len(node_id, Sstats.last_tx_tries(node_id))=App.lave;                
        Sstats.last_tx_rts_enabled(node_id, Sstats.last_tx_tries(node_id))=0;
        
        if Sstats.last_tx_tries(node_id)==1
          find_rate(node_id, App.lave);
          Sstats.last_tx_tries(node_id)=1;
        end
      end % for ii=1:sTxnode
      Sstats.packets_total=Sstats.packets_total+ sTxnode;
      
      % we distinguish two possible events at this slot time 
      temp_rate=zeros(1,Sim.n);
      temp_rate_idx=zeros(1,Sim.n);
      for ii=1:sTxnode
       %  Txnode(ii) %
        temp_rate_idx(Txnode(ii))=Sstats.last_tx_rate(Txnode(ii), Sstats.last_tx_tries(Txnode(ii)));
        temp_rate(Txnode(ii))=Sample.rates(Sstats.last_tx_rate(Txnode(ii), Sstats.last_tx_tries(Txnode(ii))))*10^6;
        Rate.level(Txnode(ii))=temp_rate_idx(Txnode(ii));
      end
      
      if sTxnode>1        % if sTxnode > 1 => Collision occurs
        St.fail(Txnode)=1; 
        St.col(Txnode)=1;
        Pk.col(Txnode)= Pk.col(Txnode)+ 1;     % total number of collided packets is updated;
  
        Phy.Tc(Txnode)=Sample.Tc_over+ 8*App.lave./temp_rate(Txnode);
        Pk.power(Txnode)=Pk.power(Txnode)+Phy.Tc(Txnode)*Phy.power;
        maxTc=max(Phy.Tc(Txnode));                  % we need to know how long the collision is going to last 
        Sim.time= Sim.time + maxTc;                   % and update the simulation time subsequently
      elseif sTxnode==1
        % process BER and check if pkt can be accepted due to ber.
        if 0 %temp_rate(Txnode)>5 
        Bper=0; 
        Txnode
        sTxnode
        temp_rate
        pause;
        end
        
        Per_temp= Phy.snr_per(temp_rate_idx(Txnode)); 
        if 0 & Sample.bl_debug==1
          Per_temp
          temp_rate
          Phy.snr_per
          pause;
        end
        
        if rand()<Per_temp; Bper=1; else Bper=0; end;
        if Bper==1
          St.fail(Txnode)=1; 
          St.col(Txnode)=0;
          St.per(Txnode)=1;        
          Pk.per(Txnode)=Pk.per(Txnode)+1;

          Phy.Tc(Txnode)=Sample.Tc_over+8*App.lave./temp_rate(Txnode);                  % how long does it take to transmit it with success? 
          Pk.power(Txnode)=Pk.power(Txnode)+Phy.Tc(Txnode)*Phy.power;          
          Sim.time = Sim.time + Phy.Tc(Txnode);                 % update the simulation time 
        else   % if sTxnode == 1 & Bper==0 => Successfull transmission occurs
          St.fail(Txnode)=0; 
          St.col(Txnode)=0;
          St.per(Txnode)=0;        
          Pk.suc(Txnode)= Pk.suc(Txnode)+1;           % update number of sent packets          
          Phy.Ts(Txnode)=Sample.Ts_over+8*App.lave./temp_rate(Txnode);                  % how long does it take to transmit it with success? 
          Pk.bit(Txnode)=Pk.bit(Txnode)+8*App.lave;
          Pk.power(Txnode)=Pk.power(Txnode)+Phy.Ts(Txnode)*Phy.power;          
          Sim.time= Sim.time + Phy.Ts(Txnode);            % update the simulation time 
          % ws(Pksuc) = Sim.time-birthtime(Txnode); % compute the service time of this packet 
          App.birthtime(Txnode)= Sim.time;                    % and store the time this packet entered service
          
          Sstats.last_tx_suc(Txnode)=1; % record the success of this transmission.
        end; % if Bper
      end % if sTxnode>1

      for ii=1:sTxnode
        iTx=Txnode(ii);
        if (Sstats.last_tx_suc(iTx)==1 | Sstats.last_tx_tries(iTx)==(Mac.nRetry_max+1))
          % process transmission feedback if the transmission is complete (successful or discarded due to too many retransmissions).
          proc_feedback(iTx);
          Sstats.last_tx_suc(Txnode)=0; % record the success of this transmission.
        end
      end
      
      for ii=1:sTxnode
        iTx=Txnode(ii);
        if (Sstats.last_tx_suc(iTx)==1 | Sstats.last_tx_tries(iTx)==(Mac.nRetry_max+1))
          Trace_sample(iTx).time=[Trace_sample(iTx).time Sim.time];
          Trace_sample(iTx).rate=[Trace_sample(iTx).rate Rate.level(iTx)];
          Trace_sample(iTx).fail=[Trace_sample(iTx).fail St.fail(iTx)];
          Trace_sample(iTx).col=[Trace_sample(iTx).col St.col(iTx)];
          Trace_sample(iTx).per=[Trace_sample(iTx).per St.per(iTx)];
        end
      end

      for ii=1:sTxnode
        iTx=Txnode(ii);
        check_more_pk=0;

        if St.fail(iTx)==0
            check_more_pk=1;
        else % if St_tx(Txnode...
            Mac.nRetry(iTx)=Mac.nRetry(iTx)+1;
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

             Sstats.tx_frame_len(iTx)=Sample.frame_len;  % here we use fixed frame length temporaly.
             Sstats.last_tx_tries(iTx)=0;             
            else
                Mac.Bk_cnt(iTx)=10^20;
            end
        end % if check_more_pk

      end % for ii=1:sTxnode
      
    if Sample.bl_debug
      disp('End of a packet tx:'); disp(Sim.time);
      temp_backoff_time=dt_temp*Sample.t_slot
      temp_tx_time=Phy.Ts
      temp_rate
      Sstats.last_tx_rate
      pause;
    end
      
  end; %   while sum(Pksuc)<n*mpck,...,end

  
  Static.pk_col = sum([Pk.col])/( sum([Pk.tx]));                  % collision probability
  Static.pk_suc = sum([Pk.suc])/( sum([Pk.tx]));                  % collision probability
  Static.pk_per = sum([Pk.per])/( sum([Pk.tx]));                  % collision probability  
  Static.through=sum([Pk.suc])*App.lave*8/Sim.time;            % average throughput.
  Static.energyeff=sum([Pk.power])/sum([Pk.bit]);            % average energy efficiency.
  
  if 0 & Sim.debug_sample_sim==1
      figure(2);  
      
      for ii=1:Sim.n; 
          plot(Trace_sample(ii).time(:), Trace_sample(ii).rate(:), 'ks'); 
          pause; 
      end; % hold on; end; hold off; 
      
  end
  
return; 

%=======================================================
% SampleRate function node initialization
function node_ctl_reset()
global Sim Sstats Sample;

for idx_node=1:Sim.n
  Sstats.static_rate_ndx(idx_node)=0; % use adaptive rate
  Sstats.last_tx_tries(idx_node)=0; % number of tries for the last tx.
  
	for y = 1: Sample.num_frame_bin
		Sstats.packets_total(idx_node,  y)= 0;

    % set the initial rate */
    Sstats.current_rate(idx_node,  y)= find(Sample.rates==27);
    Sstats.current_sample_ndx(idx_node,  y)= -1;
		Sstats.last_sample_ndx(idx_node,  y)= 1;
		
    Sstats.packets_since_switch(idx_node, y)= 0;
    Sstats.packets_since_sample(idx_node, y)= 0;
    Sstats.time_since_sample(idx_node, y)= 0;    
    Sstats.time_since_switch(idx_node, y)= 0;        
    Sstats.sample_tt(idx_node, y)= 0; %% time spent for the last rate sampling.

		for (x = 1: Sample.num_rate)
			Sstats.successive_failures(idx_node,  y, x)= 0;
			Sstats.tries(idx_node,  y, x)= 0;
			Sstats.packets_sent(idx_node, y, x)= 0;
			Sstats.packets_acked(idx_node,  y, x)= 0;
      cal_perfect_time=1;
			Sstats.perfect_tx_time(idx_node,  y, x)= calc_time_unicast_packet(idx_node, cal_perfect_time, x, Sample.frame_bin(y));
			Sstats.average_tx_time(idx_node,  y, x) =	Sstats.perfect_tx_time(idx_node, y, x);
      
      Sstats.last_tx_time(idx_node,  y, x)= 0;
      Sstats.last_tx_tries(idx_node)=0;
    end % for x=1
    
  end % for y=1
end % for idx_node


return;

% ======================================================
% SampleRate function find_rate() to determine bit rate before a packet transmit
function ndx=find_rate(node_id, frame_len)
global Sim Mac Sample Sstats;

  size_bin = min(find( (Sample.frame_bin- frame_len)>=0));
  best_ndx = best_rate_ndx(node_id,  size_bin);

	if (best_ndx >0)
		average_tx_time = Sstats.average_tx_time(node_id,  size_bin, best_ndx);
  else
  	average_tx_time = 0;
  end
	
	if (Sstats.static_rate_ndx(node_id) == 1) 
    % if node_id is configured to use fixed rate
		ndx = Sstats.static_rate_ndx(node_id);
  else
    % if node_id is configured to use adaptive rate    
		if Sstats.sample_tt(node_id,  size_bin) < average_tx_time * (Sstats.packets_since_sample(node_id,  size_bin) *  Sample.sample_time);
			 % we want to limit the time measuring the performance of other bit-rates to ath_sample_rate% of the total transmission time.
			ndx = pick_sample_rate(node_id,  size_bin);
      if Sample.bl_debug==1
        disp('Pick a sampling rate');
              best_ndx
              Sstats.current_rate(node_id,  size_bin)
              ndx
              average_tx_time
              Sstats.packets_since_sample(node_id,  size_bin)
        pause;
      end
			if (ndx ~= Sstats.current_rate(node_id,  size_bin) )
        if Sample.bl_debug==1
          disp('Sample at different rate');
          ndx
          Sstats.current_rate(node_id,  size_bin)
          pause;
        end
        
				Sstats.current_sample_ndx(node_id,  size_bin) = ndx;
			else
				Sstats.current_sample_ndx(node_id,  size_bin) = -1;
      end
      % since a new round sampling has been process, the timer for the next sampling is reset.
			Sstats.packets_since_sample(node_id,  size_bin) = 0;
    else
			change_rates = 0;
			if (Sstats.packets_total(node_id,  size_bin)<1 | best_ndx == -1) 
				% no packet has been sent successfully yet, so pick an rssi-appropriate bit-rate. 
        % We know if the rssi is very low that the really high bit rates will not work.
				initial_rate = 24; 
        Sstats.chn_avgrssi(node_id)=12; % here we simply set the avgrssi value, which can be amended later.
				if (Sstats.chn_avgrssi(node_id) > 12)
					initial_rate = 108; % 54 mbps */
        elseif (Sstats.chn_avgrssi(node_id) > 12) 
					initial_rate = 24; % 36 mbps */
        else
					initial_rate = 3;  % 12 mbps */
        end

				for (ndx= Sample.num_rate:-1:1) 
					%  pick the highest rate <= initial_rate  that hasn't failed.
					if (Sample.rates(ndx) <= initial_rate & Sstats.successive_failures(node_id, size_bin, ndx)== 0)
						break;
          end
        end % for (ndx=Sample.num_rate
				change_rates = 1;
				best_ndx = ndx;
      elseif (Sstats.packets_total(node_id,  size_bin) < 20) 
				% let the bit-rate switch quickly during the first few packets */
				change_rates = 1;
      elseif (Sim.time- Sample.min_switch) > Sstats.time_since_switch(node_id,  size_bin)  
				% 2 seconds have gone by */
				change_rates = 1;
      elseif (average_tx_time * 2 < Sstats.average_tx_time(node_id,  size_bin, Sstats.current_rate(node_id,  size_bin)) ) 
				% the current bit-rate is twice as slow as the best one 
				change_rates = 1;
      end

			Sstats.packets_since_sample(node_id,  size_bin)=	Sstats.packets_since_sample(node_id,  size_bin)+1;
      if Sample.bl_debug==1 & change_rates
              disp('Change a rate');
              change_rates
              best_ndx
              Sstats.current_rate(node_id,  size_bin)
              pause;
      end
      
			if (change_rates) 
				Sstats.packets_since_switch(node_id,  size_bin) = 0;
				Sstats.current_rate(node_id,  size_bin) = best_ndx;
				Sstats.time_since_switch(node_id,  size_bin) = Sim.time;
      end
			ndx= Sstats.current_rate(node_id,  size_bin);
    	Sstats.packets_since_switch(node_id,  size_bin) = Sstats.packets_since_switch(node_id,  size_bin)+1;
      
    end % if Sstats.sample_tt
  end % if Sstats.static_rate

  % set up the transmit rate descriptor as done in Atheros driver
  temp_first_series=min(Sample.rate_first_series, Mac.nRetry_max+1);
  for ii=1: temp_first_series
    Sstats.last_tx_rate(node_id, ii)= ndx;
  end
  for ii=(temp_first_series+1): (Mac.nRetry_max+1)
      Sstats.last_tx_rate(node_id, ii)= 1; % send at the lowest rate; Sstats.current_rate(node_id,  size_bin);    
  end
  
return;

% ======================================================
% SampleRate function to find the bit rate to be sampled
function next_ndx=pick_sample_rate(node_id, frame_len)
global Sim Sstats Sample;

  size_bin = min(find( (Sample.frame_bin-frame_len)>=0));
  current_ndx = Sstats.current_rate(node_id,  size_bin);
	if (current_ndx < 0) 
		% no successes yet, send at the lowest bit-rate */
    next_ndx=1;
    return;
  end
	
	current_tt = Sstats.average_tx_time(node_id,  size_bin, current_ndx);
	
    if 0 & Sample.bl_debug==1    
        disp('Picking up a new rate');
        current_ndx
        Sstats.sample_tt
        Sstats.packets_acked(node_id, size_bin, current_ndx)
        last_sample_ndx=Sstats.last_sample_ndx(node_id,  size_bin)
        current_tt
        Sstats.perfect_tx_time
        
    end
    
	for x = 1:Sample.num_rate
    		ndx = mod(Sstats.last_sample_ndx(node_id,  size_bin)+ x-1, Sample.num_rate)+1;
        if 0 & Sample.bl_debug==1
          disp('Loop sample rate:');
          ndx
          pause;
        end
        % don't sample the current bit-rate */
    		if (ndx == current_ndx) 
        	continue;
        end
        
  		% this bit-rate is always worse than the current one */
    	if (Sstats.perfect_tx_time(node_id,  size_bin, ndx) > current_tt) 
  			continue;
      end

		% rarely sample bit-rates that fail a lot */
		if (Sim.time - Sstats.last_tx_time(node_id,  size_bin, ndx)) < ( Sample.stale_failure_timeout) & Sstats.successive_failures(node_id,  size_bin, ndx) > 3
			continue;
    end

		% don't sample more than 2 indexes higher for rates higher than 11 megabits	 */
		if (Sample.rates(ndx)> 12 &  ndx> (current_ndx + 2))
			continue;
    end

    Sstats.last_sample_ndx(node_id,  size_bin) = ndx;
    next_ndx=ndx;
    % next_ndx
    % pause;
    return;
  end

  % if none of the rates is selected as eligible sampling rate, return the current_ndx (means no sampling for this occasion).
  next_ndx= current_ndx; 
return;

% SampleRate function to process feedback after a packet transmit complete
function proc_feedback(node_id)
global Sim Sstats Sample;

  frame_len=Sstats.last_tx_frame_len(node_id);
  size_bin = min(find( (Sample.frame_bin-frame_len)>=0));
	size = Sample.frame_bin(size_bin);
  ndx0= Sstats.last_tx_rate(node_id, 1); 
  rate = Sample.rates(ndx0); % rate 1 for the first series tries in the rate descriptor.
  cal_perfect_time=0;
	tt = calc_time_unicast_packet(node_id, cal_perfect_time, ndx0, frame_len);
  
	if Sstats.packets_sent(node_id,  size_bin, ndx0) < 1/ (1-Sample.smoothing_rate) 
		% just average the first few packets 
    avg_tx = Sstats.average_tx_time(node_id,  size_bin, ndx0);
		packets = Sstats.packets_sent(node_id,  size_bin, ndx0);
    if packets==0
  		Sstats.average_tx_time(node_id,  size_bin, ndx0) = tt;
    else
  		Sstats.average_tx_time(node_id,  size_bin, ndx0) = (tt + avg_tx * packets) / (packets + 1);
    end
  else
		% use a ewma */
		Sstats.average_tx_time(node_id,  size_bin, ndx0) = ...
			Sstats.average_tx_time(node_id,  size_bin, ndx0) * Sample.smoothing_rate + tt * (1- Sample.smoothing_rate);
  end
	
	if (Sstats.last_tx_suc(node_id)==0 ) %  & Sstats.last_tx_tries(node_id)<= Sample.rate_first_series ) 
		Sstats.successive_failures(node_id,  size_bin, ndx0)=	Sstats.successive_failures(node_id,  size_bin, ndx0)+1;
		for y = (size_bin+1): Sample.num_frame_bin
			% also say larger packets failed since we assume if a small packet fails at a lower bit-rate then a larger one will also.
			Sstats.successive_failures(node_id,y,ndx0)=Sstats.successive_failures(node_id,y,ndx0)+1;
			Sstats.last_tx_time(node_id,y,ndx0) = Sim.time;
			Sstats.tries(node_id,y,ndx0)=Sstats.tries(node_id,y,ndx0)+ tries; %%????
			Sstats.packets_sent(node_id,y,ndx0)= Sstats.packets_sent(node_id,y,ndx0)+ 1;
    end
  else
		Sstats.packets_acked(node_id,size_bin,ndx0)=Sstats.packets_acked(node_id,size_bin,ndx0) +1;
		Sstats.successive_failures(node_id,size_bin,ndx0) = 0;
  end
	Sstats.tries(node_id,size_bin,ndx0) = Sstats.tries(node_id,size_bin,ndx0)+ Sstats.last_tx_tries(node_id);
	Sstats.last_tx_time(node_id,size_bin,ndx0) = Sim.time;
	Sstats.packets_sent(node_id,size_bin,ndx0)= Sstats.packets_sent(node_id,size_bin,ndx0)+1;

  if ndx0 == Sstats.current_sample_ndx(node_id,  size_bin) 
		Sstats.sample_tt(node_id, size_bin) = tt;
		Sstats.current_sample_ndx(node_id, size_bin) = -1;
  end
return;


% ===================================================================================================
% SampleRate function calc_time_unicast_packet() to calculate the transmit time for a packet with a packet size and snr.
function tt=calc_time_unicast_packet(node_id, only_perfect_time, rate_index, frame_len)
global Sstats Sample;

  tt=0;
  if only_perfect_time~=1
    ntries=Sstats.last_tx_tries(node_id);
    tt=Sample.avg_bk_slot(ntries)* Sample.t_slot; 
    tt=tt+ ntries*(Sample.t_difs+ Sample.t_sifs+ Sample.ack_duration+ Sample.header_duration);
    for ii=1:ntries
      temp_rate=Sample.rates(Sstats.last_tx_rate(node_id, ii)) *10^6;
      if Sstats.last_tx_rts_enabled(node_id, ii)==0
        % basic access, RTS/CTS is not used.
        tt= tt+ Sstats.last_tx_frame_len(node_id, ii)*8/ temp_rate;
      elseif Sstats.last_tx_rts_suc(node_id, ii)==1
        % RTS/CTS is enabledused and rts is successful
        tt= tt+ Sample.rts_duration+ Sample.cts_duration+ ...
          Sstats.last_tx_frame_len(node_id, ii)*8/ temp_rate;
      else
        % RTS/CTS is enabledused and rts is not successful
        tt= tt+ Sample.rts_duration+ Sample.cts_duration;
      end
    end
  else
    % calculate the perfect transmission time without any retransmission.
    tt=Sample.avg_bk_slot(1)* Sample.t_slot; 
    tt=tt+ Sample.t_difs+ Sample.t_sifs+ Sample.ack_duration+ Sample.header_duration;
    tt= tt+ frame_len*8/(10^6* Sample.rates(rate_index));    
  end

%   if only_perfect_time~=1
%     if rate_index ~= Sstats.last_tx_rate(node_id, 1)
%       disp('Transmit rate different')
%       rate_index
%       Sstats.last_tx_rate(node_id, 1);
%       pause;
%     end
%     if Sstats.perfect_tx_time(node_id, rate_index)> tt
%       disp('Perfect tx time larger than calculated transmit time');
%       rate_index
%       tt
%       Sstats.perfect_tx_time(node_id, rate_index)
%       pause;
%     end
%   end

return;

%=============================================================
% SampleRate function to find the best rate in terms of average tx time.
function best_rate_ndx= best_rate_ndx(node_id, size_bin)
global Sstats Sample;

  best_rate_tt = 0;
  best_rate_ndx = -1;
        
	for (x = 1: Sample.num_rate)
		tt = Sstats.average_tx_time(node_id, size_bin, x);
		if (tt <= 0 | Sstats.packets_acked(node_id, size_bin, x)==0)
			continue;
    end

    % don't use a bit-rate that has been failing */
		if (Sstats.successive_failures(node_id, size_bin, x) > 3)
			continue;
    end

		if (best_rate_tt==0 | best_rate_tt > tt) 
			best_rate_tt = tt;
			best_rate_ndx = x;
    end
  end
        
return;