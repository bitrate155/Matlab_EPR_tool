%% settings
clc, clear

plotOptions.toPlot = {'ST'}; %only data containing toPlot in title will be plotted
%flags - true or false
plotOptions.colorScheme = 'T'; %D T G
plotOptions.colors = {'green', 'black', 'red'};
plotOptions.colorDividers = {'Empty', 'dark', 'light'};
plotOptions.spatialDividers = {'Tup', 'Tdown', 'p_2'};
plotOptions.spatialScheme = ''; %'T' 'D' 'Y'
plotOptions.spatialAmpCorr = 300;

filelist = dir('*.DTA'); %FILE NAMEs to load using Regular Expression
spec = loadSpecParameters(filelist, {'Empty', 'dark', 'light', 'ser1', 't_11'});

%% spectra  correction
spec = normalizeSpectra(spec, 3460, 3500);
spec = shiftSpectra(spec, 3460, 3500);
% spec = zeroSpectra(spec, [1634, 2054]);
spec = createSummarySpectra(spec);
% spec = normalizeToMD5Integral(spec, 3440, 3520);
spec = baselineCorrection(spec, [100 4913]);

% spec = smoothSpectra(spec);

% spec = subtractSpectra(spec, 'X_EmptyResonator_5K_s');


%% result integral G
G = [];
% G = addToG(G, spec, 'secInt', [2700 3800], 'integral(2700-3200)_MainLine', 'divider', {'Tup', 'Tdown'}, 'normalize', 'max');
G = addToG(G, spec, 'secInt', [3600 4400], 'integral Tail',...
    'divider', {'ser1'}, 'toSort', {false}, 'normalize', 'max');

G = addToG(G, spec, 'maxmin', [100 3460], 'maxmin',...
    'divider', {'ser1'}, 'toSort', {false}, 'normalize', 'max');

G = addToG(G, spec, 'secIntBcDraw', [2000 4400], 'integral all',...
    'divider', {'ser1'}, 'toSort', {false}, 'normalize', 'max');

% G = addToG(G, spec, 'secInt', [1732 1817], 'integral_MD5', 'divider', {'Tup', 'Tdown'}, 'normalize', 'max');
% G = addToG(G, spec, 'maxmin', [1732 1817], 'integral_MD5_maxmin', 'divider', {'Tup', 'Tdown'}, 'normalize', 'max');

% G = addToG(G, spec, 'maxmin', [1253 1639], 'amp_halfField', 'divider', {'Tup'}, 'normalize', 12.5);%0.0404
% G = addToG(G, spec, 'secInt', [1253 1639], 'amp_halfFieldsecint', 'divider', {'Tup', 'Tdown'}, 'normalize', 'max');

% G = addToG(G, spec, 'maxmin', [3078 3578], 'amp_MainLine', 'divider', {'Tup', 'Tdown'}, 'normalize', 'max');

whatOut = what;
folderName = whatOut.path(max(regexp(whatOut.path, '\'))+1:end);
save(['G_' folderName '.mat'], 'G');
clear whatOut folderName

%% simulation

Sys.S = 1;
Sys.g = [2.04 2.04 2.15];
Sys.D = [2000 600];
Sys.lwpp = 10;     

Exp.mwFreq = spec(1).freq/1e9;
Exp.Range = [spec(1).fmin/10 spec(1).fmax/10];
% [x_sim, y_sim] = pepper(Sys, Exp);
% x_sim = x_sim*10;
% y_sim = y_sim / max(y_sim);

plotSpectra(spec, plotOptions);
plotG(G);


