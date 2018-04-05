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
% kalmanEst kalman filter estimation
%   [x,V,xp,Vp,exeTimePerIter,logMarginal] = kalmanEst(A, C, Q, V0, meas, noiseVar) 
%   returns the prediction and corrections computed by means of standard
%   iterative kalman filtering procedure
%
% INPUT: (A,C,Q,V0) model matrices, meas vector of measuremenst, noiseVar
% corresponding noise variance matrix
%
% OUTPUT: x,V,xp,Vp estimates and predictins with corresponding covariance.
%          exeTimePerIter average time per kalman iteration
%          logMarginal marginal log-likelihood
function [x,V,xp,Vp,exeTimePerIter,logMarginal] = kalmanEst(A, C, Q, V0, meas, noiseVar)



numTimeInstants = size(meas,2);
stateDim = size(A,1);
I = eye(stateDim); 
times = zeros(numTimeInstants,1);
logMarginal = 0;

% initialization
xt = zeros(stateDim,1);
Vt = V0;
xp = zeros(stateDim,numTimeInstants);
Vp = zeros(stateDim,stateDim,numTimeInstants);
x = zeros(stateDim,numTimeInstants);
V = zeros(stateDim,stateDim,numTimeInstants);

for t = 1:numTimeInstants;
    
    tstart = tic;
  
    % prediction
    xpt = A*xt;
    Vpt = A*Vt*A' + Q;
    
    % correction
    notNanPos = ~isnan(meas(:,t));
    Ct = C(notNanPos,:);
    Rt = noiseVar(notNanPos, notNanPos, t);
    
    innovation = meas(notNanPos,t) -  Ct * xpt;
    innovVar = Ct * Vpt * Ct' + Rt;
    K = (Vpt * Ct')/innovVar;   % kalman gain
    correction = K*innovation;
    
    xt = xpt + correction;
    Vt = (I - K*Ct) * Vpt *(I - K*Ct)' + K * Rt * K';
  
    times(t) = toc(tstart);
    
    % save values
    xp(:,t) = xpt;
    Vp(:,:,t) = Vpt;
    x(:,t) = xt;
    V(:,:,t) = Vt;
      
    % computations for the marginal likelihood
    l1 = sum(log(eig(innovVar)));
    l2 = innovation'*(innovVar\innovation);
    logMarginal = logMarginal +  0.5*(length(innovation)*log(2*pi) + l1 + l2);
    
end

% average time per iter
exeTimePerIter = mean(times);

