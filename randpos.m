
% randpos.m
%
% This function generates the position of cars
%

%%%%%%%%%%%%%%%% preparation part %%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xpos,ypos] = randpos(cars,R)
    radium_rand = R * rand(1,cars);
    theta_rand = 2 * pi * rand(1,cars);
    
    xpos = radium_rand .* cos(theta_rand); % generate x co-ordinate for the  cars;
    ypos = radium_rand .* sin(theta_rand); % generate y co-ordinate for  the cars;    
    plot (xpos(1,:),ypos(1,:),'+')
    print -depsc cars_Position.eps
end
%******* end of file *********