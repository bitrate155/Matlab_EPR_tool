function specnew=basecool(field,spec,bs);
%BASECOOL Summary of this function goes here
%   Detailed explanation goes here

lf=length(field);
lb=length(bs);
step=(field(lf)-field(1))/lf;
pts=floor((bs-field(1))/step);
if pts(1)==0 pts(1)=1; end;


for id=1:1:lb
    
    fs(id)=spec(pts(id));
end;

bline=interp1(bs,fs,field,'spline');

specnew=spec-bline;

