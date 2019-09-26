function spec = loadSpecParameters( filelist, divider )
%LOADSPECPARAMETERS Summary of this function goes here
%   Detailed explanation goes here
N = length(filelist);
n=nargin;

for i=N:-1:1
    [f_load, s_load, p{i}] = eprload(filelist(i).name);
       
    spec(i).name = filelist(i).name; 
    spec(i).title = p{i}.TITL;
    spec(i).T = str2num(p{i}.TITL(regexp(p{i}.TITL, '_\d?\d?\.?\dK') + 1 : -1 + regexp(p{i}.TITL, 'K')));    
    
    if n > 1 %divider works as a flags. For every divider, field-variable are created, showing if the divider substring in the title
        for idiv = 1:length(divider)
            spec(i).(divider{idiv}) = 0; %dynamic field-variable
            if not(isempty(regexp(spec(i).title, divider{idiv})))
                spec(i).(divider{idiv}) = 1;
            end
        end
    end 
        
    spec(i).att = str2double(p{i}.PowerAtten(1:end-3));
%     spec(i).rgain = p{i}.Gain;
    spec(i).points = p{i}.XPTS;
    spec(i).fmin = p{i}.XMIN;
    spec(i).fmax = p{i}.XMIN + p{i}.XWID;
    spec(i).field = f_load;
    spec(i).data = s_load; 
    spec(i).freq = p{i}.MWFQ;

    clear f_load s_load
end

end