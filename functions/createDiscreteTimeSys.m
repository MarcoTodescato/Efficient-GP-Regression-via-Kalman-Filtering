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
% createDiscreteTimeSys build the discrete time ss system.
%   [A,C,V,Q] = createDiscreteTimeSys(num_coeff,den_coeff,Ts) builds the
%   discrete time ss system in canonical form, given the numerator and
%   denominator coefficients of the companion form
%
%   INPUT: numerator, denominator coefficients and samplit time Ts for the
%           discretization
%
%   OUTPUT: matrix A,C,V,Q: respectively, state matrix, output matrix,
%           state variance matrix (solution of lyapunov equation), 
%           and measurement variance matrix
function [A,C,V,Q] = createDiscreteTimeSys(num_coeff,den_coeff,Ts)

% state dimension
stateDim  = length(den_coeff);

% state matrix
F = diag(ones(1,stateDim-1),1);
F(stateDim,:) = -den_coeff;

% input matrix
G = [zeros(stateDim-1 ,1);1];

% output matrix
C = zeros(1,stateDim);
C(1:length(num_coeff)) = num_coeff;

% discretization
A = expm(F*Ts);  % state matrix

% state variance as solution of the lyapunov equation
V = lyap(F,G*G');

% discretization of the noise matrix
Q = zeros(stateDim);
Ns = 10000;                   
t = Ts/Ns;
for n = t:t:Ts
    Q = Q + t * expm(F*n)*(G*G')*expm(F*n)';
end




