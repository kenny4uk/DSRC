
function [d new_pos] =range(v,t,x_max,ap,n,oldp )
for i=1:n

 theta_rand=2*pi*rand();
 new_pos(i,1)=  oldp(i, 1)+v*t* cos(theta_rand);
new_pos(i,2)= oldp(i, 2)+v*t* sin(theta_rand);
 R= sqrt((new_pos(i,1)-150).^2 +new_pos(i,2).^2);

if R>x_max
   new_pos(i,1)=ap(1);
  new_pos(i,2)= ap(2);
end
d(i)= sqrt((new_pos(i,1)-150).^2 +new_pos(i,2).^2);
end

