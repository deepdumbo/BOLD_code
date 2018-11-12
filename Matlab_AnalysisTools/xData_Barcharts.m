% Various sets of qBOLD data, for bar-chart plotting:
%
% Updated 2018-11-06

%% Phenomonelogical Model Testing

legtext = {'L Model','2C Model','Ph Fixed','Ph Var.','L Model','2C Model','Ph Fixed','Ph Var.'};

%       LinMean    2C.Mean   Ph.Mean    PhC.Mean    LinMed     2C.Med    Ph.Mean   PhC.Med
R2p = [ 3.2350,    3.3340,         0,         0,    2.8510,    2.8930,         0,         0; ...
        3.7380,    3.6110,         0,         0,    2.9970,    2.7350,         0,         0; ...
        2.9520,    3.1230,         0,         0,    2.1480,    2.8130,         0,         0; ...
        3.1890,    3.5680,         0,         0,    2.4620,    2.7680,         0,         0; ...
        3.2330,    3.5750,         0,         0,    2.6000,    2.8890,         0,         0; ...
        3.5560,    3.7760,         0,         0,    2.9340,    3.0130,         0,         0; ...
        2.7260,    2.6630,         0,         0,    2.2370,    2.0660,         0,         0 ];
    
%       LinMean    2C.Mean   Ph.Mean    PhC.Mean    LinMed     2C.Med    Ph.Mean     PhC.Med
DBV = [ 4.3600,    5.6200,   14.9800,   7.374,      3.6540,    3.3390,   10.9900,    3.625; ...
        6.0780,    6.4160,   15.6100,   8.535,      4.6740,    2.6370,   11.2400,    3.738; ...
        4.1740,    5.7120,   12.8400,   8.231,      3.1000,    4.0480,    8.8020,    3.545; ...
        4.8100,    6.8010,   15.1300,   8.182,      3.7150,    4.3510,   11.7400,    3.780; ...
        5.1110,    8.1670,   16.8900,   8.875,      4.0040,    5.9680,   11.2900,    4.301; ...
        5.1760,    6.1670,   13.0300,   8.315,      3.8800,    2.9430,    9.8780,    3.862; ...
        4.9540,    5.4470,   12.2700,   6.859,      3.6140,    3.2680,    7.6750,    2.977 ];

%       LinMean    2C.Mean    Ph.Mean    PhC.Mean   LinMed     2C.Med     Ph.Mean    PhC.Med
OEF = [ 29.7700,   33.4500,   39.5200,   42.68,     25.2500,   22.1100,   36.3500,   43.24; ...
        24.9300,   34.1900,   41.5800,   42.88,     20.7700,   19.7600,   39.2000,   44.37; ...
        27.0500,   32.0500,   38.7900,   40.12,     21.8100,   18.2800,   35.2800,   40.21; ...
        25.6900,   28.1700,   38.5400,   42.94,     22.1400,   16.6600,   36.8200,   43.47; ...
        25.7500,   23.0300,   40.4300,   43.70,     21.2800,   15.2500,   38.9800,   40.48; ...
        27.9900,   33.2100,   37.5700,   43.91,     23.8000,   20.7300,   33.1300,   44.29; ...
        25.1100,   23.5500,   37.0600,   38.59,     19.8500,   18.4500,   35.2800,   32.57 ];


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % %    ERRORS           % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%        LinMean    2C.Mean   Ph.Mean    PhC.Mean    LinMed     2C.Med     Ph.Med     PhC.Med
eR2p = [ 1.9330,    0.7780,         0,         0,    2.8510,    2.8930,         0,         0; ...
         2.8790,    0.8880,         0,         0,    2.9970,    2.7350,         0,         0; ...
         2.7210,    0.7100,         0,         0,    2.1480,    2.8130,         0,         0; ...
         2.7120,    0.7510,         0,         0,    2.4620,    2.7680,         0,         0; ...
         2.6010,    0.8320,         0,         0,    2.6000,    2.8890,         0,         0; ...
         2.6510,    0.7130,         0,         0,    2.9340,    3.0130,         0,         0; ...
         2.2300,    0.7000,         0,         0,    2.2370,    2.0660,         0,         0 ];
     
