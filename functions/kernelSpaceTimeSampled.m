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
% kernelSpaceTimeSampled returns sampled space-time kernel
%   K = kernelSpaceTimeSampled(space_locs, time_instants, kernel_param) build the 
%   space and time kernels, sample them in the desired set of input 
%   locations and returns the kernel (given as input function) sampled 
%   across the desired input set.
%   Consistency among kernel function and input sets must be priorly ensure
%   by the user
function K = kernelSpaceTimeSampled(space_locs1, space_locs2, time_instants1, time_instants2, param)

% This way of sampling the space-time kernel is just one possibility. It
% would be possible to directly use the function kernelSampled by properly
% specifying the input sets. However, this implementation is more efficient

% compute kernel functions
kernel_space = kernelFunction(param.space.type, param.space);
kernel_time = kernelFunction(param.time.type , param.time);

% sampled kernels
Ks = kernelSampled(space_locs1, space_locs2, kernel_space);
Kt = kernelSampled(time_instants1, time_instants2, kernel_time);

% overall space-time kernel
K = kron(Kt,Ks);

end
    