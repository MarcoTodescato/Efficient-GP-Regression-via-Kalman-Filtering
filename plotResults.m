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

%%%%%%%%%%%%%%%%%%%%%%%%%%% plotting some results %%%%%%%%%%%%%%%%%%%%%%%%%
close all

% ESTIMATION
% space
figure
hold on
grid on
plot(F(Params.data.spaceLocsMeasIdx,end), 'b');
plot(postMeanNp(:,end), 'r:');
fill([(1:length(Params.data.spaceLocsMeasIdx))';flip((1:length(Params.data.spaceLocsMeasIdx))')], ...
     [postMeanNp(:,end) + 3*sqrt(abs(diag(postCovNp(:,:,end)))); ...
      flip(postMeanNp(:,end) - 3*sqrt(abs(diag(postCovNp(:,:,end)))))], ...
      'r', 'EdgeColor','r','FaceAlpha',0.2);
plot(postMeanKf(:,end), 'g--');
fill([(1:length(Params.data.spaceLocsMeasIdx))';flip((1:length(Params.data.spaceLocsMeasIdx))')], ...
     [postMeanKf(:,end) + 3*sqrt(abs(diag(postCovKf(:,:,end)))); ...
      flip(postMeanKf(:,end) - 3*sqrt(abs(diag(postCovKf(:,:,end)))))], ...
      'g', 'EdgeColor','g','FaceAlpha',0.2);
legend('true GP', 'np post mean (smoothing)', 'np post cov', 'gpkf post mean', 'gpkf post cov');
xlabel('measured space locations index')
title('Space estimation')
hold off
pbaspect([1 0.5 1])

% time
idx_m = randi(length(Params.data.spaceLocsMeasIdx),1);
figure
hold on
grid on
plot(F(Params.data.spaceLocsMeasIdx(idx_m),:), 'b');
plot(postMeanNp(idx_m,:), 'r:');
fill([(1:length(Params.data.timeInstants))';flip((1:length(Params.data.timeInstants))')], ...
     [postMeanNp(idx_m,:)' + 3*sqrt(abs(squeeze(postCovNp(idx_m,idx_m,:)))); ...
      flip(postMeanNp(idx_m,:)' - 3*sqrt(abs(squeeze(postCovNp(idx_m,idx_m,:)))))], ...
      'r', 'EdgeColor','r','FaceAlpha',0.2);
plot(postMeanKf(idx_m,:), 'g--');
fill([(1:length(Params.data.timeInstants))';flip((1:length(Params.data.timeInstants))')], ...
     [postMeanKf(idx_m,:)' + 3*sqrt(abs(squeeze(postCovKf(idx_m,idx_m,:)))); ...
      flip(postMeanKf(idx_m,:)' - 3*sqrt(abs(squeeze(postCovKf(idx_m,idx_m,:)))))], ...
      'g', 'EdgeColor','g','FaceAlpha',0.2);
legend('true GP', 'np post mean (smoothing)', 'np post cov', 'gpkf post mean', 'gpkf post cov');
xlabel('time instants')
title('Time evolution (estimation)')
hold off
pbaspect([1 0.5 1])

% PREDICTION
% space
figure
hold on
grid on
plot(F(Params.data.spaceLocsPredIdx,end), 'b');
plot(predMeanNp(:,end), 'r:');
fill([(1:length(Params.data.spaceLocsPredIdx))';flip((1:length(Params.data.spaceLocsPredIdx))')], ...
     [predMeanNp(:,end) + 3*sqrt(abs(diag(predCovNp(:,:,end)))); ...
      flip(predMeanNp(:,end) - 3*sqrt(abs(diag(predCovNp(:,:,end)))))], ...
      'r', 'EdgeColor','r','FaceAlpha',0.2);
plot(predMeanKf(:,end), 'g--');
fill([(1:length(Params.data.spaceLocsPredIdx))';flip((1:length(Params.data.spaceLocsPredIdx))')], ...
     [predMeanKf(:,end) + 3*sqrt(abs(diag(predCovKf(:,:,end)))); ...
      flip(predMeanKf(:,end) - 3*sqrt(abs(diag(predCovKf(:,:,end)))))], ...
      'g', 'EdgeColor','g','FaceAlpha',0.2);
legend('true GP', 'np pred mean (smoothing)', 'np pred cov', 'gpkf pred mean', 'gpkf pred cov');
xlabel('predicted space locations index')
title('Space prediction')
hold off
pbaspect([1 0.5 1])

% time
idx_p = randi(length(Params.data.spaceLocsPredIdx),1);
figure
hold on
grid on
plot(F(Params.data.spaceLocsPredIdx(idx_p),:), 'b');
plot(predMeanNp(idx_p,:), 'r:');
fill([(1:length(Params.data.timeInstants))';flip((1:length(Params.data.timeInstants))')], ...
     [predMeanNp(idx_p,:)' + 3*sqrt(abs(squeeze(predCovNp(idx_p,idx_p,:)))); ...
      flip(predMeanNp(idx_p,:)' - 3*sqrt(abs(squeeze(predCovNp(idx_p,idx_p,:)))))], ...
      'r', 'EdgeColor','r','FaceAlpha',0.2);
plot(predMeanKf(idx_p,:), 'g--');
fill([(1:length(Params.data.timeInstants))';flip((1:length(Params.data.timeInstants))')], ...
     [predMeanKf(idx_p,:)' + 3*sqrt(abs(squeeze(predCovKf(idx_p,idx_p,:)))); ...
      flip(predMeanKf(idx_p,:)' - 3*sqrt(abs(squeeze(predCovKf(idx_p,idx_p,:)))))], ...
      'g', 'EdgeColor','g','FaceAlpha',0.2);
legend('true GP', 'np post mean (smoothing)', 'np post cov', 'gpkf post mean', 'gpkf post cov');
xlabel('time instants')
title('Time evolution (prediction)')
hold off
pbaspect([1 0.5 1])
