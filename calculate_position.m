function [result] = calculate_position(vn,tn,dn)
n=size(vn,2);
pn=0;
result=[];
for i=1:1
    pn = vn(i)*tn(i)+dn(i);% calculates new position of the nodes, with given speed, time and distance
     result(i)=pn;
end