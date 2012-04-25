% function plot_results

close all;

%% define the strings used for plot lines.
symbol_plot='sd^vph><+xo*sd^vph><+xo*sd^vph><+xo*'; %% one character represent one plot symbol;
len_symbol=length(symbol_plot);
style_plot='- --: -.'; %% two character represent one line style;
color_plot='k b g c m y r';
font_size=16; line_width=1.6;

for idx_spd=1:sSpd
for idx_snr=1:sSnr
for idx_start=1:sStart 
for idx_period=1:sPeriodset
   
 Sim.n=Sim.node_set(idx_node); % number of nodes in the BSS
 Rate.start=Rate.set(ceil(rand(1,Sim.n)*sRset));  

Phy.snr=Phy.snr_set(idx_snr);
Phy.snr_per= snr_per(Phy.snr, Phy.rate_mode);
  
Arf.sc_min=10; Arf.sc_max=50; Arf.sc_multi=2; 
Onoe.ratedec_retthr=0.5; %1 default           % variable for onoe, threshold to decrease rate based on retries per pk in a observation window.
Onoe.rateinc_creditthr=10;     % variable for onoe, thresh on the credits to increase rate.
Onoe.creditinc_retthr=0.1;     % variable for onoe, thresh on percentage of pks requiring retry to increase or decrease a credit.
Onoe.period=0.2;                                         % observation time: 1 sec in defaul.
for idx_node=1:sNode
      plot(spdavg_set, thr_aarf(:,idx_node,1,1,1), ['b' symbol_plot( rem(idx_snr, len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width); 
      hold on; 
      plot( spdavg_set, thr_sample(:,idx_node,1,1,1), ['g' symbol_plot( rem(idx_snr, len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width); 
hold on; grid on;
  end   % end of idx_node loop

Title('Mean throughput versuss Average speed of vehicles.Mobile');
 xlabel('Average speed of vehicles (Km /h)');   ylabel('System throughput (bits/second)');
%   xlabel('no of vehicles');   ylabel('pkt error rate');
     legend('AARF','SAMPLERATE');
%           hold on; grid on;
end %for idx_period 
end % for idx_start
end% for idx_snr
end % for idx_spd
 