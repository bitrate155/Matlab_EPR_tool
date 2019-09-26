function plotSpectra( spec, plotOptions )
%PLOTSPECTRA Summary of this function goes here
%   Detailed explanation goes here


%% plot
figSpectra = figure(1); clf; plothandleSpectra = {}; legendListSpectra = {};

for i = 1:length(spec)  maxSpecAmpTemp(i) = max(abs(spec(i).data)); end
maxSpecAmp = max(maxSpecAmpTemp);

spatialAmpCorr = 1;
if isfield(plotOptions, 'spatialAmpCorr')
    spatialAmpCorr = plotOptions.spatialAmpCorr;
end

j = 1;

if isfield(plotOptions, 'spatialScheme')
    if plotOptions.spatialScheme == 'D'

        Div = [];
        for ii = 1 : length(plotOptions.spatialDividers) Div = [Div; [spec.(plotOptions.spatialDividers{ii})]]; end     
        Div = Div';

        BinaryMatrix = ones(size(Div));
        for ii = 1:size(Div,2) BinaryMatrix(:,ii) = 2^(ii-1); end

        S = dot(Div,BinaryMatrix,2);
        keys = unique(S);
        for ii = 1:length(keys)
           yShifts(ii) = ii; 
        end
        map = containers.Map(keys, yShifts);

    end
end


for i = 1:length(spec) %to plot only lines which TITLEs contain any from toPlot
    functionHandle = @(token)~cellfun('isempty', strfind( {spec(i).title}, token ) );
    strCount = cellfun(functionHandle, plotOptions.toPlot, 'UniformOutput', false);

    if( sum( cell2mat(strCount) ) > 0 )
        
        ySpecShift = 0;
        if isfield(plotOptions, 'spatialScheme')
            if plotOptions.spatialScheme == 'Y'
                ySpecShift = j * maxSpecAmp / spatialAmpCorr;
            end
 
            if plotOptions.spatialScheme == 'T'
                ySpecShift = spec(i).T * maxSpecAmp / spatialAmpCorr;
            end
            
            if plotOptions.spatialScheme == 'D'
                ySpecShift = maxSpecAmp * map(S(i))  / spatialAmpCorr;

            end

        end
        
        
        plothandleSpectra{j,1} = plot(spec(i).field, spec(i).data + ySpecShift ); hold on;
        plothandleSpectra{j,2} = i; %save id of original spectrum
        j = j+1;
        
%         legendListSpectra{end + 1} = num2str( spec(i).title(22:end) ); 
%         legendListSpectra{end + 1} = num2str( spec(i).title ); 
        legendListSpectra{end + 1} = num2str( num2str(spec(i).T) ); 


    end

end





%% plot appearence
figure(figSpectra);
figSpectra.Color = 'white';
%     plothandle{i}.LineWidth = 1;

N = length(plothandleSpectra);

%colorScheme
if isfield(plotOptions, 'colorScheme');
    if plotOptions.colorScheme == 'G'

        for i = 1 : N
            plothandleSpectra{i,1}.Color = [(N-i)/N 0 i/N];
        end
    end
    if plotOptions.colorScheme == 'T'

        maxT = max([spec.T]);
%         maxT = spec.T(1);
        for i = 1 : N
            T = spec(plothandleSpectra{i,2}).T;
            plothandleSpectra{i,1}.Color = [T/maxT 0 (maxT-T)/maxT];
        end
    end
    if plotOptions.colorScheme == 'D'

        Div = [];
        for i = 1 : length(plotOptions.colorDividers) Div = [Div; [spec.(plotOptions.colorDividers{i})]]; end     
        Div = Div';

        BinaryMatrix = ones(size(Div));
        for i = 1:size(Div,2) BinaryMatrix(:,i) = 2^(i-1); end

        S = dot(Div,BinaryMatrix,2);
        keys = unique(S);
        for i = 1:length(keys) colors(i) = plotOptions.colors(1 + mod(i-1, length(plotOptions.colors))); end    
        map = containers.Map(keys, colors);

        for i = 1 : N
            plothandleSpectra{i,1}.Color = map(S(i));
        end
    end
end

legend(legendListSpectra, 'Box', 'off',...
    'Location', 'eastoutside',...
    'Interpreter', 'none',... %'none' doesn't delete '_'
    'FontSize', 8); 

set(gca, 'FontName', 'Times New Roman',...
    'FontSize', 14,...
    'Box', 'off',...
    'LineWidth', 1,...
    'TickDir', 'out',...
    'XAxisLocation', 'origin');

xlabel('B, G');
ylabel('EPR signal');
% xlim([2000 4000]);
% ylim([-0.2 0.2]);

% xlim([3400 3600]);



end
