function [] = kmobility(Range, ap,sNode)

%distance = ones(1,sNode);
distance =[100 110 120 130 140 150 160 170 180 190]; 
%for k = 2:sNode
    %distance(k) = 50 + floor(50*rand(1));  % distance from node k to node k+1
%end

iniDist = floor(10+10*rand(1)); % generate initial distance
distance(1) = iniDist;

v = 100;  % Constant velocity 100 m/s   
% define the moving direction, which is represented with the angle to x-axis
direction = ones(1,sNode);  
for k = 1:sNode
    direction(k) = 2*pi*rand(1);  % the angle values are between 0 and 2*pi
end
 
t = zeros(1,sNode);   % define the time used at each stage during the moving process
pDist = zeros(1,sNode);  % define the total distance traveled at each stage during the process
pDist(1) = distance(1);

pos = zeros(sNode, 2);  % define the position of every nodes with two co-ordinates
pos(1,1) = distance(1)*cos(direction(1));   % the first column represents x co-ordinate
pos(1,2) = distance(1)*sin(direction(1));   % the second column represents x co-ordinate

for i = 2:sNode    % i start from 2 because the initial node has been defined
    pDist(i) = distance(i) + pDist(i-1);    % total distance of current node i is equal to the previous plus travel distance from i-1 to i
    pos(i,1) = distance(i)*cos(direction(1)) + pos(i-1,1);  % x co-ordinate of new node 'i'
    pos(i,2) = distance(i)*sin(direction(1)) + pos(i-1,2);  % y co-ordinate of new node 'i'
    
    % calculating the distance between new node and AP, if it's out of range, pull it back to the center(AP) 
    R = sqrt((pos(i,1)-ap(1)).^2 + (pos(i,2)-ap(2)).^2);  % distance between node i and AP
    if R > Range     
        pos(i,1) = ap(1);
        pos(i,2) = ap(2);
    end
    t(i) = (t(1) + (pDist(i)-pDist(1)))./v;  % time used at stage 'i' is equal to total distance used divided by velocity
end 

% time and position of the nodes
newState = [t' pos];   
for i = 1:sNode
    disp('nodeID = ');
    disp(i);
    
    disp('Parameters of this node is ');
    disp('      Time   Xposition   Yposition ');
    disp(newState(i,:));
    
end


% grah the range circle and the position of each node
sita = 0:pi/30:2*pi;
plot(ap(1)+ Range*cos(sita), ap(2)+Range*sin(sita), 'r-', ...
     pos(:,1), pos(:,2), 'bs', 'MarkerFaceColor','b', 'Markersize',5);
grid on;
 
 
 
 