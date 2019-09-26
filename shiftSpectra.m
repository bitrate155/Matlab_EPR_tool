function [ spec ] = shiftSpectra( spec, fieldLeft, fieldRight )
%SHIFTSPECTRA ( spec, fieldLeft, fieldRight ) 
%Shifts spectra along x, so mean([maxId, minId]) for all spectra
%are the same, normalizing to the field of spec(1); 
%Best when used for md5 resonator signal
%   Detailed explanation goes here

for i = 1:length(spec)
    [minAmp, minId] = min( spec(i).data( fieldId(spec(i), fieldLeft ):fieldId(spec(i), fieldRight) ) );
    minId = minId + fieldId(spec(i), fieldLeft );
    [maxAmp, maxId] = max( spec(i).data( fieldId(spec(i), fieldLeft ):fieldId(spec(i), fieldRight) ) );
    maxId = maxId + fieldId(spec(i), fieldLeft );
    
    resId(i) =(mean([maxId, minId])); 
    
    delta = round(resId(i) - resId(1)); %x offset
    
    spec(i).field = spec(i).field - (spec(i).field(round(resId(i))) - spec(i).field(round(resId(1))));
    spec(i).fmin = min(spec(i).field);
    spec(i).fmax = max(spec(i).field);
end

end

