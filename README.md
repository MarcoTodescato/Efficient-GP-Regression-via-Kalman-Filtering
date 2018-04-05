# Efficient-GP-Regression-via-Kalman-Filtering

### Repository containing simple implementation code relative to the homonimous project based on the two papers:
### [1] A.Carron, M.Todescato, R.Carli, L.Schenato, G.Pillonetto,  *Machine Learning meets Kalman Filtering*, proceedings of the *55th Conference on Decision and Control 2016*, pp. 4594-4599.
### [2] M.Todescato, A.Carron, R.Carli, G.Pillonetto, L.Schenato, *Efficient Spatio-Temporal Gaussian Regression via Kalman Filtering*, ArXiv:1705.01485, submitted to JMLR.

##### PS. The code, although based on the code used in the mentioned papers, is slightly different from that. It is a later, improved and yet, simplified version of it. Moreover, the code for the implementation of the adaptive approach presented in [2], is still not present here. 

##### File content is pretty self explaning (for brief more in detail view of each file refer to the corresponding help):
- main.m: contains the main program
- plotResults.m: produces some sample figures of the computed results
- data/: contains datasets (colorado rainfall) and additional precomputed data
- functions/: contains all the necessary functions

##### Basic Usage: run the main.m file for performing estimation and prediction. plotResults.m (called inside main.m) plots the results 
