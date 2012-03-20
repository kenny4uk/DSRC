function new_pos=p_mob(t,v,old_pos,x_max,Txnode)
net_pos=zeros(1,length(old_pos)); 
% n=length(Txnode);
 for i=Txnode
net_pos(i)=old_pos(i)+v(i)*t;
if net_pos(i)>x_max
  new_pos(i)=net_pos(i)-(net_pos(i)-x_max);% This gives the new positon if current position is greates than x_max
else
 new_pos(i)=net_pos(i); %This gives the new positon if current position is less than x_max
end
 end
 