% Sub Program
%
% Noise_Power.m
%
% This program generate Thermal Noise

function [noise_w] = Noise_Power(BW)
Tc = 25; % Temperature in Degree Celcius
k = 1.38 * 10 ^ -23; % Boltzman's Constant
T = 273.15 + Tc; % Transform Temperature into Kelvin
noise_w = 4 * k * T * BW;
end
%******* end of file *********