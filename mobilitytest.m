clear all;
clc;

Range = 200;
ap = [200 0], % 400m is the Network range

nodesNum = 40;
distance = ones(1,nodesNum);    % defining the number of nodes
for k = 1:nodesNum-1
    distance(k) = randi([50 100]);
end

iniDist = floor(10+10*rand(1)); % generate a number between 10 and 20
distance(1) = iniDist;

v = 100;  % 100 m/s   Constant velocity
direction = ones(1,nodesNum);
for k = 1:nodesNum
    direction(k) = 2*pi*rand(1);
end
 
% suppose we get the initial state [0 0]
t = zeros(1,nodesNum);
pDist = zeros(1,nodesNum); 
pDist(1) = distance(1);

pos = zeros(nodesNum, 2);
pos(1,1) = distance(1)*cos(direction(1));
pos(1,2) = distance(1)*sin(direction(1));

for i = 2:nodesNum
    pDist(i) = distance(i) + pDist(i-1);
    pos(i,1) = distance(i)*cos(direction(1)) + pos(i-1,1);
    pos(i,2) = distance(i)*sin(direction(1)) + pos(i-1,2);
    R = sqrt((pos(i,1)-ap(1)).^2 + (pos(i,2)-ap(2)).^2);
    if R > Range
        pos(i,1) = ap(1);
        pos(i,2) = ap(2);
    end
    t(i) = (t(1) + (pDist(i)-pDist(1)))./v;
end 

newState = [t' pDist' pos]   

% plot(pos(:,1), pos(:,2), 'rs', 'MarkerEdgeColor','k', 'MarkerFaceColor','g','Markersize',10);

% grah the range circle
sita = 0:pi/30:2*pi;
plot(ap(1)+ Range*cos(sita), ap(2)+Range*sin(sita), 'r-', ...
     pos(:,1), pos(:,2), 'bs', 'MarkerFaceColor','b', 'Markersize',5);
grid on;
 
 
 
 