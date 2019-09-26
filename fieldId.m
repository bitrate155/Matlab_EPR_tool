function ids = fieldId( spec, points )
%FIELDIDS (spec, points) returns ids for field points. Works for any number
%of points
%   Detailed explanation goes here

delta = (spec.field(end) - spec.field(1)) / (spec.points - 1);

for i = 1:1:length(points)
    if (points(i) > spec.field(end)) || (points(i) < spec.field(1)) 
        warning([num2str(points(i)) ' is outside of field range for ' spec.title]);
    end
    ids(i) = 1 + round((points(i)-spec.field(1))/delta);
end

end

