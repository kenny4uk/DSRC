% function plot_results

close all;

%% define the strings used for plot lines.
symbol_plot='sd^vph><+xo*sd^vph><+xo*sd^vph><+xo*'; %% one character represent one plot symbol;
len_symbol=length(symbol_plot);
style_plot='- --: -.'; %% two character represent one line style;
color_plot='k b g c m y r';
font_size=16; line_width=1.6;
for idx_period=1:sPeriodset
for idx_snr=1: sSnr    
for idx_start=1:sStart    
for idx_node=1:sNode
% for idx_spd=1:sSpd  
        
%     v=[ 20 30 40 50];% speed of vehicle in km/h
%  v=rand(1,20)*70;
  Sim.n=Sim.node_set(idx_node);                       % number of nodes in the BSS
  Rate.start=Rate.set(ceil(rand(1,Sim.n)*sRset));  

  Phy.snr=Phy.snr_set(idx_snr);
  Phy.snr_per= snr_per(Phy.snr, Phy.rate_mode);
  
  Arf.sc_min=10; Arf.sc_max=50; Arf.sc_multi=2; 
  Onoe.ratedec_retthr=0.5; %1 default           % variable for onoe, threshold to decrease rate based on retries per pk in a observation window.
  Onoe.rateinc_creditthr=10;     % variable for onoe, thresh on the credits to increase rate.
  Onoe.creditinc_retthr=0.1;     % variable for onoe, thresh on percentage of pks requiring retry to increase or decrease a credit.
  Onoe.period=0.2;                                         % observation time: 1 sec in defaul.

  for idx_spd=1:sSpd
     
%       if Sim.cal_onoe
%       plot_thr_onoe(idx_node)=thr_onoe(idx_node, idx_snr, idx_period, idx_start);
%       plot_col_onoe(idx_node)=col_onoe(idx_node, idx_snr, idx_period, idx_start);
%       plot_suc_onoe(idx_node)=suc_onoe(idx_node, idx_snr, idx_period, idx_start);
%       end

    % 
      
       if Sim.cal_aarf
      plot_thr_aarf(idx_spd)=thr_aarf(idx_spd,idx_snr, idx_period, idx_start);
      plot_col_aarf(idx_spd)=col_aarf(idx_spd,idx_snr, idx_period, idx_start);
      plot_suc_aarf(idx_spd)=suc_aarf(idx_spd,idx_snr, idx_period, idx_start);
       end
      
      if Sim.cal_sample
      plot_thr_sample(idx_spd)=thr_sample(idx_spd,idx_snr, idx_period, idx_start);
      plot_col_sample(idx_spd)=col_sample(idx_spd,idx_snr, idx_period, idx_start);
      plot_suc_sample(idx_spd)=suc_sample(idx_spd,idx_snr, idx_period, idx_start);
      
      end
      
  end

%   if Sim.cal_onoe
%       fig_org=1;
%       figure(fig_org+1+idx_start);
%       plot(Sim.node_set, plot_thr_onoe, ['b' symbol_plot( rem(idx_snr, len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width);
%       plot(Sim.node_set, plot_thr_sample, ['b' symbol_plot( rem(idx_snr, len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width); 
%       hold on;      grid on;
%       xlabel('Number of nodes');   ylabel('Throughput');
%       % pause;
%       legend(['SNR: ' num2str(Phy.snr_set(1))] , ['SNR: ' num2str(Phy.snr_set(2))], ['SNR: ' num2str(Phy.snr_set(3))]);
%   end
%   if Sim.cal_sample
%       fig_org=100;
%       figure(fig_org+1+idx_start);
%    plot(Sim.node_set, plot_thr_aarf, ['g' symbol_plot( rem(idx_snr, len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width); 
%       hold on;      grid on;
%       xlabel('Number of nodes');   ylabel('System throughput (bits/second)');
      % pause;
%       legend(['SNR: ' num2str(Phy.snr_set(1))] , ['SNR: ' num2str(Phy.snr_set(2))], ['SNR: ' num2str(Phy.snr_set(3))] , ['SNR: ' num2str(Phy.snr_set(4))]);
%   end

%   if Sim.cal_aarf
%       fig_org=3;
%       figure(fig_org+1+idx_start);
%     plot(Sim.node_set, plot_thr_aarf, ['g' symbol_plot( rem(idx_snr, len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width);
%        legend(['SNR: ' num2str(Phy.snr_set(1))] , ['SNR: ' num2str(Phy.snr_set(2))], ['SNR: ' num2str(Phy.snr_set(3))] , ['SNR: ' num2str(Phy.snr_set(4))]);

% plot(Sim.node_set, plot_thr_onoe, ['r' symbol_plot( rem(idx_snr, len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width);
%     hold on;
   plot(spd_set, plot_thr_aarf, ['b' symbol_plot( rem(idx_snr,len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width);
%     hold on; 
%    plot(Phy.snr_set, plot_thr_aarf, ['b' symbol_plot( rem(idx_snr, len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width);
    hold on; 
   plot(spd_set, plot_thr_sample, ['g' symbol_plot( rem(idx_snr,len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width);
     hold on; grid on;
%       xlabel('Number of nodes');
%       ylabel('Throughput');

%   end
%    xlabel('Phy.snr_set');
   xlabel('Average speed of vehicles (Km /h)');
   
      ylabel('System Throughput (bits/second');
      legend('AARF','SAMPLERATE');
      hold on;
grid on;

% end%for idx_spd
end%  for idx_node  
end % for idx_start  
end % for idx_snr  
end % for idx_period