function S = MTC_qASE_model(T,PARAMS,noDW)
    % MTC_qASE_model.m usage:
    %
    %       S = MTC_qASE_model(T,PARAMS)
    %
    % For use in MTC_Asymmetric_Bayes.m and derived scripts; based on
    % MTC_qBOLD_metro.m, but using a tau-dependent ASE model
    %
    % Calculates the signal vs. tau relationship of a single voxel, for values
    % of tau T, using parameter struct PARAMS. Output S is the same size as T.
    %
    % Uses method described by Yablonskiy & Haacke, 1994, and others.
    %
    % 
    %       Copyright (C) University of Oxford, 2016-2017
    %
    % 
    % Created by MT Cherukara, 16 May 2016
    %
    % CHANGELOG:
    %
    % 2017-08-07 (MTC). Added a control in the form of PARAMS.noDW to
    %       change the way things are done when we're trying to infer on R2' 
    %       
    % 2017-07-10 (MTC). Commented out the PARAMS.dw recalculation in order
    %       to use this for the R2' and zeta estimation (alongside
    %       MTC_qASE_model_long.m). This should be put back to normal if
    %       using this for any other grid-search (e.g. the classic OEF-DBV)
    %
    % 2016-05-27 (MTC). Updated the way the compartments were summed up.
   
    
% UPDATE PARAMETERS:

if ~exist('noDW','var')
    noDW = 0;
end

% characteristic frequency - this will not be calculated if doing R2'-DBV inference
if noDW
    % if we are inferring on R2', we want to change the order we do things
    % in slightly:
    PARAMS.dw = PARAMS.R2p ./ PARAMS.zeta;
    PARAMS.OEF = PARAMS.dw ./ ( (4/3)*pi*PARAMS.gam*PARAMS.dChi*PARAMS.Hct*PARAMS.B0 );
    
else
    % otherwise, proceed as normal and calculate dw:
    PARAMS.dw   = (4/3)*pi*PARAMS.gam*PARAMS.dChi*PARAMS.Hct*PARAMS.OEF*PARAMS.B0;    
end
    
% relaxation rate constant of blood
PARAMS.R2b  = 14.9*PARAMS.Hct + 14.7 + (302.1*PARAMS.Hct + 41.8)*PARAMS.OEF^2;
PARAMS.R2bs = 16.4*PARAMS.Hct + 4.5  + (165.2*PARAMS.Hct + 55.7)*PARAMS.OEF^2;

% compartment weightings
w_tis = 1 - PARAMS.lam0 - PARAMS.zeta;
w_csf = PARAMS.lam0;
w_bld = PARAMS.zeta;

% CALCULATE MODEL:

% comparments
S_tis = w_tis.*MTC_ASE_tissue(T,PARAMS);
S_csf = w_csf.*MTC_ASE_extra(T,PARAMS);
S_bld = w_bld.*MTC_ASE_blood(T,PARAMS);

% add it all together:
S = PARAMS.S0.*(S_tis + S_csf + S_bld);