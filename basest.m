% Program 7-2
% 
% basest.m
%
% This function sets positions of the base stations.

%

function [out] =  basest()

baseinfo(1, 1) = 0.0;
baseinfo(1, 2) = 0.0;
baseinfo(2, 1) = -0.5*sqrt(3.0);
baseinfo(2, 2) = 1.5;
baseinfo(3, 1) = -sqrt(3.0);
baseinfo(3, 2) = 0.0;
baseinfo(4, 1) = -0.5*sqrt(3.0);
baseinfo(4, 2) = -1.5;
baseinfo(5, 1) = 0.5*sqrt(3.0);
baseinfo(5, 2) = -1.5;
baseinfo(6, 1) = sqrt(3.0);
baseinfo(6, 2) = 0.0;
baseinfo(7, 1) = 0.5*sqrt(3.0);
baseinfo(7, 2) = 1.5;
baseinfo(8, 1) = 0.0;
baseinfo(8, 2) = 3.0;
baseinfo(9, 1) = -sqrt(3.0);
baseinfo(9, 2) = 3.0;
baseinfo(10, 1) = -1.5*sqrt(3.0);
baseinfo(10, 2) = 1.5;
baseinfo(11, 1) = -2.0*sqrt(3.0);
baseinfo(11, 2) = 0.0;
baseinfo(12, 1) = -1.5*sqrt(3.0);
baseinfo(12, 2) = -1.5;
baseinfo(13, 1) = -sqrt(3.0);
baseinfo(13, 2) = -3.0;
baseinfo(14, 1) = 0.0;
baseinfo(14, 2) = -3.0;
baseinfo(15, 1) = sqrt(3.0);
baseinfo(15, 2) = -3.0;
baseinfo(16, 1) = 1.5*sqrt(3.0);
baseinfo(16, 2) = -1.5;
baseinfo(17, 1) = 2.0*sqrt(3.0);
baseinfo(17, 2) = 0.0;
baseinfo(18, 1) = 1.5*sqrt(3.0);
baseinfo(18, 2) = 1.5;
baseinfo(19, 1) = sqrt(3.0);
baseinfo(19, 2) = 3.0;

out = baseinfo;
plot (baseinfo(:,1),baseinfo(:,2),'+')
print -depsc Base_Station_Position.eps
%******* end of file *********