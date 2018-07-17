% MTC_Asymmetric_Bayes.m
% Perform Bayesian inference on ASE/BOLD data from MTC_qBOLD.m using a 2D grid
% search
%
% Based on MTC_Bayes_BOLD.m
%
% 
%       Copyright (C) University of Oxford, 2016-2018
%
% 
% Created by MT Cherukara, 17 May 2016
%
% CHANGELOG:
%
% 2018-07-16 (MTC). Parallelized using parfor, on a 6-core i5, this achieves a
%       greater than four-fold speed-up. Functionality for 1D and ND grid search
%       has been lost, but this can be added in later.
%
% 2018-03-29 (MTC). Added the means for displaying the locations of the maximum
%       values produced by a 2D grid search.
%
% 2018-02-12 (MTC). Went back to 'param_update' since it is actually much
%       faster. Removed the 3D grid search code because it was taking up space
%       (it will be in the repository somewhere).
%
% 2018-02-05 (MTC). Removed the need for the 'param_update' function. Fixed a
%       bug in the 1D grid search method.
%
% 2018-01-12 (MTC). Changed the way the posterior is calculated to actually
%       calculate log-likelihood, using the function MTC_loglike.m. This
%       technically shouldn't alter the shape of any of the posterior
%       distributions (in terms of their linearity) but should mean that our
%       selected value of SNR is 'applied' to the results correctly.
%
% 2017-10-06 (MTC). Added the option to make a 3D grid search, and made the
%       1D and 2D versions slightly more general (and less cumbersome) by
%       vectorising here and there.
%
% 2017-08-07 (MTC). Added R2'/DBV inference, and made the whole thing better
%       organised. The 1D grid search isn't working right, but it isn't
%       particularly important at this stage.
%
% 2017-04-04 (MTC). Various changes.

clear;
% close all;

% setFigureDefaults;  % since we're doing plotting later

tic;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%    Initialization          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load the Data:
load('ASE_Data/Data_180606_TauSet4_A.mat');


% Choose parameters, their range, and the number of points each way:
pnames = { 'R2p'    ; 'zeta'     };
% interv = [ 2.5, 6.5 ; 0.01, 0.07 ];
% np     = [ 1000     ; 1000       ];
interv = [ 3.5, 5.5 ; 0.01, 0.07 ];
np     = [  500     ; 1000       ];


% Specifically for testing critical tau. 
params.tc_man = 0;
params.tc_val = 0.024;

% extract relevant parameters
sigma = mean(params.sig);   % real std of noise
ns = length(S_sample); % number of data points
params.R2p = params.dw.*params.zeta;

% params.lam0 = 0.15;

if ~exist('TE_sample','var')
    TE_sample = params.TE;
end


% are we inferring on R2'?
if any(strcmp(pnames,'R2p'))
    noDW = 1; % this changes what happens in MTC_qASE_model.m
else
    noDW = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%    1D Line Search          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inference
if length(pnames) == 1
    disp('1D Grid Search currently unsupported');

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%    2D Grid Search          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif length(pnames) == 2
    % Bayesian Inference on two parameters, using grid search
    
    % pull out parameter names
    pn1 = pnames{1};
    pn2 = pnames{2};
    
    np1 = np(1);
    np2 = np(2);
        
    % find true values of parameters
    trv(1) = eval(['params.',pn1]); % true value of parameter 1
    trv(2) = eval(['params.',pn2]); % true value of parameter 2

    % generate parameter distributions
    pv1 = linspace(interv(1,1),interv(1,2),np1);
    pv2 = linspace(interv(2,1),interv(2,2),np2);

    pos = zeros(np(1),np(2));

    parfor i1 = 1:np1
        % loop through parameter 1
        
        % create a parameters object
        looppars = param_update(pv1(i1),params,pn1);
        posvec = zeros(1,np2);
        
        pv22 = pv2; % to avoid using pv2 as a broadcast variable
        
        for i2 = 1:np2
            % loop through parameter 2
            
            % create a parameters object
            inpars = param_update(pv22(i2),looppars,pn2);

            % run the model to evaluate the signal with current params            
            S_mod = MTC_qASE_model2(T_sample,TE_sample,inpars,noDW);
            
            % normalize
            S_mod = S_mod./max(S_mod);

            % calculate posterior based on known noise value
            posvec(i2) = MTC_loglike(S_sample,S_mod,sigma);
                                
        end % for i2 = 1:np2
        
        pos(i1,:) = posvec;
        
    end % parfor i1 = 1:np1
    
end % length(pars) == 1 ... elseif 

toc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%    Display Results         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Display

% create docked figure
figure('WindowStyle','Docked');
hold on; box on;

% Plot 2D grid search results
surf(pv2,pv1,exp(pos));
view(2); shading flat;
c=colorbar;
% infernoW = flipud(magma);
% colormap(infernoW);
plot3([trv(2),trv(2)],[  0, 1000],[1e20,1e20],'k-');
plot3([  0, 1000],[trv(1),trv(1)],[1e20,1e20],'k-');

% outline
plot3([pv1(  1),pv2(  1)],[pv1(  1),pv1(end)],[1,1],'k-','LineWidth',0.75);
plot3([pv2(end),pv2(end)],[pv1(  1),pv1(end)],[1,1],'k-','LineWidth',0.75);
plot3([pv2(  1),pv2(end)],[pv1(  1),pv1(  1)],[1,1],'k-','LineWidth',0.75);
plot3([pv2(  1),pv2(end)],[pv1(end),pv1(end)],[1,1],'k-','LineWidth',0.75);

xlabel(pn2);
ylabel(pn1);

ylabel(c,'Posterior Probability Density');

axis([min(pv2),max(pv2),min(pv1),max(pv1)]);
set(gca,'YDir','normal');
set(c,'FontSize',14);
    
% Calculate distribution's maximum position in 2D
%     [V2G,V1G] = meshgrid(pv2,pv1);
%     [~,mi] = max(pos(:));
%     disp('  ');
%     disp([  'OEF = ',num2str(truepars.OEF),...
%           ', DBV = ',num2str(100*truepars.zeta),...
%           ', Tc = ',num2str(1000*params.tc_val),'ms']);
%     disp(['  Maximum ',pname{1},': ',num2str(100*V1G(mi),4)]);
%     disp(['  Maximum ',pname{2},': ',num2str(100*V2G(mi),4)]);
    
