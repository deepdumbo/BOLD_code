% barchartsCSF.m
%
% Actively used as of 2018-05-25

clear;
close all;
setFigureDefaults;

%% Data

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % %    MEAN DATA        % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%        FLAIR-U   FLAIR-I   NF-U      NF-I      NF-T1w    NF-T2w    NF-T2fit
R2p = [  2.874,    3.082,    3.568,    3.545,    3.518,    3.124,    3.443; ...
         3.281,    3.396,    4.337,    4.167,    4.162,    3.395,    4.045; ...
         2.305,    2.441,    3.144,    3.133,    3.108,    2.552,    2.958; ...
         2.139,    2.372,    2.610,    2.751,    2.729,    2.529,    2.542; ...
         2.290,    2.982,    3.369,    3.335,    3.307,    2.530,    3.107 ];
    
%        FLAIR-U   FLAIR-I   NF-U      NF-I      NF-T1w    NF-T2w    NF-T2fit
DBV = [  4.730,    5.720,    8.735,    6.249,    6.222,    5.800,    6.128; ...
         5.796,    6.125,   10.690,    7.067,    7.079,    6.225,    6.961; ...
         4.460,    4.729,    8.124,    5.991,    5.971,    5.306,    5.776; ...
         3.831,    4.758,    5.343,    5.185,    5.175,    4.908,    4.887; ...
         4.073,    5.037,    7.503,    6.283,    6.256,    5.336,    6.041 ];

%        FLAIR-U   FLAIR-I   NF-U      NF-I      NF-T1w    NF-T2w    NF-T2fit
OEF = [  31.60,    22.01,    22.72,    24.13,    24.23,    23.33,    24.25; ...
         32.76,    23.47,    21.70,    26.17,    26.11,    24.92,    25.95; ...
         26.47,    20.62,    20.52,    20.97,    20.87,    19.89,    20.62; ...
         32.81,    20.15,    19.60,    19.96,    19.90,    19.53,    19.55; ...
         32.33,    21.25,    19.18,    20.96,    20.70,    19.52,    20.47 ];


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % %    STANDARD DEVIATIONS         % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%         FLAIR-U   FLAIR-I   NF-U      NF-I      NF-T1w    NF-T2w    NF-T2fit
eR2p = [  0.717,    0.675,    1.316,    0.717,    0.712,    0.814,    0.730; ...
          0.727,    0.677,    1.554,    0.927,    0.917,    1.173,    0.939; ...
          0.734,    0.702,    1.365,    0.674,    0.670,    0.849,    0.712; ...
          0.668,    0.648,    1.037,    0.499,    0.488,    0.552,    0.567; ...
          0.666,    0.811,    1.181,    0.681,    0.685,    0.948,    0.747 ];
      
%         FLAIR-U   FLAIR-I   NF-U      NF-I      NF-T1w    NF-T2w    NF-T2fit
eDBV = [  4.730,    3.205,    5.795,    3.192,    3.169,    3.153,    3.159; ...
          4.963,    3.048,    7.152,    4.010,    3.991,    3.976,    3.958; ...
          4.885,    3.189,    4.985,    3.033,    3.025,    3.028,    3.012; ...
          4.944,    3.103,    3.551,    2.315,    2.282,    2.290,    2.340; ...
          4.743,    3.722,    4.625,    3.121,    3.131,    3.155,    3.121 ];

%         FLAIR-U   FLAIR-I   NF-U      NF-I      NF-T1w    NF-T2w   NF-T2fit
eOEF = [  27.17,    16.08,    17.19,    16.02,    15.96,    17.00,   16.19; ...
          24.49,    15.65,    16.64,    18.96,    18.71,    21.18,   18.83; ...
          25.37,    18.12,    16.86,    14.71,    14.74,    16.42,   15.21; ...
          28.85,    16.73,    15.58,    12.64,    12.34,    12.79,   13.41; ...
          26.89,    19.08,    15.24,    13.79,    13.89,    17.12,   14.33 ];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % %    RESIDUALS       % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%       FLAIR-U  FLAIR-I  NF-U     NF-I     NF-T1w   NF-T2w   NF-T2fit
FE =  [ 4.38,    3.36,     9.53,    7.84,    7.78,    7.87,    7.78; ...
        3.82,    3.13,    12.40,   11.11,   11.13,   11.30,   11.08; ...
        4.32,    3.46,    10.81,    8.15,    8.18,    8.76,    8.20; ...
        3.23,    2.73,     6.14,    5.24,    5.18,    5.44,    5.43; ...
        3.11,    3.48,     7.00,    6.26,    6.33,    6.75,    6.43 ];



%% Calculations  

rebase = 0;

% rebase
if rebase
    eR2p = eR2p./repmat(R2p(:,1),1,8);
    eDBV = eDBV./repmat(DBV(:,1),1,8);
    R2p = R2p./repmat(R2p(:,1),1,8);
    DBV = DBV./repmat(DBV(:,1),1,8);
    OEF = OEF./repmat(OEF(:,1),1,8);
end
     
% averages   
aR2p = mean(R2p);
sR2p = std(R2p);
aDBV = mean(DBV);
sDBV = std(DBV);
aOEF = mean(OEF);
sOEF = std(OEF);
aFE  = mean(FE);
sFE  = std(FE);

% % Calculate OEF error by adding R2' and DBV errors in quadrature
% eOEF = OEF.*sqrt(((eR2p./R2p).^2) + ((eDBV./DBV).^2));


