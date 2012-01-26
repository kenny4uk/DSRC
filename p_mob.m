function new_pos=p_mob(t,v,old_pos,x_max)
% n=length(old_pos);
new_pos=old_pos+v*t;
  new_pos=new_pos-(new_pos>x_max)*x_max;% This gives the new positon if current position is greates than x_max
 new_pos=new_pos+(new_pos<0)*x_max;%This gives the new positon if current position is less than x_max
  end

 