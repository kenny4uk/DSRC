
% randpos.m
%
% This function generates the position of cars
%

%%%%%%%%%%%%%%%% preparation part %%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xpos,ypos] = rand_pos_mob(t,v,old_pos,x_max)
n=length(old_pos);
 p_rand = x_max * rand(1);
 theta_rand = 2 * pi * rand(1,n);
  for i=1:n
new_pos(i)=old_pos(i)+v*t;
 if new_pos(i)>p_rand
 new_pos(i)=new_pos(i)-p_rand;
  else
  if new_pos(i)<p_rand
 new_pos(i)=new_pos(i)+x_max;
        end
    end
 xpos(i) =new_pos(i).* cos(theta_rand); % generate x co-ordinate for the  cars;
 ypos(i) = new_pos(i).* sin(theta_rand); % generate y co-ordinate for  the cars;
    plot (xpos(1,:),ypos(1,:),'+')
    print -depsc cars_Position.eps
end
%******* end of file *********