%% Plotting Information
ndat = size(R2p,1); % number of datapoints
dpts = [1,3,5,6,7];
legtext = {'FLAIR','FLAIR(I)','nonFLAIR','NF(I)','T1 corr.','T2 corr.','Biexp. corr.'};
npts = repmat((1:length(dpts))',1,ndat);
lbls = legtext(dpts);


%% Bar Chart Plotting

T1col = [0.000, 0.608, 0.698];
T2col = [0.412, 0.569, 0.231];
BEcol = [0.514, 0.118, 0.157];

% Plot R2p
figure; hold on; box on;
bar(1,aR2p(1),0.6,'FaceColor',defColour(1));    % FLAIR
bar(2,aR2p(3),0.6,'FaceColor',defColour(2));    % non-FLAIR
bar(3,aR2p(5),0.6,'FaceColor',T1col);           % T1 weighted
bar(4,aR2p(6),0.6,'FaceColor',T2col);           % T2 weighted
bar(5,aR2p(7),0.6,'FaceColor',BEcol);           % BE weighted
errorbar(1:5,aR2p(dpts),sR2p(dpts),'k.','LineWidth',2,'MarkerSize',1);
axis([0.5,length(dpts)+0.5,0,5.5]);
ylabel('R_2'' (s^-^1)');
xticks(1:length(dpts));
xticklabels(lbls);


% Plot DBV
figure; hold on; box on;
bar(1,aDBV(1),0.6,'FaceColor',defColour(1));    % FLAIR
bar(2,aDBV(3),0.6,'FaceColor',defColour(2));    % non-FLAIR
bar(3,aDBV(5),0.6,'FaceColor',T1col);           % T1 weighted
bar(4,aDBV(6),0.6,'FaceColor',T2col);           % T2 weighted
bar(5,aDBV(7),0.6,'FaceColor',BEcol);           % BE weighted
errorbar(1:5,aDBV(dpts),sDBV(dpts),'k.','LineWidth',2,'MarkerSize',1);
axis([0.5,length(dpts)+0.5,0,12.5]);
ylabel('DBV (%)');
xticks(1:length(dpts));
xticklabels(lbls);

% Plot OEF
figure; hold on; box on;
bar(1,aOEF(1),0.6,'FaceColor',defColour(1));    % FLAIR
bar(2,aOEF(3),0.6,'FaceColor',defColour(2));    % non-FLAIR
bar(3,aOEF(5),0.6,'FaceColor',T1col);           % T1 weighted
bar(4,aOEF(6),0.6,'FaceColor',T2col);           % T2 weighted
bar(5,aOEF(7),0.6,'FaceColor',BEcol);           % BE weighted
errorbar(1:5,aOEF(dpts),sOEF(dpts),'k.','LineWidth',2,'MarkerSize',1);
axis([0.5,length(dpts)+0.5,0,42]);
ylabel('OEF (%)');
xticks(1:length(dpts));
xticklabels(lbls);



% %% Line Graph Plotting
% jttr = repmat(-0.04:0.02:0.04,length(dpts),1);
% 
% % Plot R2p
% figure; hold on; box on;
% if rebase
%     ylim([0.4,1.6]);
%     ylabel('\DeltaR_2'' (s^-^1)');
%     plot([0,10],[1,1],'k--','LineWidth',1);
% else
%     ylim([0.8,6.2]);
%     ylabel('R_2'' (s^-^1)');
% end
% errorbar(npts+jttr,R2p(:,dpts)',eR2p(:,dpts)','.');
% plot(npts,R2p(:,dpts)');
% errorbar(npts(:,1),aR2p(dpts),sR2p(dpts),'k:','LineWidth',3);
% xlim([npts(1)-0.25,npts(end)+0.25]);
% ylabel('R_2'' (s^-^1)');
% xticks(1:length(dpts));
% xticklabels(lbls);
% 
% % Plot DBV
% figure; hold on; box on;
% if rebase
%     ylim([0.2,1.8]);
%     ylabel('\DeltaDBV');
%     plot([0,10],[1,1],'k--','LineWidth',1);
% else
%     ylim([0,14.5]);
%     ylabel('DBV (%)');
% end
% errorbar(npts+jttr,DBV(:,dpts)',eDBV(:,dpts)','.');
% plot(npts,DBV(:,dpts)');
% errorbar(npts(:,1),aDBV(dpts),sDBV(dpts),'k:','LineWidth',3);
% xlim([npts(1)-0.25,npts(end)+0.25]);
% xticks(1:length(dpts));
% xticklabels(lbls);
% 
% % Plot OEF
% figure; hold on; box on;
% if rebase
%     ylim([0,2]);
%     ylabel('\DeltaOEF');
%     plot([0,10],[1,1],'k--','LineWidth',1);
% else
%     ylim([0,52]);
%     ylabel('OEF (%)');
% end
% errorbar(npts+jttr,OEF(:,dpts)',eOEF(:,dpts)','.');
% plot(npts,OEF(:,dpts)');
% errorbar(npts(:,1),aOEF(dpts),sOEF(dpts),'k:','LineWidth',3);
% xlim([npts(1)-0.25,npts(end)+0.25]);
% 
% xticks(1:length(dpts));
% xticklabels(lbls);
% 
% % % % Plot Free Energy
% % figure; hold on; box on;
% % plot(npts,FE(:,dpts)');
% % errorbar(npts(:,1),aFE(dpts),sFE(dpts),'k:','LineWidth',3);
% % xlim([npts(1)-0.25,npts(end)+0.25]);
% % % ylim([-6.2,-4.2]);
% % ylabel(Residuals');
% % xticks(1:length(dpts));
% % xticklabels(lbls);
% 
% % % Plot R2p
% % FabberBar(R2p(:,datapoints),'R2''',legtext(datapoints));
% % 
% % % Plot DBV
% % FabberBar(DBV(:,datapoints),'DBV',legtext(datapoints));
% % 
% % % Plot OEF
% % if exist('OEF','var')
% %     FabberBar(OEF(:,datapoints),'OEF',legtext(datapoints));
% % end
% % 
