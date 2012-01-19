% function plot_results

% close all;

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
    
  Sim.n=Sim.node_set(idx_node);                      % number of nodes on network
  Rate.start=Rate.set(ceil(rand(1,Sim.n)*sRset));  

  Phy.snr=Phy.snr_set(idx_snr);
  Phy.snr_per= snr_per(Phy.snr, Phy.rate_mode);
  
  Arf.sc_min=10; Arf.sc_max=10; Arf.sc_multi=2; 
  Onoe.ratedec_retthr=0.5; %1 default           % variable for onoe, threshold to decrease rate based on retries per pk in a observation window.
  Onoe.rateinc_creditthr=10;     % variable for onoe, thresh on the credits to increase rate.
  Onoe.creditinc_retthr=0.1;     % variable for onoe, thresh on percentage of pks requiring retry to increase or decrease a credit.
  Onoe.period=0.2;                                         % observation time: 1 sec in defaul.

  for idx_node=1:sNode
      if Sim.cal_aarf
        plot_thr_aarf(idx_node)=thr_aarf(idx_node, idx_snr, idx_period, idx_start);
      plot_col_aarf(idx_node)=col_aarf(idx_node, idx_snr, idx_period, idx_start);
      plot_suc_aarf(idx_node)=suc_aarf(idx_node, idx_snr, idx_period, idx_start);
%       plot_per_aarf(idx_node)=per_aarf(idx_node, idx_snr, idx_period, idx_start);
      %plot_delay_aarf(idx_node)=per_aarf(idx_node, idx_snr, idx_period, idx_start);
     %plot_per_aarf(idx_node)=per_aarf(idx_node, idx_snr, idx_period, idx_start);
      %plot_p_loss_aarf(idx_node)=p_loss_aarf(idx_node, idx_snr, idx_period, idx_start);
      plot_eneff_aarf(idx_node)=eneff_aarf(idx_node, idx_snr, idx_period, idx_start);
        
      end
      
%       if Sim.cal_onoe
%        plot_thr_onoe(idx_node)=thr_onoe(idx_node, idx_snr, idx_period, idx_start);
%       plot_col_onoe(idx_node)=col_onoe(idx_node, idx_snr, idx_period, idx_start);
%       plot_suc_onoe(idx_node)=suc_onoe(idx_node, idx_snr, idx_period, idx_start);
%        plot_pk_per_onoe(idx_node)=per_onoe(idx_node, idx_snr, idx_period, idx_start);
%        %plot_pk_delay_onoe(idx_node)=per_onoe(idx_node, idx_snr, idx_period, idx_start);
%       %plot_p_loss_onoe(idx_node)=p_loss_onoe(idx_node, idx_snr, idx_period, idx_start);
%       plot_eneff_onoe(idx_node)=eneff_onoe(idx_node, idx_snr, idx_period, idx_start);
%      
%       end
      
  end

%   if Sim.cal_onoe
%       fig_org=0;
%       figure(fig_org+idx_start+(idx_period)*idx_period);
%       %plot([ploss], plot_thr_onoe, ['r' symbol_plot( rem(idx_snr, len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width); 
%       hold on;      grid on;
%      %plot(pk_per_onoe, plot_thr_onoe, ['r' symbol_plot( rem(idx_snr, len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width);
%      % plot(plot_suc_onoe, plot_thr_onoe, ['r' symbol_plot( rem(idx_snr, len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width);
%       plot(Sim.node_set, plot_thr_onoe, ['k' symbol_plot( rem(idx_snr, len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width); 
%       %plot(plot_eneff_onoe, plot_thr_onoe, ['r' symbol_plot( rem(idx_snr, len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width);
%       %plot(plot_delay_aarf, plot_thr_aarf, ['g' symbol_plot( rem(idx_snr,len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width);
%       hold on;      grid on;
%       %xlabel('collided packets');   ylabel('Throughput');
%      % xlabel('packet error rate');   ylabel('Throughput');
%       %xlabel('energyeff');  ylabel('Throughput');
%      xlabel('success');   ylabel('Throughput');
%       
%        legend(['SNR: ' num2str(Phy.snr_set(1))] , ['SNR: ' num2str(Phy.snr_set(2))], ['SNR: ' num2str(Phy.snr_set(3))] , ['SNR: ' num2str(Phy.snr_set(4))]);
%       set(gca, 'FontSize', font_size, 'LineWidth', line_width);     
%       if bl_epssave==1;    eval(['print -deps ' epsname 'through-sim_onoe-node' num2str(max(Sim.node_set)) ...
%               '-period' num2str(Onoe.period_set(idx_period)*10) '-start' num2str(Startrate_mode(idx_start)) ] ); end;       
%   end

   if Sim.cal_aarf
      fig_org=300;
      figure(fig_org+idx_start);
      plot(Sim.node_set, plot_thr_aarf, ['r' symbol_plot( rem(idx_snr, len_symbol) ) style_plot(1+(1-1)*2) style_plot(2+(1-1)*2)], 'LineWidth', line_width); 
      hold on;      grid on;
      ylabel('Throughput');      xlabel('Number of vehicles');
%      legend(['SNR: ' num2str(Phy.snr_set(2))] , ['SNR: ' num2str(Phy.snr_set(2))], ['SNR: ' num2str(Phy.snr_set(3))] , ['SNR: ' num2str(Phy.snr_set(4))]);
      set(gca, 'FontSize', font_size, 'LineWidth', line_width);     
      if bl_epssave==1;    eval(['print -deps ' epsname 'through-aarf-node' num2str(max(Sim.node_set)) ...
              '-period' num2str(Onoe.period_set(idx_period)*10) '-start' num2str(Startrate_mode(idx_start)) ] ); end;                    
  end
end %idx_sNode
end % for idx_start  
end % for idx_snr  
end % for idx_period