%        LinMean    2C.Mean   Ph.Mean    PhC.Mean    LinMed     2C.Med    Ph.Med     PhC.Med
eDBV = [ 3.8120,    4.8510,   14.3000,   11.75,      4.5960,    6.4960,   21.3100,    3.406; ...
         5.9700,    5.5210,   15.2500,   14.38,      5.9320,    8.6480,   23.7200,    4.665; ...
         4.3850,    4.9660,   13.0300,   14.35,      4.2330,    7.7400,   16.0700,    3.607; ...
         4.7840,    5.2890,   13.7200,   13.80,      4.6440,    9.1310,   21.7900,    4.009; ...
         4.9360,    4.4660,   17.2400,   14.65,      5.3510,    9.7920,   23.7700,    5.662; ...
         5.8540,    4.5420,   12.3800,   13.81,      5.4560,    7.8000,   18.8500,    4.048; ...
         6.4340,    4.6090,   13.2100,   12.97,      4.6560,    5.3630,   17.7100,    3.733 ];

%        LinMean    2C.Mean    Ph.Mean    PhC.Mean   LinMed     2C.Med     Ph.Med    PhC.Med
eOEF = [ 18.4500,   22.6500,   23.6100,   15.69,     29.3300,   38.0800,   43.7900,  32.51; ...
         16.2400,   26.1900,   24.1200,   16.82,     21.2700,   49.8100,   45.1300,  33.44; ... 
         19.5100,   22.3300,   24.9800,   16.31,     27.8700,   39.5700,   44.3000,  33.79; ...
         16.7400,   22.3000,   23.8700,   15.79,     23.8000,   31.3600,   43.0700,  35.14; ...
         17.3800,   14.5300,   24.7100,   18.48,     23.0300,   18.4500,   45.5900,  39.01; ...
         17.6400,   22.8500,   23.2900,   16.56,     25.4200,   41.0700,   40.0600,  35.91; ...
         17.9900,   18.8400,   23.3200,   16.26,     25.0300,   21.1400,   40.3900,  31.75 ];
     
%% Old Dataset (May 2018)

legtext = {'Linear','1C Model','2C Model','2C Model','2C Model (I)','2C Model (I)'};

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % %    MEAN DATA        % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%       Simple    14.1C-N   14.2C-N   24.2C-N   24.2C-I   14.2C-I
R2p = [ 3.559,    3.401,    3.707,    3.747,    3.661,    3.595; ...
        4.362,    3.833,    4.303,    4.360,    4.225,    4.021; ...
        3.729,    3.242,    3.455,    3.419,    3.430,    3.390; ...
        3.866,    3.803,    4.201,    3.972,    3.919,    3.998; ...
        3.490,    3.364,    3.879,    3.747,    3.696,    3.597; ...
        3.857,    3.731,    4.102,    4.019,    3.968,    3.940; ...
        3.313,    2.827,    2.960,    3.105,    3.077,    2.881 ];
    
%       Simple    14.1C-N  14.2C-N   24.2C-N    24.2C-I  14.2C-I
DBV = [ 5.307,    5.671,    6.607,    6.966,    5.603,    5.237; ...
        7.653,    7.502,    9.875,   10.040,    7.000,    6.393; ...
        5.853,    5.927,    6.901,    6.944,    5.277,    5.082; ...
        6.719,    8.370,   10.140,    9.385,    6.655,    7.046; ...
        6.103,    7.847,    9.741,    9.324,    6.979,    6.835; ...
        6.529,    7.125,    8.724,    8.643,    6.112,    5.953; ...
        6.094,    6.023,    6.625,    7.426,    4.951,    4.485 ];

%       Simple   14.1C-N  14.2C-N   24.2C-N  24.2C-I  14.2C-I
OEF = [ 25.19,   31.01,   24.77,    24.52,   25.30,   26.23; ...
        20.16,   27.47,   20.05,    20.96,   22.48,   22.18; ...
        22.42,   25.56,   21.86,    23.78,   24.10,   23.38; ...
        20.83,   22.67,   18.14,    19.96,   21.50,   20.22; ...
        20.78,   24.73,   17.97,    19.60,   20.93,   20.08; ...
        23.73,   27.32,   21.98,    23.36,   24.86,   23.80; ...
        20.72,   25.88,   22.19,    22.31,   22.73,   23.05 ];


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % %    STANDARD DEVIATIONS         % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%        Simple  14.1C-N   14.2C-N   24.2C-N   24.2C-I   14.2C-I
eR2p = [ 0.40,   0.650,    0.898,    0.687,    0.581,    0.722; ...
         0.65,   0.882,    1.342,    1.024,    0.773,    0.949; ...
         0.42,   0.698,    0.925,    0.685,    0.576,    0.736; ...
         0.56,   0.793,    1.203,    0.890,    0.665,    0.858; ...
         0.45,   0.693,    1.046,    0.752,    0.622,    0.778; ...
         0.41,   0.774,    1.065,    0.775,    0.625,    0.816; ...
         0.50,   0.688,    0.860,    0.717,    0.584,    0.719 ];
     
