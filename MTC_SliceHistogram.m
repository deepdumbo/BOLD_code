% MTC_SliceHistogram.m
%
% Plots 'Histograms' of MRI voxel intensities for slices. Based on 
% MTC_CompareMethods.m
%
%
%       Copyright (C) University of Oxford, 2017
%
%
% Created by MT Cherukara, 15 August 2017
%
% CHANGELOG:
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     (main) MTC_SliceHistogram       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MTC_SliceHistogram(varargin)

    % Constants
    nb = 50; % number of bins we want to use

    % Load First Slice Data
    [slice1,sn1,filename] = LoadSlice;
    
    % Ask the user about a second slice for comparison
    choice = questdlg('Would you like to select a second slice for comparison?',...
                      'Comparison Slice',...
                      'From Same File','From Different File','No','No');
                  
    % Handle the user's response
    switch choice
        case 'From Same File'
            [slice2,sn2,~] = LoadSlice(filename);
        case 'From Different File'
            [slice2,sn2,~] = LoadSlice;
        case 'No'
            slice2 = [];
    end
    
    % Now calculate the histogram data
    [hdata,hcentres] = CalculateHist(slice1,slice2,nb);
    
    % Plot the histograms
    PlotHist(hdata,hcentres);
    
return; % MTC_SliceHistogram

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     LoadSlice                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [slicedata,slicenum,filename] = LoadSlice(filename)
    % Loads the data from a specific slice (or slices) into a matrix and
    % returns it, along with some other information
    
    % Check whether a name has been specified, if not, have the user pick
    if ~exist('filename','var')
        [niname, nidir] = uigetfile('*.nii.gz','Select NIFTY Data File to Load...');
        filename = [nidir,niname]; 
    end
    
    % Load the selected NIFTY into dataset
    [dataset,dims,~,~,~] = read_avw(filename);
    
    % Record the number of slices
    nsl = dims(3);
    
    % Have the user select a slice (or set of slices) to plot
    slc = inputdlg(['Enter a number between 1 and ',num2str(nsl)],'Choose a Slice',1);
    
    slicenum  = slc{1};
    slicedata = squeeze(dataset(:,:,str2num(slicenum)));
    
return; % LoadSlice 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     CalculateHist                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [histdata,HC] = CalculateHist(data1,data2,nbins)
    % calculates histogram data for one or two specified datasets

    % check whether a second dataset has been given
    if exist('data2','var')
        twosets = 1;
    else
        twosets = 0;
    end

    % Convert data into a 1D vector and remove zeros/negative values
    v1 = data1(:);
    v1(v1 <= 0) = []; 
%     v1(v1 == 0) = [];
    
    % set an upper boundary
    max1 = quantile(v1,0.995);
    
    % deal with second dataset
    if twosets
        v2 = data2(:);
        v2(v2 <= 0) = [];
        max2 = quantile(v2,0.995);
        max1 = max(max1,max2);
    end
    
    % Define histogram points
    HE = linspace(0,max1,nbins+1);      % edges
    HC = (HE(1:end-1) + HE(2:end))./2;  % centres
    
    % create array to store histogram data results
    histdata = zeros(twosets+1,nbins);
    
    % Calculate Histogram(s)
    [histdata(1,:),~] = histcounts(v1,HE);
    if twosets
        [histdata(2,:),~] = histcounts(v2,HE);
    end

return; % CalculateHist


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     PlotHist                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PlotHist(HD,HC)

    % Figure out whether we are dealing with one or two datasets
    if size(HD,1) == 2
        twosets = 1;
    else
        twosets = 0;
    end
    
    % Choose limits for axes
    maxY = 1.1.*max(HD(:));
    maxX = 0.8.*HC(end);
    
    % Plot histograms
    figure('WindowStyle','Docked');
    hold on; box on;
    plot(HC,HD(1,:),'b','LineWidth',3);
    if twosets
        plot(HC,HD(2,:),'r','LineWidth',3);
    end
    axis([0, maxX, 0, maxY]);
    set(gca,'FontSize',16);
    legend('Slice 1','Slice 2','Location','NorthEast');

return; % PlotHist
