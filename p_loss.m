% Sub Program
%
% p_loss.m
%
% This function calculates Path loss of each user
%
%
%

%%%%%%%%%%%%%%%% preparation part %%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ploss] = p_loss(cars,xpos,ypos)
frequency = 2100; % UMT frequency
height_t = 200; 
height_r = 1.8;
a = 0.8 + (1.1 * log10(frequency) - 0.7) * height_r - 1.56 * log10(frequency); % Small sized city
j = 0;
while j <= cars
    j = j + 1;
    if j > cars
        break
    end
    dist = sqrt (xpos (1,j) ^ 2 + ypos (1,j) ^ 2);
    loss = 69.55 + 26.16 * log10 (frequency) - 13.82 * log10 (height_t) - a + (44.9 - 6.55 * log10(height_t)) * log10(dist);    
    ploss(j,1) = 10 ^ (loss/10);
end
end
%******* end of file *******%