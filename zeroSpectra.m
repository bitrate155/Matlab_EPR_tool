function [ spec ] = zeroSpectra( spec, fieldLimits )
%ZEROSPECTRA Summary of this function goes here
%   Detailed explanation goes here

L = min(fieldLimits);
R = max(fieldLimits);

for i = 1:length(spec)
    for j = fieldId(spec(i), L):fieldId(spec(i), R)
       spec(i).data(j) = 0;
    end
end

