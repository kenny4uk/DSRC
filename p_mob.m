function new_pos=p_mob(t,v,old_pos,x_max)
% n=length(old_pos);
net_pos=old_pos+v*t;
  new_pos=net_pos-(net_pos>x_max)*x_max;% This gives the new positon if current position is greates than x_max
 new_posMin=net_pos+(net_pos<0)*x_max;%This gives the new positon if current position is less than x_max
  end

 