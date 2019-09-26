function [spec I_md5] = normalizeToMD5Integral( spec, fieldLeft, fieldRight )
%NORMALIZESPEC Normalize spectra, so MD5 second integral = 1, simulates md5
%line with -A*(x-x0)*exp((-((x-x0)/B)^2)/2). fieldLeft and fieldRight are
%the limits where the line is simulated. Uses fieldId
%   Tumanov S
figureNum = 1002;

for i = 1 : length(spec)
   
    fitLimits = fieldId(spec(i), [fieldLeft fieldRight]);
    xf = spec(i).field(fitLimits(1):fitLimits(2));
    yf = spec(i).data(fitLimits(1):fitLimits(2));
    % yf = yf/max(yf);
    
    [minAmp, minId] = min( spec(i).data( fieldId(spec(i), fieldLeft ):fieldId(spec(i), fieldRight) ) );
    minId = -1 + minId + fieldId(spec(i), fieldLeft );
    [maxAmp, maxId] = max( spec(i).data( fieldId(spec(i), fieldLeft ):fieldId(spec(i), fieldRight) ) );
    maxId = -1 + maxId + fieldId(spec(i), fieldLeft );
    resId(i) =(mean([maxId, minId]));      
    resField = spec(i).field(round(resId(i)));
    
    resField = mean([spec(i).field(maxId), spec(i).field(minId)]);

    %     fitType = fittype('A*(xf-x0)*exp((-(xf-x0)*(xf-x0))/B)',...
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [1 15 0];

    fitType = fittype( '-A*(x-x0)*exp((-((x-x0)/B)^2)/2)+C',...
        'independent', 'x',...
        'dependent', 'y',...
        'problem', 'x0');
    % cftool(xf,yf)
    expfit = fit(xf, yf, fitType, opts, 'problem', resField); %////////////////////1761
    cfvl = coeffvalues(expfit);

    fig3 = figure(figureNum);
    clf;
    plot(xf, yf); hold on;
    plot(resField, 0, '*');
    plot(spec(i).field(maxId), maxAmp, '*');
    plot(spec(i).field(minId), minAmp, '*');
    plot(expfit);

    I_md5(1,i) = spec(i).T;
    I_md5(2,i) = abs(sqrt(2*pi)*cfvl(1)*(cfvl(2))^3);
    spec(i).data = spec(i).data / I_md5(2,i);
    
    [num2str(i) ' out of ' num2str(length(spec))]
end
    close(fig3);
end