%        Simple   14.1C-N   14.2C-N   24.2C-N   24.2C-I   14.2C-I
eDBV = [ 2.57,    4.389,    4.317,    3.383,    2.336,    2.860; ...
         4.13,    5.050,    6.697,    4.763,    2.988,    3.657; ...
         2.84,    4.288,    4.911,    3.850,    2.288,    2.858; ...
         3.66,    4.568,    5.311,    4.301,    2.595,    3.328; ...
         2.89,    4.133,    5.106,    4.155,    2.444,    3.071; ...
         2.61,    4.495,    5.527,    4.165,    2.451,    3.161; ...
         3.36,    5.089,    5.014,    4.085,    2.340,    2.883 ];

%        Simple   14.1C-N  14.2C-N   24.2C-N  24.2C-I  14.2C-I
eOEF = [ 17.19,   21.39,   16.57,    13.49,   13.36,   16.33; ...
         14.42,   20.42,   14.40,    12.68,   13.48,   15.81; ...
         15.14,   19.86,   16.29,    14.99,   14.40,   16.36; ...
         14.58,   15.62,   11.07,    11.08,   11.64,   12.20; ...
         13.37,   18.18,   11.39,    10.28,   10.82,   12.23; ...
         14.11,   19.11,   14.84,    12.97,   13.68,   15.85; ...
         15.20,   22.24,   17.93,    14.50,   14.58,   17.50 ];
     
     
%% Model-Fit Paper Data (Sep 2018)
% Includes "Quadratic" long-tau model

legtext = {'L Model','1C Model','2C Model','L Model','1C Model','2C Model','QL Model','QL Model','L Model','L Model'};

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % %    DATA             % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    
%       LinMean    1C.Mean    2C.Mean    LinMed.    1C.Med.    2C.Med.    QL.Mean   QL.Med.   LS.Mean   LS.Med.
R2p = [ 3.6990,    3.3100,    3.3340,    3.2070,    2.8650,    2.8930,    2.882,    2.305,    3.235,    2.851; ...
        4.4520,    3.5820,    3.6110,    3.5710,    2.8600,    2.7350,    3.180,    2.206,    3.738,    2.997; ...
        3.2880,    3.0880,    3.1230,    2.4420,    2.2510,    2.8130,    2.739,    1.773,    2.952,    2.148; ...
        3.9420,    3.6300,    3.5680,    3.1000,    2.9600,    2.7680,    3.035,    2.150,    3.189,    2.462; ...
        3.8940,    3.5750,    3.6660,    3.1050,    3.0110,    2.8890,    3.095,    2.360,    3.233,    2.600; ...
        3.9810,    3.7490,    3.7760,    3.2680,    3.1020,    3.0130,    3.220,    2.426,    3.556,    2.934; ...
        3.2530,    2.6680,    2.6630,    2.5230,    2.0580,    2.0660,    3.366,    2.629,    2.726,    2.237 ];
   
%       LinMean    1C.Mean    2C.Mean    LinMed.    1C.Med.    2C.Med.    QL.Mean   QL.Med.   LS.Mean   LS.Med.
DBV = [ 7.4340,    6.0100,    5.6200,    4.6970,    2.9830,    3.3390,    4.920,    2.551,    4.360,    3.654; ...
       10.8600,    6.1940,    6.4160,    7.2200,    3.4900,    2.6370,    5.934,    2.548,    6.078,    4.674; ...
        6.1640,    5.4580,    5.7120,    3.9680,    2.6050,    4.0480,    4.840,    2.391,    4.174,    3.100; ...
        9.1070,    6.8030,    6.8010,    6.2070,    5.3070,    4.3510,    6.155,    3.654,    4.810,    3.715; ...
        8.8460,    8.1670,    7.2450,    6.3160,    6.4340,    5.9680,    7.595,    5.267,    5.111,    4.004; ...
        8.4170,    6.2680,    6.1670,    4.9670,    3.6870,    2.9430,    5.321,    2.498,    5.176,    3.880; ...
        7.0820,    5.6470,    5.4470,    4.4080,    3.2350,    3.2680,    6.592,    4.695,    4.954,    3.614 ];

