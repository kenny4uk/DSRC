function [result] = posmob(v,t)
n=size(t,2);
p=0;
result=[];
distance = ones(1,n);
for k = 2:n
    distance(k) = 50 + floor(50*rand(1));  % distance from node k to node k+1
end

iniDist = floor(10+10*rand(1)); % generate initial distance
distance(1) = iniDist;
 
% define the moving direction, which is represented with the angle to x-axis
direction = ones(1,n);  
for k = 1:n
    direction(k) = 2*pi*rand(1);  % the angle values are between 0 and 2*pi
end
 
%t = zeros(1,sNode);   % define the time used at each stage during the moving process
pDist = zeros(1,n);  % define the total distance traveled at each stage during the process
pDist(1) = distance(1);

pos = zeros(n, 1);  % define the position of every nodes with x co-ordinates
pos(1,1) = distance(1)*cos(direction(1));   % the first column represents x co-ordinate
ap=400;
range=800;

for i = 2:n    % i start from 2 because the initial node has been defined
    pDist(i) = distance(i) + pDist(i-1);    % total distance of current node i is equal to the previous plus travel distance from i-1 to i
    pos(i,1) = distance(i)*cos(direction(1)) + pos(i-1,1);  % x co-ordinate of new node 'i'
   
    % calculating the distance between new node and AP, if it's out of range, pull it back to the center(AP) 
    R = sqrt((pos(i,1)-ap(1)).^2);  % distance between node i and AP
    if R > range     
        pos(i,1) = ap(1);
        end
 p(i) = v*t(i)+p(i-1);
 result(i)=p(i);
end 
   %disp(t);
      %disp('NewPositions  of the node are ');

