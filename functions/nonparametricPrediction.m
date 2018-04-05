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
% nonparametricPrediction wrapper for nonparametric estimation
%   [predictedMean, predictedCov, exeTime] = nonparametricPrediction(paramData, paramNp, meas, noiseVar)
%   returns the nonparametric prediction (posterior GP distribution) conditioned 
%   on the input data.
function [predictedMean, predictedCov, exeTime] = nonparametricPrediction(paramData, paramNp, meas, noiseVar)

numSpaceLocs = length(paramData.spaceLocsPred);
numTimeInst = length(paramData.timeInstants);

% sampled kernel
kernelSection = kernelSpaceTimeSampled(paramData.spaceLocsPred, paramData.spaceLocsMeas,...
                           paramData.timeInstants, paramData.timeInstants, paramNp.kernel);

kernelPrediction = kernelSpaceTimeSampled(paramData.spaceLocsPred, paramData.spaceLocsPred,...
                           paramData.timeInstants, paramData.timeInstants, paramNp.kernel);
                       
kernelSampled = kernelSpaceTimeSampled(paramData.spaceLocsMeas, paramData.spaceLocsMeas,...
                           paramData.timeInstants, paramData.timeInstants, paramNp.kernel);
                       
% reorder data (column vector)
y = meas(:);
noiseVar = sparse(diag(noiseVar(:)));

% call actual estimation routine
[predMean, predCov, exeTime] = npPred(kernelSection, kernelPrediction, kernelSampled, y, noiseVar);

% reshape
predictedMean = reshape(predMean, numSpaceLocs, numTimeInst);
predictedCov = zeros(numSpaceLocs, numSpaceLocs, numTimeInst);
for t = 1:numTimeInst 
    idx = ((1:numSpaceLocs) + (t-1) * numSpaceLocs)';
    predictedCov(:,:,t) = predCov(idx,idx);
end

end


