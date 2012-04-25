
function [d xpos ypos] =range(v,t,x_max,ap,n,oldp )
 new_pos=zeros(size(oldp,1),size(oldp,2));
for i=1:n
    for j=1:2
 theta_rand=2*pi*rand()*300;
%  new_pos(i,j)=  oldp(i,j)+v(i)*t* cos(theta_rand);
 new_pos(i,j)=  oldp(i,j)+v(i)*t;
 xpos =new_pos (i,j) .* cos(theta_rand); % generate the new position with respect to x co-ordinate for the  cars;
ypos = new_pos (i,j) .* sin(theta_rand); % generate the new position with respect to y co-ordinate for the  cars;
    end
d(i)= sqrt((new_pos(i,1)-ap(1))^2 +new_pos(i,2)^2);
 end
end

