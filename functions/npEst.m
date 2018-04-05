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
% npEst implements classica nonparametric estimation
%   [posteriorMean, posteriorCov, exeTime] = npEst(sampledKernel, noiseVar, meas) 
%   returns the nonparametric estimate (posterior GP distribution) conditioned 
%   on the input data.
function [posteriorMean, posteriorCov, exeTime] = npEst(kernelSampled, meas, noiseVar)

startTime = tic;

notNanPos = ~isnan(meas);

I = eye(sum(notNanPos));
KK = I/(kernelSampled(notNanPos,notNanPos) + noiseVar(notNanPos,notNanPos));
posteriorMean = kernelSampled(:,notNanPos) * (KK*meas(notNanPos));
posteriorCov = kernelSampled - kernelSampled(:,notNanPos)*KK*(kernelSampled(:,notNanPos)');

exeTime = toc(startTime);


end

