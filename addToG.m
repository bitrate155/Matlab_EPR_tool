function G = addToG( G, spec, func, limits, name, varargin )
%ADDTOG 
%G = addToG( G, spec, func, limits, name, 'divider', {dividers},...
%'toDraw', true/false, 'toSort', true/false, 'normalize', 'max/maxall/...') 
%divider, toDraw, toSort and normalize are optional
%G is any value you want to get from spectra to plot G vs
%Temperature, ex. peak amplitude or integral
%
%func - funciton you want to use to obtain G, as for now it is max-min 
%(maxmin), or second integral (secInt), you could add more if you feel like
%it. 
%
%limits are used as field (in G) limits for func to compute G
%name is used in legend for this specific G
%
%'toDraw' is a logical flag (default - true), you can set it to false if
%you want to calculate this G, but you dont want it to be drawn
%
%'divider' is a string flag which is used to separate G into two (or more) 
%different G's, based on if 'divider' is a substring in a spec(i).title.
%For instance, if you want your G to be drawn as different lines for dark
%and light spectra, you use ...'divider', {'dark', 'light', ...}. 
%Note: '!word' will plot everything that does NOT contain 'word' as a 
%substring in the title
%
%'toSort' sorts every G, so the temperature rises. This avoids
%intersecting lines in resulted graphs, but may not be needed due to losing
%of some info. In that case set 'toSort' to false
%
%'normalize' tells function how to normalize each G. As for now, the
%options are to normalize 1) to maximum of G like there are no dividers
%('max'), 2) to maximum of G for every divider ('maxall'), and 3) to a G
%for specific temperature (G(TNorm)=1), TNorm parses normalize using
%regular expression 'T\d?\d?\dK', so send TNorm in this form (ex. 'T157K')
%
%Maybe I'll add a way to plot G vs something else rather than just
%vs temperature
%
%examples:
% G = addToG(G, spec, 'maxmin', [3000 4000], 'MyLine') - the simplest
% function call to find max amplitude between two points in range from 3000
% to 4000 G, and to name it MyLine in the legend
%
% G = addToG(G, spec, 'secInt', [0 1000], 'MainLine', 'divider', {'Tup', 'Tdown', '!Tup'},...
%'toDraw', false, 'toSort', false, 'normalize', 'max') - the function with
%all the optional parameters set
%
%   Tumanov 2019
L = min(limits); 
R = max(limits);

%% parsing inputs
p = inputParser;
p.addRequired('G', @(x) true);
p.addRequired('spec', @(x) true);
expectedFunc1 = {'maxmin', 'secInt', 'secIntDraw', 'secIntBc', 'secIntBcDraw'};
p.addRequired('func', @(x) any(validatestring(x, expectedFunc1)));
% p.addRequired('limits', @(x) length(x) == 2);
p.addRequired('limits', @(x) true);

p.addRequired('name', @ischar);
p.addParamValue('divider', {}, @iscellstr);
p.addParamValue('toDraw', true, @islogical);
p.addParamValue('toSort', true, @iscell);

expectedFunc2 = {'maxall', 'max', 'T\d?\d?\dK'};
p.addParamValue( 'normalize', '', @(x) isValidNormalize(x));


p.parse( G, spec, func, limits, name, varargin{:});
toDraw = p.Results.toDraw;
toSort = p.Results.toSort;

normalize = p.Results.normalize;

if length(p.Results.divider)
    divider =  p.Results.divider; 
end

if length(p.Results.divider)
    specCell = {};
    for i = 1 : length(divider)
        if divider{i}(1) == '!'
            specCell{end+1} = spec([spec.(divider{i}(2:end))] == 0)
        else 
            specCell{end+1} = spec([spec.(divider{i})] == 1) ;
        end
    end
else
    specCell = {spec};
end

%% computing G
len = length(G);
for i = 1:length(specCell)
    spec = specCell{i}; %the spec here should have a different name
    G(len+i).T = []; G(len+i).data = [];
    G(len+i).name = name;
    G(len+i).toDraw = toDraw;
    
    if length(p.Results.divider)
        nameEnding = [' ' divider{i}];
        G(len+i).name = [G(len+i).name nameEnding];
    end

    if strcmp(func, 'maxmin')
        for j=1:length(spec)
            s = spec(j);
            G(len+i).T(end+1) = s.T;
            G(len+i).data(end+1) = max(s.data(fieldId(s,L):fieldId(s,R))) - min(s.data(fieldId(s,L):fieldId(s,R)));
        end
        
    end
        
    if strcmp(func, 'secInt')
        for j=1:length(spec)
            s = spec(j);
            G(len+i).T(end+1) = s.T;
            G(len+i).data(end+1) = secInt(s.field(fieldId(s,L):fieldId(s,R)), s.data(fieldId(s,L):fieldId(s,R)));
        end
    end   
     
    if strcmp(func, 'secIntDraw')
        for j=1:length(spec)
            s = spec(j);
            G(len+i).T(end+1) = s.T;
            G(len+i).data(end+1) = secIntDraw(s.field(fieldId(s,L):fieldId(s,R)), s.data(fieldId(s,L):fieldId(s,R)));
        end
    end
    
    if strcmp(func, 'secIntBc')
        for j=1:length(spec)
            s = spec(j);
            G(len+i).T(end+1) = s.T;
            G(len+i).data(end+1) = secInt(s.field(fieldId(s,L):fieldId(s,R)), s.data(fieldId(s,L):fieldId(s,R)), limits);
        end
    end
    
    if strcmp(func, 'secIntBcDraw')
        for j=1:length(spec)
            s = spec(j);
            G(len+i).T(end+1) = s.T;
            G(len+i).data(end+1) = secIntDraw(s.field(fieldId(s,L):fieldId(s,R)), s.data(fieldId(s,L):fieldId(s,R)), limits);
        end
    end
        %you can add here other ways to compute G, just dont forget to
        %update expectedFunc1
    
    
    %sorting G so temperature rises, !!! may not be needed !!!
    if toSort{1+mod(i-1,length(toSort))}
        matG(:,1) = G(len+i).T; matG(:,2) = G(len+i).data;
        matG = sortrows(matG);
        G(len+i).T = matG(:,1); G(len+i).data = matG(:,2);
        clear matG;
    end
end

%% normalizing G
if isnumeric(normalize)
        for i = len+1 : length(G)
            G(i).data = G(i).data * normalize;
        end
else
    if strcmp(normalize, 'max')
        h = G(len+1:end).data;
        Gmax = max(h);
        for i = len+1 : length(G)
            G(i).data = G(i).data / Gmax;
        end
    end

    if strcmp(normalize, 'maxall')
        for i = len+1 : length(G)
            G(i).data = G(i).data / max(G(i).data);
        end
    end

    if any(regexp(normalize, 'T\d?\d?\dK'));
        TNorm = str2num(p.Results.normalize(2:end-1));
        for i = len+1 : length(G)
            [~, Tid] = min(abs(G(i).T - TNorm));
            G(i).data = G(i).data / G(i).data(Tid);
        end
    end
end




function result = isValidNormalize(normalize)
result = false;
    if isnumeric(normalize)
        result = true;
    else
        result = any(cell2mat(regexp(normalize, expectedFunc2)));
    end

end


end









