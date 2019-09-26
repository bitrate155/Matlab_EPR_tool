function result = secInt(x,y,bc)
%SECINT second integral, if 3 args - 3rd for basecooling
%secInt(x,y,bc)
figureNum = 1001;
n=nargin;
if (n==2)||(n==3)
    
    figure(figureNum);
    subplot(2, 2, 1), plot(x,y);hold on; title('original data');
    
    for i=1:length(x)
        first_int(i)=sum(y(1:i));
    end;
    subplot(2, 2, 2), plot(x,first_int);hold on; title('first int');

    if n==3
        first_int=basecool(x,first_int',bc);
        subplot(2, 2, 4), plot(x,first_int);hold on; title('first int basecool');
    end

    for i=1:length(x)
        second_int(i)=sum(first_int(1:i));
    end;

    subplot(2, 2, 3), plot(x,second_int);hold on; title('second int');
    

    result=max(abs(second_int));
else
   error('Wrong number of function inputs. Needs (field data) or (field data basecool_pt1 basecool_pt2)'); 
end