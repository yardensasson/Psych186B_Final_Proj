function f = activation_fn(activation_values)
% Takes in a matrix of activation units and returns a sigmoid of the values
%
% INPUT: 
%   activation_value - 
% 
% OUTPUT:
%   f - 

f = 1./(1+exp(-activation_values));

end