%       LinMean    1C.Mean    2C.Mean    LinMed.    1C.Med.    2C.Med.    QL.Mean   QL.Med.   LS.Mean   LS.Med.
OEF = [ 24.7900,   35.0800,   33.4500,   20.5400,   22.3500,   22.1100,   32.71,    23.30,    29.77,    25.25; ...
        17.8900,   31.2000,   34.1900,   15.2100,   16.8300,   19.7600,   31.02,    19.99,    24.93,    20.77; ...
        21.4900,   29.0000,   32.0500,   17.9200,   20.5900,   18.2800,   24.22,    18.29,    27.05,    21.81; ...
        19.4800,   24.5300,   28.1700,   16.2100,   15.5500,   16.6600,   24.69,    16.23,    25.69,    22.14; ...
        19.3600,   23.0300,   25.6800,   15.6300,   14.6300,   15.2500,   20.45,    14.55,    25.75,    21.28; ...
        24.1400,   31.2400,   33.2100,   19.8500,   19.7800,   20.7300,   31.89,    21.45,    27.99,    23.80; ...
        20.7000,   24.0100,   23.5500,   16.9000,   17.8800,   18.4500,   24.29,    17.77,    25.11,    19.85 ];
    
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % %    ERRORS           % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%        LinStd     1C.Std     2C.Std     LinIQR     1C.IQR     2C.IQR     QL.Std    QL.IQR    LS.Std    LS.IQR 
eR2p = [ 0.6150,    0.8150,    0.7780,    3.1270,    2.9130,    3.0310,    1.157,    2.795,    1.933,    2.835; ...
         0.6940,    0.8240,    0.8880,    4.6670,    3.5790,    3.5260,    1.172,    3.244,    2.879,    3.498; ...
         0.4610,    0.7900,    0.7100,    3.1700,    3.0720,    2.8460,    1.147,    2.908,    2.721,    2.826; ...
         0.5750,    0.6670,    0.7510,    3.6160,    3.5860,    3.6400,    1.158,    3.289,    2.712,    3.035; ...
         0.6100,    0.7350,    0.8320,    3.8240,    3.7460,    3.6400,    1.167,    3.195,    2.601,    2.988; ...
         0.6630,    0.7240,    0.7130,    3.8500,    3.5410,    3.6580,    1.043,    3.223,    2.651,    3.336; ...
         0.5960,    0.7830,    0.7000,    2.7020,    2.6140,    2.5530,    1.172,    3.198,    2.230,    2.474 ];

%        LinStd     1C.Std     2C.Std     LinIQR     1C.IQR     2C.IQR     QL.Std    QL.IQR    LS.Std    LS.IQR 
eDBV = [ 4.0850,    7.0170,    4.8510,    6.2350,    6.3850,    6.4960,    5.634,    5.832,    3.812,    4.596; ...
         6.8450,    5.3830,    5.5210,   11.5800,    8.5440,    8.6480,    5.778,    7.998,    5.970,    5.932; ...
         3.3690,    5.5550,    4.9660,    5.7070,    5.8120,    7.7400,    4.786,    5.015,    4.385,    4.233; ...
         4.5820,    4.9880,    5.2890,    7.6840,    8.7040,    9.1310,    4.976,    7.874,    4.784,    4.644; ...
         6.0460,    4.4660,    5.0540,    9.0180,    9.8290,    9.7920,    5.007,    8.745,    4.936,    5.351; ...
         5.2610,    5.4050,    4.5420,    7.4250,    7.8070,    7.8000,    4.838,    6.365,    5.854,    5.456; ...
         5.6860,    5.7290,    4.6090,    6.0390,    5.5150,    5.3630,    4.726,    7.002,    6.434,    4.656 ];

