%
% 
% access.m
%
% This function sets positions of the access points.
%
%%
%

function [out] =  access1()

accessinfo(1, 1) = 0.0;
accessinfo(1, 2) = -0.5*sqrt(3.0);

out = accessinfo;
plot (accessinfo(:,1),accessinfo(:,2),'+')
print -depsc access_point_Position.eps
%******* end of file *********