function newState = mobility(v,distance)

 v = 100;  % 100 m/s   Constant velocity
 distance = [iniDist 100 110 120 130 140 150 160 170 180 190 200];
 leth = length(distance);
 direction = 2*pi*rand(1,leth);
 
 

iniDist = floor(10+10*rand(1)); % generate a number between 10 and 20

% Suppose we get the initial state [0 0]
t = zeros(1,leth);
p = zeros(1,leth);
% 200m as Position of the Access point
R=400, % 400m is the Network range 

ap = [200 0];
% Placing the position of AP at the middle of the network range

p(1) = distance(1); 
ptem = p;
for i = 2:leth
    p(i) = distance(i) + p(i-1);
    ptem(i) = distance(i) + ptem(i-1);
    if p(i)>R
        p(i) = p(i)-R;
    end
    t(i) = (t(1) + (ptem(i)-ptem(1)))./v;
end 

newState = [t' p'];   
