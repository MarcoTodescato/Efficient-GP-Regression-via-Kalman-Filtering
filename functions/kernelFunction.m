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
% FUNTION DESCRIPTION
% kernelFunction Desired kernel function
%   kernel = kernelFunction(type,kernel_specific_parameter) return a function
%   describing the desired kernel.
%
%   INPUT: type: kernel type
%          varargin: necessary (kernel specific) paremeters. 
%                  Consistency must be ensured by the user
%   OUTPUT: kernel: kernel function
function kernel = kernelFunction(type,varargin)

params = varargin{:};

switch type
    case 'separable'
        ks = kernelFunction(params.space.type,params.space.scale,params.space.std);
        kt = kernelFunction(params.time.type,params.time.scale,params.time.std);
        kernel = @(x1,x2)  kt(x1(1),x2(1)) * ks(x1(2:end),x2(2:end));
            
    case 'exponential'
        scale = params.scale;
        std_dev = params.std;
        kernel = @(x1,x2) scale * exp(-norm(x1-x2) / std_dev);         

    case 'gaussian'
        scale = params.scale;
        std_dev = params.std;
        kernel = @(x1,x2) scale * exp(-norm(x1-x2)^2 / (2*std_dev^2));
        
    case 'periodic'
        scale = params.scale;
        std_dev = params.std;
        frequency = params.frequency;
        kernel = @(x1,x2) scale * cos(2*pi*frequency * norm(x1-x2)) * exp(-norm(x1-x2)/std_dev);
        
    otherwise
        error('kernelFunction:InountError','Unknown type of kernel');
end
end
