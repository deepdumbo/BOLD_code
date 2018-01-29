% MTC_qASE.m
%
% Quantitative Asymmetric Spin Echo Sequence Simulation. Generates data to
% be used in Bayesian inference on parameters (MTC_Asymmetric_Bayes.m and
% others). Based on MTC_qBOLD.m 
%
% 
%       Copyright (C) University of Oxford, 2016-2017
%
% 
% Created by MT Cherukara, 17 May 2016
%
% CHANGELOG:
%
% 2017-01-12 (MTC). Change the way the noise standard deviation params.sig
%       is calculated and applied, so that it actually results in the SNR
%       that we want. Also some cleanup.
%
% 2017-08-07 (MTC). Added a call to MTC_qASE_model, rather than repeating
%       its contents here, so that the whole thing is more modular. Removed
%       the automatic saving of the plot, as it's kind of unnecessary
%
% 2017-04-04 (MTC). Modified the plotting parameters, removed a bunch of
%       unnecessary variables from the params struct.
%
% 2016-11-08 (MTC). Changed tau range to go up to 64 ms, changed some
%       other constants, added saving out of data sampled at key points,
%       with noise added in too.
%
% 2016-05-27 (MTC). Changed the way the compartments are added together,
%       which was apparently causing problems (I don't know why).

clear; 
% close all;

plot_fig = 1;       
save_data = 0;      % set to 1 in order to save out ASE data

%% Model Parameters

% constants 
params.B0   = 3.0;          % T         - static magnetic field
params.dChi = 2.64e-7;      % parts     - susceptibility difference
params.gam  = 2.67513e8;    % rad/s/T   - gyromagnetic ratio

% scan parameters 
params.TE   = 0.074;        % s         - echo time

% model fitting parameters
params.S0   = 100;          % a. units  - signal
params.R2t  = 1/0.087;      % 1/s       - rate constant, tissue
params.R2e  = 4;            % 1/s       - rate constant, extracellular
params.dF   = 5;            % Hz        - frequency shift
params.lam0 = 0.000;        % no units  - ISF/CSF signal contribution
params.zeta = 0.030;        % no units  - deoxygenated blood volume
params.OEF  = 0.400;        % no units  - oxygen extraction fraction
params.Hct  = 0.400;        % no units  - fractional hematocrit

% noise
params.SNR = 200;

%% Compute Model

% define tau values that we want to simulate
% tau = (-28:4:64)/1000; % for testing
tau = linspace(-0.032,0.072,1000); % for visualising

np = length(tau);

% call MTC_qASE_model
[S_total,params] = MTC_qASE_modelB(tau,params.TE,params);


%% Add Noise
S_sample = S_total + (S_total.*randn(1,np)./params.SNR);
S_sample(S_sample < 0) = 0;


% calculate maximum data standard deviaton
params.sig = min(S_total)/params.SNR;

%% plot figure
if plot_fig
    
    % create a figure
    figure(2);
    set(gcf,'WindowStyle','docked');
    hold on; box on;

    % plot some lines
%     plot([0 0],[-1 2],'k--','LineWidth',2);
    
    % plot the signal
    S_log = log(S_total);
    l.s = plot(1000*tau,S_log,'-','LineWidth',3);
%     plot(1000*tau,log(S_sample),'kx','LineWidth',2);
    xlim([-20,80]);
    
    % for comparing inferred values
%     tauF = [0, 16:4:64];
%     plot(tauF,log(fdata),'kx','LineWidth',3);
    
    % labels on axes
    xlabel('Spin Echo Displacement \tau (ms)');
    ylabel('Log (Signal)');
    title('qBOLD Signal Measured Using ASE');
    set(gca,'FontSize',14);
    
end % if plot_fig

% Save Data
if save_data
    % Check how many datasets have been saved with the same date
    dat_dir = '/Users/mattcher/Documents/DPhil/Code/Matlab_Bayesian_MCMC/';
    dat_title1 = strcat('ASE_signal_',date,'_');
    dat_list = dir(strcat(dat_dir,dat_title1,'*'));
    fn = length(dat_list) + 1;
    
    % Assign the correct title
    dat_title = strcat(dat_title1,num2str(fn));
    
    % pull out values of TE and tau
    T_sample = tau;
    
    if length(params.TE) ~= length(tau)
        TE_sample(1:length(tau)) = params.TE;
    else
        TE_sample = params.TE;
    end
    
    % Save the data out
    save(dat_title,'T_sample','S_sample','TE_sample','params');
end % if save_data
    