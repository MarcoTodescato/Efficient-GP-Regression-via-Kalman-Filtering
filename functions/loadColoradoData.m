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
% loadColoradoData data from colorado rain dataset
%   [F,Y,noiseVar] = loadColoradoData(param) returns a data set of samples 
%   from the colorado rainfall data set. For more info see
%   https://www.image.ucar.edu/Data/US.monthly.met/CO.shtml
function [F,Y,noiseVar] = loadColoradoData(param)

data = load(param.path);

F = data.measurementsPpt(:, param.timeInstants);    % in the absence of ground truth we use the measurements 

Y = data.measurementsPpt(param.spaceLocsMeasIdx, param.timeInstants);

noiseVar = (param.noiseStd .* abs(Y)).^2;
noiseVar(isnan(noiseVar)) = Inf;
noiseVar(Y==0) = param.noiseStd^2;

end