%        LinStd     1C.Std     2C.Std     LinIQR     1C.IQR     2C.IQR     QL.Std    QL.IQR    LS.Std    LS.IQR 
eOEF = [ 15.2400,   24.4300,   22.6500,   21.3800,   46.8200,   38.0800,   28.35,    38.99,    18.45,    29.33; ...
         10.8400,   23.2900,   26.1900,   14.5900,   43.0800,   49.8100,   29.82,    39.62,    16.24,    21.27; ...
         13.4300,   23.7700,   22.3300,   18.3700,   31.5200,   39.5700,   26.08,    21.50,    19.51,    27.87; ...
         10.4600,   18.1200,   22.3000,   14.9100,   17.2100,   31.3600,   25.06,    24.50,    16.74,    23.80; ...
         11.2300,   12.2500,   18.4500,   13.7100,   13.9600,   14.5300,   17.57,    17.58,    17.38,    23.03; ...
         13.0800,   21.1800,   22.8500,   22.3900,   33.3000,   41.0700,   27.44,    37.18,    17.64,    25.42; ...
         13.7600,   18.9000,   18.8400,   18.4000,   23.0500,   21.1400,   19.87,    17.30,    17.99,    25.03 ];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % %    FREE ENERGY        % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% NEGATIVE
%      LinMean    1C.Mean    2C.Mean    LinMed.    1C.Med.    2C.Med.    QL.Mean   QL.Med.
FE = [  87.4000,  118.3000,  113.9000,   87.4000,  118.3000,  113.9000,  111.6,    111.6; ...
       123.8000,  165.2000,  170.1000,  123.8000,  165.2000,  170.1000,  169.1,    169.1; ...
        72.4000,  101.9000,  127.0000,   72.4000,  101.9000,  127.0000,  104.3,    104.3; ...
       100.8000,  134.9000,  139.7000,  100.8000,  134.9000,  139.7000,  135.8,    135.8; ...
       109.1000,  148.8000,  150.7000,  109.1000,  148.8000,  150.7000,  152.1,    152.1; ...
        82.7000,  137.1000,  135.2000,   82.7000,  137.1000,  135.2000,  134.7,    134.7; ...
       115.9000,  138.6000,  135.6000,  115.9000,  138.6000,  135.6000,  119.5,    119.5 ];
     
%      LinMean    1C.Mean    2C.Mean    LinMed.    1C.Med.    2C.Med.    QL.Mean   QL.Med.
RR = [ -0.0780,   -0.1720,   -0.1130,   -0.0780,   -0.1720,   -0.1130,   -0.097,   -0.097; ...
       -0.2560,   -0.1940,   -0.2050,   -0.2560,   -0.1940,   -0.2050,   -0.213,   -0.213; ...
       -0.1720,   -0.2110,   -0.1060,   -0.1720,   -0.2110,   -0.1060,   -0.261,   -0.261; ...
       -0.0250,   -0.0840,   -0.0790,   -0.0250,   -0.0840,   -0.0790,   -0.145,   -0.145; ...
       -0.0870,   -0.2860,   -0.3060,   -0.0870,   -0.2860,   -0.3060,   -0.305,   -0.305; ...
       -0.1850,   -0.2620,   -0.2410,   -0.1850,   -0.2620,   -0.2410,   -0.227,   -0.227; ...
       -0.1150,   -0.2710,   -0.2290,   -0.1150,   -0.2710,   -0.2290,   -0.295,   -0.295 ];
   
%      LinMean    1C.Mean    2C.Mean    LinMed.    1C.Med.    2C.Med.    QL.Mean   QL.Med.
SN = [ 51.5000,   49.2000,   56.8000,   51.5000,   49.2000,   56.8000,   52.5,     52.5; ...
       33.2000,   38.2000,   39.1000,   33.2000,   38.2000,   39.1000,   39.0,     39.0; ...
       60.8000,   45.2000,   52.9000,   60.8000,   45.2000,   52.9000,   49.1,     49.1; ...
       56.4000,   49.1000,   48.5000,   56.4000,   49.1000,   48.5000,   49.1,     49.1; ...
       57.0000,   47.9000,   46.7000,   57.0000,   47.9000,   46.7000,   46.3,     46.3; ...
       51.7000,   47.0000,   49.4000,   51.7000,   47.0000,   49.4000,   49.4,     49.4; ...
       54.4000,   51.2000,   53.4000,   54.4000,   51.2000,   53.4000,   49.0,     49.0 ];
     
%% .
    