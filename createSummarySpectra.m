function  spec  = createSummarySpectra( spec )
%CREATESUMMARYSPECTRA averages spectra with the same TITLE, except for the
%last symbol; (spec_1 + spec_2 + ... + spec_n ) / n = spec_s
%   Detailed explanation goes here

i=1;
while true
    if i > length(spec)
        break;
    end
    
    ii = i+1;
    while true
        if ii > length(spec)
            break;
        end
        
        if strcmp(spec(i).title(1:end-1), spec(ii).title(1:end-1)); %titles(1:end-1) same
            spec(i).data = [spec(i).data, spec(ii).data]; %ii added to i spectrum
            spec(i).title = [spec(i).title(1:end-2), '_s']; %_s for summary
            spec(ii) = [];
        else
            ii = ii + 1;
        end
    end
    spec(i).data = mean(spec(i).data, 2); %averaging
    i = i+1;
end


end

