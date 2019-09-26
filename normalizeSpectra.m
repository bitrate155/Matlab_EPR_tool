function spec = normalizeSpectra( spec, fieldLeft, fieldRight )
%NORMALIZESPEC Normalize spectra, so max-min=1 between fieldLeft and
%fieldRight fields; Uses fieldId to compute ids
%   Tumanov S

for i = 1 : length(spec)
    [res.min, res.minId] = min( spec(i).data( fieldId(spec(i), fieldLeft ):fieldId(spec(i), fieldRight) ) );
    res.minId = res.minId + fieldId(spec(i), fieldLeft );
    [res.max, res.maxId] = max( spec(i).data( fieldId(spec(i), fieldLeft ):fieldId(spec(i), fieldRight) ) );

    res.maxId = res.maxId + fieldId(spec(i), fieldLeft );
    res.resId =(mean([res.maxId, res.minId])); 
    spec(i).data = spec(i).data / (res.max - res.min); %Normalization
end

end

