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
% gpkfEstimation implements the proposed GPKF
%   [posteriorMean, posteriorCov, exeTime, logMarginal] = gpkfEstimation(paramData, paramGpkf, meas, noiseVar)
%   returns the estimate of the propose GPKF algorithm
%
% INPUT: data and Gpkf specific parameters, measurements and corresponding
%       noise variance matrix
%
% OUTPUT: posteriorMean, posteriorCov: kalman estimates
%         exeTime, average exe time per iteration
%         logMarginal: value of the final marginal log-likelihood
function [posteriorMean, posteriorCov, exeTime, logMarginal] = ...
                gpkfEstimation(paramData, paramGpkf, meas, noiseVar)                       

% number of measured locations and time instants
[numSpaceLocs,numTimeInstants] = size(meas);

% create DT state space model
[a,c,v0,q] = createDiscreteTimeSys(paramGpkf.kernel.time.num,paramGpkf.kernel.time.den,paramData.samplingTime);

% create space kernel
kernel_space = kernelFunction(paramGpkf.kernel.space.type, paramGpkf.kernel.space);
Ks_chol = chol(kernelSampled(paramData.spaceLocsMeas, paramData.spaceLocsMeas, kernel_space))';

% initialize quantities needed for kalman estimation
I = eye(numSpaceLocs);
A = kron(I,a);
C = Ks_chol * kron(I,c);
V0 = kron(I,v0);
Q = kron(I,q);
R = zeros(numSpaceLocs, numSpaceLocs, numTimeInstants);
for t = 1:numTimeInstants
    R(:,:,t) = diag(noiseVar(:,t));
end

% compute kalmn estimate
[x,V,xp,Vp,exeTime,logMarginal] = kalmanEst(A,C,Q,V0,meas,R);

% output function
posteriorMean = C*x;
posteriorMeanPred = C*xp;

% posterior variance
O3 = zeros(numSpaceLocs, numSpaceLocs, numTimeInstants);
posteriorCov = O3;
posteriorCovPred = O3;
outputCov = O3;
outputCovPred = O3;
for t = 1:numTimeInstants
    
    % extract variance
    posteriorCov(:,:,t) = C * V(:,:,t) * C';
    posteriorCovPred(:,:,t) = C * Vp(:,:,t) * C'; 
    
    % compute output variance
    outputCov(:,:,t) = posteriorCov(:,:,t) + R(:,:,t);
    outputCovPred(:,:,t) = posteriorCovPred(:,:,t) + R(:,:,t);
end

end

