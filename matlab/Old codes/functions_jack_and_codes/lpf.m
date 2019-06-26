function [output] = lpf(input,previous)
%Low pass filter
%   Detailed explanation goes here
output = 0.6321*input + 0.3679*previous;       %
% sys =
%  
%       1
%   ----------
%   0.01 s + 1
% 
% 0.6321
%   ----------
%   z - 0.3679
%  
% Sample time: 0.01 seconds
% Discrete-time transfer function.

end

