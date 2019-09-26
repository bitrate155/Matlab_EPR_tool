function spec = subtractSpectraDiv( spec, divPos, divNeg )
%SUBTRACTSPECTRADIV Summary of this function goes here
%   Detailed explanation goes here
specPos = spec([spec.(divPos)]==1);
specNeg = spec([spec.(divNeg)]==1);

for i = 1:length(spec)
    if spec(i).(divPos)  
        
        Tdiff = abs(spec(i).T - [specNeg.T]);
        [~, j] = min(Tdiff); %ADD WARNINGS IF TOO DIFFERENT
        spec(i).data = spec(i).data - specNeg(j).data;
        spec(i).title = [spec(i).title, ' - ', specNeg(j).title]


    
        
        
        
        
    end 
end


end


