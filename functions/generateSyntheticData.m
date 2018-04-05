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
% generateSyntheticData synthetic data from multivariate normal distribution
%   [F,Y,noiseVar] = generateSyntheticData(param) returns a data set of samples of a
%   spatio-temporal GP described by a desired covariance (kernel)
function [F,Y,noiseVar] = generateSyntheticData(param)

% create space-time sampled kernel
K = kernelSpaceTimeSampled(param.spaceLocs, param.spaceLocs, param.timeInstants, param.timeInstants, param.kernel);

% sample "true" (zero mean) GP and measurements
f = mvnrnd(zeros(1,size(K,1)),K,1)';

% rearganization in matrix form (row:space, columns:time)
numSpaceLocs = length(param.spaceLocs);
numTimeInst = length(param.timeInstants);
F = reshape(f , [numSpaceLocs , numTimeInst]);

% create measurements
numSpaceLocsMeas = length(param.spaceLocsMeas);
Y = F(param.spaceLocsMeas,:) + param.noiseStd * randn(numSpaceLocsMeas,numTimeInst); 

% delete (randomly) some measurements and build measurement cov matrix
noiseVar = param.noiseStd^2 * ones(numSpaceLocsMeas,numTimeInst);
for t = 1:numTimeInst
    idx = sort(randperm(numSpaceLocsMeas, randi(numSpaceLocsMeas)))';
    Y(idx,t) = nan;
    noiseVar(idx,t) = Inf;
end

end

