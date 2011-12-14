function result=p_mob(v,t)
x_max=1000;% this is  the maximum  range of transmission for the nodes
max_speed= 70;
min_speed= 50;
ap=[500 0];    
n=40;
v=[min_speed:max_speed];
t=zeros(1,n);
v=zeros(1,n);
n=size(t,2);
p_max=rand(1,n)*x_max;
%s=100*rand(1)*max_speed;
result=[];
old_pos=zeros(1,n);
for i=1:n
        old_pos(i)=x_max*rand(1,1);
end
%old_speed=zeros(1,n);
    %for i=1:n
       % old_speed(i)=min_speed+(max_speed-min_speed)*rand(1)*100;
    %end

for i=1:n
    new_pos(i)=old_pos(i)+v(i)*t(i)
    %new_speed(i)=old_speed(i)+rand(1)*10;
end
for i=2:n
    if p_max>x_max
        new_pos(i)=new_pos(i)-x_max(i)
               end
    end
 