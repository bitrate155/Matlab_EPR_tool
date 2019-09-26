function  spec  = subtractSpectra( spec, title )
index = find(strcmp({spec.title}, title)==1);
if length(index) == 1
    for i = 1:length(spec)
       if i ~= index
          interpolatedData = interp1(spec(index).field, spec(index).data, spec(i).field);
          spec(i).data = spec(i).data - interpolatedData;
       end
    end
    
elseif length(index) == 0
    warning('spectrum to substract wasnt found');
    
end



end