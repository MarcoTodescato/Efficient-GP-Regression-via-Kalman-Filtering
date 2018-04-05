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

% %%%%%%%%%%%%%%%%%%%%%%% simulation parameters %%%%%%%%%%%%%%%%%%%%%%%%%%

% DATA SET
Params.data.type = 'synthetic'; %current choices: 'synthetic','colorado'

switch Params.data.type
    
    % PARAMETERS FOR SYNTHETIC DATASET
    case 'synthetic'
        
        % DATA parameters
        Params.data.numLocs = 100;
        Params.data.spaceLocsIdx = (1:Params.data.numLocs)';
        Params.data.spaceLocs = (1:Params.data.numLocs)';
        
        Params.data.samplingTime = 0.5;
        Params.data.startTime = 0;
        Params.data.endTime = 10;
                
        Params.data.noiseStd = 0.5;
        
        Params.data.kernel.space.type = 'gaussian';
        Params.data.kernel.space.scale = 1;
        Params.data.kernel.space.std = 1;
        Params.data.kernel.time.type = 'exponential'; %'exponential', 'gaussian', 'periodic'
        Params.data.kernel.time.scale = 1;            % NOTE: to use gaussian kernel with GPKF
        Params.data.kernel.time.std = 1;              % scale and std must be set to 1
        Params.data.kernel.time.frequency = 1;
        
        % NONPERAMETRIC KERNEL parameter
        Params.np.kernel = Params.data.kernel;
        
        % GPKF parameters
        Params.gpkf.kernel = Params.data.kernel;
        
        % PARAMETERS FOR COLORAD DATASET
    case 'colorado'
        
        Params.data.path = './data/datasets/colorado.mat';
        
        data_colorado = load(Params.data.path);

        Params.data.numLocs = data_colorado.numStations;
        Params.data.spaceLocsIdx = (1:Params.data.numLocs)';
        Params.data.spaceLocs = data_colorado.stationsLocations;
        
        clear colorado;
        
        Params.data.samplingTime = 1;
        Params.data.startYear = 102; %[1 103]
        Params.data.endYear = 103;   %[1 103]
        Params.data.startTime = (Params.data.startYear-1) * 12 + 1;
        Params.data.endTime = Params.data.endYear * 12;
                        
        Params.data.noiseStd = 0.05;
        
        Params.np.kernel.space.type = 'exponential';
        Params.np.kernel.space.scale = 1;
        Params.np.kernel.space.std = 1/0.5853;
        Params.np.kernel.time.type = 'periodic';    %'exponential'; (in this case gaussian kernel not available at the moment)
        
        switch Params.np.kernel.time.type
            case 'exponential'
                Params.np.kernel.time.scale = 1100;
                Params.np.kernel.time.std = 1/1e-2;
                
            case 'periodic'
                Params.np.kernel.time.scale = 1338.7;
                Params.np.kernel.time.std = 1/1.1122;
                Params.np.kernel.time.frequency = 1/12;        
        end
        
        Params.gpkf.kernel = Params.np.kernel;
        
    otherwise
        error('loadParamer:InputError','Unknown data type')
end

% compute additional (common) parameters
Params.data.spaceLocsMeasIdx = sort(datasample(Params.data.spaceLocsIdx, round(0.8*Params.data.numLocs), 'Replace', false));
Params.data.spaceLocsMeas = Params.data.spaceLocs(Params.data.spaceLocsMeasIdx,:);
Params.data.spaceLocsPredIdx = setdiff(Params.data.spaceLocsIdx, Params.data.spaceLocsMeasIdx);
Params.data.spaceLocsPred = Params.data.spaceLocs(Params.data.spaceLocsPredIdx,:);

Params.data.timeInstants = (Params.data.startTime : Params.data.samplingTime : Params.data.endTime)';


% state space realization for the gpkf time kernel
switch Params.gpkf.kernel.time.type
    case 'exponential'
        Params.gpkf.kernel.time.num = sqrt(2*Params.gpkf.kernel.time.scale / Params.gpkf.kernel.time.std);
        Params.gpkf.kernel.time.den = 1/Params.gpkf.kernel.time.std;
        
    case 'gaussian'
        Params.gpkf.kernel.time.ssDim = 6;
        load(strcat('./data/gaussian_time_kernel_approximations/ssDim=',...
            num2str(Params.gpkf.kernel.time.ssDim),'_for_scale=1_std=1.mat'));
        Params.gpkf.kernel.time.num = num;
        Params.gpkf.kernel.time.den = den;
        clear num den
        
    case 'periodic'
        Params.gpkf.kernel.time.num = sqrt(2*Params.gpkf.kernel.time.scale / Params.gpkf.kernel.time.std) * ...
                    [sqrt( (1/Params.gpkf.kernel.time.std)^2 + (2*pi*Params.gpkf.kernel.time.frequency)^2) , 1];
                
        Params.gpkf.kernel.time.den = [( (1/Params.gpkf.kernel.time.std)^2 + (2*pi*Params.gpkf.kernel.time.frequency)^2 ) , ...
                                        2/Params.gpkf.kernel.time.std];
        
    otherwise
        error('loadParameters:LoadingError','Not admissible kernel type');
end

