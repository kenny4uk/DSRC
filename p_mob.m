function new_pos=p_mob(t,v,old_pos,x_max)
n=length(old_pos);
p_max=rand(1)*x_max;
for i=1:n
new_pos(i)=old_pos(i)+v*t;
 if new_pos(i)>p_max
 new_pos(i)=new_pos(i)-p_max;
  else
  if new_pos(i)<p_max
 new_pos(i)=new_pos(i)+x_max;
        end
    end
end

 