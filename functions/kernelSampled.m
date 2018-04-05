% Efficient Spatio-Temporal Gaussian Process learning via Kalman Filtering
%
% Copyright (C) 2017, University of Padova
% Andrea Carron , carrona@ethz.ch
% Marco Todescato, mrc.todescato@gmail.com
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%
% FUNCTION DESCRIPTION
% kernelSampled returns sampled kernel
%   K = kernelSampled(kernel_function, varargin) returns the kernel 
%   (given as input function) sampled across the desired input set
%   Consistency among kernel function and input sets must be priorly ensure
%   by the user
function K = kernelSampled(input_set_1, input_set_2, kernel_func)
    
% cardinalities of input sets
NumInput1 = size(input_set_1,1);
NumInput2 = size(input_set_2,1);

% initialize
K = zeros(NumInput1,NumInput2);

for i = 1:NumInput1
    for j = 1:NumInput2
        K(i,j) = kernel_func(input_set_1(i,:) , input_set_2(j,:));
    end
end

end

