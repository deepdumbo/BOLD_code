function SE = MTC_ASE_extra(TAU,PARAMS)
% MTC_ASE_extra usage:
%
%        SE = MTC_ASE_extra(TAU,PARAMS)
% 
% For use in MTC_qBOLD.m and related scripts.
%
% Based on MTC_ASE_tissue, but for extracellular (CSF) signal 
%
% Calculate the MRI signal contribution from CSF. Takes a vector of offset
% values TAU and a struct PARAMS containing the necessary constants.
% Returns a vector SE, of the same length as TAU, containing the measured
% MRI signal strength for each TAU.
% 
% MT Cherukara
% 17 May 2016

% pull out constants
R2e = PARAMS.R2e;
df  = PARAMS.dF;
TE  = PARAMS.TE;

% calculate signal
SE = exp( -(R2e.*TE) - 4i.*pi.*df.*abs(TAU));
SE = real(SE);

