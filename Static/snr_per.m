function per=snr_per(snr, rate_mode);
% raw snr ber data for 802.11a modes with channel a model.
% snr: 1xm vector;
% rate_mode: 1xn vector;
% per: nxm matrix

% define the whole tx modes, SNR, PER and related information
     % txmode_all=[1 3 4 5 6 7]; Rdata_all=[12 24 24 48 48 72]; Rc_all=[1/2 1/2 3/4 1/2 3/4 3/4]; Rate=[6 12 18 24 36 54] ;
     % snr_all = [0 2 4 8 10 16];      per_all(5,1:6)=[1 1 1 0.5 0.15 0.0001];     per_all(6,1:6)=[1 1 1 1 1 0.08];     
     % snr_all = [0 2 4 8 14 20];

exp_n=3;
sRate_mode=length(rate_mode);
% snr=-10:0.1:100;
% rate_mode=[1 3 5 6 7]; 
% Rate=[6 12 24 36 54];

snr_ber_mode1=[
-3.979400087		0.9775
-1.979400087		0.886
1.020599913		0.5835
6.020599913		0.0985
8.020599913		0.034
9.020599913		0.0175
10.02059991		0.007
11.02059991		0.0035
];

snr_ber_mode2=[
-4 1   
-0.218487496		0.9575
2.781512504		0.773
7.781512504		0.2555
9.781512504		0.127
12.7815125		0.0265
14.7815125		0.0105
16.7815125		0.0025
];

snr_ber_mode3=[
-3 1
-0.96910013		0.9775
1.03089987		0.886
4.03089987		0.5835
9.03089987		0.0985
11.03089987		0.034
12.03089987		0.0175
13.03089987		0.007
14.03089987		0.0035
15.03089987		0.0025
];

snr_ber_mode4=[
-2 1
0 1    
2.79181246		0.9575
5.79181246		0.773
10.79181246		0.2555
12.79181246		0.127
15.79181246		0.0265
17.79181246		0.0105
19.79181246		0.0025
];

snr_ber_mode5=[
-2 1
0 1
2 1
4.041199827		0.984
7.041199827		0.8285
12.04119983		0.257
14.04119983		0.114
17.04119983		0.021
19.04119983		0.0055
21.04119983		0.0005
];

snr_ber_mode6=[
-2 1
0 1
2 1 
4 1
6 1
8.802112417		0.9655
13.80211242		0.5615
15.80211242		0.342
18.80211242		0.1225
21.80211242		0.0295
25.80211242		0.0035
27.80211242		0.001
];

snr_ber_mode7=[
-2 1
0 1
2 1
4 1
6 1
8 1
10.56302501		0.9995
15.56302501		0.8655
17.56302501		0.6765
20.56302501		0.3365
25.56302501		0.041
29.56302501		0.0045
34.56302501		0.0003
];

snr_ber_mode8=[
-2 1
0 1
2 1
4 1
6 1
8 1
10.05149978		0.9945
15.05149978		0.747
17.05149978		0.5175
20.05149978		0.213
23.05149978		0.0495
27.05149978		0.004
];


p(1,:) = polyfit(snr_ber_mode1(:,1), log(snr_ber_mode1(:,2)), exp_n);
p(2,:) = polyfit(snr_ber_mode2(:,1), log(snr_ber_mode2(:,2)), exp_n);
p(3,:) = polyfit(snr_ber_mode3(:,1), log(snr_ber_mode3(:,2)), exp_n);
p(4,:) = polyfit(snr_ber_mode4(:,1), log(snr_ber_mode4(:,2)), exp_n);
p(5,:) = polyfit(snr_ber_mode5(:,1), log(snr_ber_mode5(:,2)), exp_n);
p(6,:) = polyfit(snr_ber_mode6(:,1), log(snr_ber_mode6(:,2)), exp_n);
p(7,:) = polyfit(snr_ber_mode7(:,1), log(snr_ber_mode7(:,2)), exp_n);
p(8,:) = polyfit(snr_ber_mode8(:,1), log(snr_ber_mode8(:,2)), exp_n);


for ii=1:sRate_mode
    per(ii,1:length(snr)) =min(1, exp(polyval(p(rate_mode(ii),:), snr)));
end
if 0
    figure(1);
    for ii=1:sRate_mode
        semilogy(snr,  per(ii,:));
        grid on;
    end
    axis([0 35 0.01 1]);
end
return;