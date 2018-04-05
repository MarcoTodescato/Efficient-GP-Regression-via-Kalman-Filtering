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

close all
clear
clc

% add current (sub)folder to the path
addpath(genpath('./'))

% load necesary parameters
loadParameters

% generate data
[F,Y,noiseVar] = loadDataSet(Params.data);

% nonparametric posterior GP 
[postMeanNp, postCovNp, exeTimeNp] = nonparametricEstimation(Params.data, Params.np, Y, noiseVar);

% nonparametric predicted GP
[predMeanNp, predCovNp, exeTimeNpPred] = nonparametricPrediction(Params.data, Params.np, Y, noiseVar);

% GPKF (gaussian process kalman filter) estimate
[postMeanKf, postCovKf, exeTimeKf, ~] = gpkfEstimation(Params.data, Params.gpkf, Y, noiseVar);

% GPKF (gaussian process kalman filter) prediction
[predMeanKf, predCovKf, exeTimeKfPred] = gpkfPrediction(Params.data, Params.gpkf, Y, noiseVar);


%% plotting some results
plotResults
