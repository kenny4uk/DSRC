function [d new_pos output]=mob_model(t,v,old_pos,ap,commRange,n,x_max)
net_pos=zeros(1,length(old_pos));
for i=1:n
net_pos(i)=old_pos(i)+v(i)*t;
if net_pos>x_max
   new_pos(i)=net_pos(i)-(net_pos(i)>x_max)*x_max;% This gives the new positon if current position is greates than x_max
else
    new_pos(i)=net_pos(i)+(net_pos(i)<0)*x_max; %This gives the new positon if current position is less than x_max
end
d(i)=abs(new_pos(i)-ap(1));% This gives the distance between the new_position and AP
if d(i)<commRange
      output(i)=1;
else
    output(i)=0;
end
%      j=0;
%     k=output==1;
%     for j=1:k
%     Mac.Wmin(j)=(j+1)*Mac.Wmin;
%     Mac.Bk_cnt(j)=floor(Mac.Wmin(j)*rand());
%     end
end
    
    

 