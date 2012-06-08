function [d] = EC(t,v,old_pos,ap,commRange,n,x_max)
%% definition of EC function 

net_pos=zeros(1,length(old_pos));
for i=1:n
   net_pos(i)=old_pos(i)+v(i)*t;%this gives the new position if old postion is known with speed and time
if net_pos>x_max
   new_pos(i)=net_pos(i)-(net_pos(i)>x_max)*x_max;% This gives the new positon if current position is greates than x_max
else
    new_pos(i)=net_pos(i)+(net_pos(i)<0)*x_max; %This gives the new positon if current position is less than x_max
end
d(i)=abs(new_pos(i)-ap(1));% This gives the distance between the new_position and AP
if d(i) < commRange
      output(i)=1;% this gives the output if node is in range
   else
    output(i)=0;% this gives the output if node is out of range
end
end

