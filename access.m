%
% 
% access.m
%
% This function sets positions of the access points.
%
%%
%

function [out] =  access()

accessinfo(1, 1) = 0.0;
accessinfo(1, 2) = 0.0;
accessinfo(2, 1) = -0.5*sqrt(3.0);
accessinfo(2, 2) = 1.5;
accessinfo(3, 1) = -sqrt(3.0);
accessinfo(3, 2) = 0.0;
accessinfo(4, 1) = -0.5*sqrt(3.0);
accessinfo(4, 2) = -1.5;
accessinfo(5, 1) = 0.5*sqrt(3.0);
accessinfo(5, 2) = -1.5;
accessinfo(6, 1) = sqrt(3.0);
accessinfo(6, 2) = 0.0;
accessinfo(7, 1) = 0.5*sqrt(3.0);
accessinfo(7, 2) = 1.5;
accessinfo(8, 1) = 0.0;
accessinfo(8, 2) = 3.0;
accessinfo(9, 1) = -sqrt(3.0);
accessinfo(9, 2) = 3.0;
accessinfo(10, 1) = -1.5*sqrt(3.0);
accessinfo(10, 2) = 1.5;
accessinfo(11, 1) = -2.0*sqrt(3.0);
accessinfo(11, 2) = 0.0;
accessinfo(12, 1) = -1.5*sqrt(3.0);
accessinfo(12, 2) = -1.5;
accessinfo(13, 1) = -sqrt(3.0);
accessinfo(13, 2) = -3.0;
accessinfo(14, 1) = 0.0;
accessinfo(14, 2) = -3.0;
accessinfo(15, 1) = sqrt(3.0);
accessinfo(15, 2) = -3.0;
accessinfo(16, 1) = 1.5*sqrt(3.0);
accessinfo(16, 2) = -1.5;
accessinfo(17, 1) = 2.0*sqrt(3.0);
accessinfo(17, 2) = 0.0;
accessinfo(18, 1) = 1.5*sqrt(3.0);
accessinfo(18, 2) = 1.5;
accessinfo(19, 1) = sqrt(3.0);
accessinfo(19, 2) = 3.0;

out = accessinfo;
plot (accessinfo(:,1),accessinfo(:,2),'+')
print -depsc access_point_Position.eps
%******* end of file *********