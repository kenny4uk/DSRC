function new_speed=v_mob(old_speed,v_max)
%  n=length(sNode);
net_speed=old_speed+rand(1)*0.941872;% This gives the new speed with specified value of AR of order 1
new_speed=net_speed-(net_speed>v_max)*v_max;% This gives the new speed if current speed is greater than v_max
new_speed=net_speed+(net_speed<0)*v_max;%This gives the new speed if current speed is less than v_max
  end

 