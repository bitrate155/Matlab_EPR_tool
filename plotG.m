function  plotG( G )
%PLOTG Summary of this function goes here
%   Detailed explanation goes here

figResults = figure(2); clf; legendListResults = {};

for i=1:length(G)
    if G(i).toDraw
        plot(G(i).T, G(i).data, '.-', 'MarkerSize', 14); hold on;
        legendListResults{end+1} = G(i).name;
    end
end

figure(figResults);
figResults.Color = 'white';

legend(legendListResults, 'Box', 'off',...
    'Location', 'northwest',...
    'Interpreter', 'none',... %'none' doesn't delete '_'
    'FontSize', 8); 

set(gca, 'FontName', 'Times New Roman',...
    'FontSize', 14,...
    'Box', 'off',...
    'LineWidth', 1,...
    'TickDir', 'out');

xlabel('T, K');  
ylabel('G, a.u.');
    




end

