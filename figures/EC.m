%This function is actually mob_model function
function [PER] = EC(t,v,old_pos,ap,commRange,n,x_max, ii)

% t is time
% v is speed
% old_pos is old position of the car, stop or initial position
% ap is Access point
% commRange is range of the car
% n is number of cars
% x_max is length of the road


% definition of EC function 

net_pos=zeros(1,length(old_pos));

% calculation  for each car
for i=1:n
    %This gives the new position if old postion is known with speed and time
    net_pos(i)=old_pos(i) + v(i) * t;
    if net_pos>x_max
        % This gives the new positon if current position is greates than x_max
        new_pos(i)=net_pos(i)-(net_pos(i)>x_max)*x_max;
    else
        %This gives the new positon if current position is less than x_max
        new_pos(i)=net_pos(i)+(net_pos(i)<0)*x_max; 
    end
    
    % This gives the distance between the new_position and AP
    d(i)=abs(new_pos(i)-ap(1));
end

% calculation  for each car

% probability of the packet reaching  a car depends upon the range and
% relative speed of the car
pbPkt = commRange * (v(ii+1) - v(ii));

% probability of the packet getting dropped depends upon the range and
% distance between the cars
pbPktDropped = commRange * (d(ii+1) - d(ii));

% Predicted PER = probability of packet reaching to a car, with relative speed s * probability of packet getting dropped
% due to longer distance between the cars
% PER = pbPkt + pbPktDropped;
PER = pbPkt * pbPktDropped;
% %     count = count + 1;
