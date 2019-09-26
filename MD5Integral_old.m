function [ data, I_md5 ] = normalizeToMD5Integral( spec, fieldLeft, fieldRight )
%NORMALIZESPEC Normalize spectra, so MD5 second integral = 1, simulates md5
%line with -A*(x-x0)*exp((-((x-x0)/B)^2)/2). fieldLeft and fieldRight are
%the limits where the line is simulated. Uses fieldId
%   Tumanov S

  
fitLimits = fieldId(spec, [fieldLeft fieldRight]);

xf = spec.field(fitLimits(1):fitLimits(2));
yf = spec.data(fitLimits(1):fitLimits(2));
% yf = yf/max(yf);

%     fitType = fittype('A*(xf-x0)*exp((-(xf-x0)*(xf-x0))/B)',...
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [1 15 0];

fitType = fittype( '-A*(x-x0)*exp((-((x-x0)/B)^2)/2)+C',...
    'independent', 'x',...
    'dependent', 'y',...
    'problem', 'x0');
% cftool(xf,yf)
expfit = fit(xf, yf, fitType, opts, 'problem', 1761); %////////////////////1761
cfvl = coeffvalues(expfit);

figure(3);
clf;
plot(xf, yf); hold on;
plot(expfit);

I_md5 = abs(sqrt(2*pi)*cfvl(1)*(cfvl(2))^3);
data = spec.data / I_md5;


end

