% close all;
 
clear;

% modulation_curve_creation
%modulation_model= 5; %% the type of modulation techniques;
mod_start =5;
mod_end   =5;
siso = 1;
stbc2by2 = 2;
diversity_model=siso;
% diversity_model=stbc2by2;
channel_type='cha';
tx_num='2';
rx_num='2';

per_size = 4; %% available statics for types of packet size;
pack(1) = 54;
pack(2) = 256;
pack(3) = 500;
pack(4) = 1000;

proc_all_model =0;
bl_intp_type = 0; %% used to choose if interpolate on ber_log or per_log; 

for i_modulation = mod_start:mod_end    
 
    i_modulation
	for i_per = 1:per_size
        if proc_all_model ==1
            if diversity_model == siso
                filename_ebn_per = ['siso-ebn-per-m' num2str(i_modulation) '-pack' num2str(pack(i_per)) '.txt'];
            elseif diversity_model == stbc2by2
                filename_ebn_per = ['stbc2by2-ebn-per-m' num2str(i_modulation) '-pack' num2str(pack(i_per)) '.txt'];
            end
            ebn_per = load(filename_ebn_per);
        else
            if diversity_model == siso
                ebn_per = load('80211a-siso-ebn-ber.txt');
            elseif diversity_model ==stbc2by2
                ebn_per = load('80211a-stbc2by2-ebn-ber_all.txt');
            end
        end
	
%         ebn_per
%         pause;
		ebn_raw = ebn_per(:,1);
        
        per_raw(:,i_per) = ebn_per(:,i_per+1);
        per_raw_log(:,i_per) =log(per_raw(:,i_per));   
        ber_raw(:,i_per) = 1-exp( log((1-per_raw(:,i_per))) / (pack(i_per)*8) );     
        ber_raw_log(:,i_per) = log(ber_raw(:,i_per));

        ebn_intp = min(ebn_raw):0.5:max(ebn_raw);
	
		if i_modulation ==1
            snr_raw = 10.*log10(10.^(ebn_raw./10).*(0.5*0.8*1));
            snr_intp = 10.*log10(10.^(ebn_intp./10).*(0.5*0.8*1));    
		elseif i_modulation ==2
            snr_raw = 10.*log10(10.^(ebn_raw./10).*(0.75*0.8*1));
            snr_intp = 10.*log10(10.^(ebn_intp./10).*(0.75*0.8*1));    
		elseif i_modulation ==3
            snr_raw = 10.*log10(10.^(ebn_raw./10).*(0.5*0.8*2));    
            snr_intp = 10.*log10(10.^(ebn_intp./10).*(0.5*0.8*2));        
		elseif i_modulation ==4
            snr_raw = 10.*log10(10.^(ebn_raw./10).*(0.75*0.8*2));
            snr_intp = 10.*log10(10.^(ebn_intp./10).*(0.75*0.8*2));    
		elseif i_modulation ==5
            snr_raw = 10.*log10(10.^(ebn_raw./10).*(0.5*0.8*4));    
            snr_intp = 10.*log10(10.^(ebn_intp./10).*(0.5*0.8*4));        
		elseif i_modulation ==6
            snr_raw = 10.*log10(10.^(ebn_raw./10).*(0.75*0.8*4));    
            snr_intp = 10.*log10(10.^(ebn_intp./10).*(0.75*0.8*4));        
		elseif i_modulation ==7
            snr_raw = 10.*log10(10.^(ebn_raw./10).*(0.75*0.8*6));    
            snr_intp = 10.*log10(10.^(ebn_intp./10).*(0.75*0.8*6));        
		elseif i_modulation ==8
            snr_raw = 10.*log10(10.^(ebn_raw./10).*(2/3*0.8*6));    
            snr_intp = 10.*log10(10.^(ebn_intp./10).*(2/3*0.8*6));        
		end        

        if bl_intp_type==1
            per_intp_log(:,i_per) = interp1(ebn_raw,per_raw_log(:,i_per),ebn_intp)';        
            per_intp(:,i_per) = exp(per_intp_log(:, i_per));
            ber_intp(:,i_per) = 1-exp( log((1-per_intp(:,i_per))) / (pack(i_per)*8) );            
            ber_intp_log(:,i_per) = log(ber_intp(:,i_per));
        else
            ber_intp_log(:,i_per) = interp1(ebn_raw,ber_raw_log(:,i_per),ebn_intp)';     
            ber_intp(:,i_per) = exp(ber_intp_log(:,i_per));
            per_intp(:,i_per) = 1-(1-ber_intp(:,i_per)).^(pack(i_per)*8);
            per_intp_log(:,i_per) = log(per_intp(:,i_per));
        end
        
        disp_ber_temp(:,1) = ber_intp(:,i_per);
        disp_ber_temp(:,2) = ebn_intp'
%         filename = ['11a_siso_model5_pk' num2str(pack(i_per)) '.txt'];
%         save filename.txt disp_ber_temp -ascii;
		%     pause;
            

%          figure(i_modulation)
%         semilogy(ebn_intp, ber_intp(:,i_per),'dk-');

        figure(1)
% 		set(gca, 'FontSize', 14, 'LineWidth', 2);        
% 		set(findobj('Type','line'),'LineWidth',2);
% 		set(findobj('Type','line'),'MarkerSize',12);       
        xlabel('Effective SNR (DB)');
        grid on;
%         xlabel('snr');
        ylabel('Bit Error Rate (BER)');        
        if diversity_model == siso
            if i_per ==1
                semilogy(snr_intp, ber_intp(:,i_per),'dk-');        
            elseif i_per==2
                semilogy(snr_intp, ber_intp(:,i_per),'sk-');        
            elseif i_per==3
                semilogy(snr_intp, ber_intp(:,i_per),'+k-');        
            elseif i_per==4
                semilogy(snr_intp, ber_intp(:,i_per),'xk-');        
            end
        else
            if i_per ==1
                semilogy(snr_intp, ber_intp(:,i_per),'dk--');        
            elseif i_per==2
                semilogy(snr_intp, ber_intp(:,i_per),'sk--');        
            elseif i_per==3
                semilogy(snr_intp, ber_intp(:,i_per),'+k--');        
            elseif i_per==4
                semilogy(snr_intp, ber_intp(:,i_per),'xk--');        
            end
        end
        hold on;
%         semilogy(ebn_raw, ber_raw(:,i_per),'sk-');
%         if diversity_model == siso
%             semilogy(snr_raw, ber_raw(:,i_per),'sk-');        
%         else
%             semilogy(snr_raw, ber_raw(:,i_per),'sk--');        
%         end
         figure(10)
%         figure(i_modulation+8)        
        semilogy(ebn_intp, ber_intp(:,i_per),'dk-');            
%         semilogy(snr_intp, per_intp(:,i_per),'dk-');                     
        grid on;
        xlabel('ebn');
        ylabel('per');
        hold on;
        semilogy(ebn_raw, ber_raw(:,i_per),'sk-');
%         semilogy(snr_raw, per_raw(:,i_per),'sk-');                  
	end

    
%     ebn_per
%     ebn_raw 
%     per_raw
%     pause;
      clear ebn_per ebn_raw per_raw per_raw_log ber_raw ber_raw_log ebn_intp snr_raw snr_intp per_intp_log per_intp ber_intp ber_intp_log disp_ber_temp;        
end

