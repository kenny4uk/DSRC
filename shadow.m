% Sub-Program
%
% shadow.m
%
% This function generates attenuation of shadowing	
%
% 
%

function [x] =  shadow()
sigma = 6.5; %standard deviation of shadowing
anoz = randn;
db = sigma * anoz;
x = power(10.0, 0.1*db);

%******* end of file *********