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
% loadDataSet load desired data set
%   [F,Y,noiseVar] = loadDataSet(params) returns data from the selected data set. 
%   F and Y are matrices containing samples of the true GP and measuremens,
%   respectively. noiseVar contains the measurement variance. It is a
%   matrix of the same size of Y.
function [F,Y,noiseVar] = loadDataSet(param)

switch param.type
    
    case 'synthetic'
        [F,Y,noiseVar] = generateSyntheticData(param);
        
    case 'colorado'
        [F,Y,noiseVar] = loadColoradoData(param);
       
    otherwise
        error('loadDataSet:InputError','Selected Dataset does not exists');
end
end

