function spec = smoothSpectra( spec, varargin )
%SMOOTHSPECTRA just a datasmooth with default point of moving average = 10,
%works for spec and spec(i)
%   specify ('range', m) for a different value
%Tumanov 2019

p = inputParser;
p.addRequired('spec', @(x) true);
p.addParamValue('range', 10, @isscalar);
p.parse(spec, varargin{:});


if(isfield(p.Results, 'range'))
    range =  p.Results.range; 
end
    
for i = 1 : length(spec)
%     spec(i).data = datasmooth(spec(i).data, range, 'savgol');
    spec(i).data = smooth(spec(i).data, range, 'sgolay');

end

end

