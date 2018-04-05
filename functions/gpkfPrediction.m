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
%   [predictedMean, predictedCov, exeTime] = gpkfPrediction(paramData, paramGpkf, meas, noiseVar)
%   returns kalman prediction accoring to the propose GPKF algorithm
%
% INPUT: data and Gpkf specific parameters, measurements and corresponding
%       noise variance matrix
%
% OUTPUT: predictedMean, predictedCov: kalman estimates
%         exeTime: value of the exe time per iteration
function [predictedMean, predictedCov, exeTime] = ...
                gpkfPrediction(paramData, paramGpkf, meas, noiseVar)                       

% first run the GPKF estimation            
[postMean, postCov, ~, ~] = gpkfEstimation(paramData, paramGpkf, meas, noiseVar);

kernel_space = kernelFunction(paramGpkf.kernel.space.type, paramGpkf.kernel.space);
kernelSection = kernelSampled(paramData.spaceLocsPred, paramData.spaceLocsMeas, kernel_space);
kernelPrediction = kernelSampled(paramData.spaceLocsPred, paramData.spaceLocsPred, kernel_space);
Ks = kernelSampled(paramData.spaceLocsMeas, paramData.spaceLocsMeas, kernel_space);
I = eye(size(Ks));
Ks_inv = I/Ks;

numSpaceLocsPred = length(paramData.spaceLocsPred);
numTimeInsts = length(paramData.timeInstants);
predictedCov = zeros(numSpaceLocsPred, numSpaceLocsPred, numTimeInsts);
scale = paramGpkf.kernel.time.scale;

tStart = tic;

predictedMean = kernelSection * (Ks_inv * postMean);
        
for t = 1:length(paramData.timeInstants)
    W = Ks_inv * (Ks - postCov(:,:,t)/scale) * Ks_inv;
    predictedCov(:,:,t) = scale * (kernelPrediction - (kernelSection * W * kernelSection'));
end

exeTime = toc(tStart)/numTimeInsts;
end

