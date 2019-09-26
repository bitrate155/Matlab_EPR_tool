function spec = loadSpecParametersEMX( filelist )
%LOADSPECPARAMETERS Summary of this function goes here
%   Detailed explanation goes here

N = length(filelist);
for i=N:-1:1
    [f_load, s_load, p{i}] = eprload(filelist(i).name);
       
    spec(i).name = filelist(i).name; 
%     spec(i).title = p{i}.TITL;
%     spec(i).T = str2num(p{i}.TITL(regexp(p{i}.TITL, '_\d?\d?\dK') + 1 : regexp(p{i}.TITL, '\dK')));

    spec(i).points = p{i}.ANZ;
    spec(i).fmin = p{i}.GST;
    spec(i).fmax = p{i}.GST + p{i}.GSI;
    spec(i).field = f_load;
    spec(i).data = s_load; 
    spec(i).freq = p{i}.MF;

    clear f_load s_load
end


end