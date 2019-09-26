function spec=baselineCorrection(spec, varargin);
%BASELINECORRECTION bs subtraction by spline on [points] points. Works with 
%spec and spec(i). does not use fieldId()
%   baselineCorrection(spec, [points]), if [points] are not provided, uses
%   spec.fmin and fmax



for i = 1:length(spec)
    p = inputParser;
    p.addRequired('spec', @(x) true);
    p.addOptional('points', [spec(i).fmin spec(i).fmax], @isnumeric);
    p.parse(spec, varargin{:});
    points = p.Results.points;
    
    lf=length(spec(i).field);
    step=(spec(i).field(lf) - spec(i).field(1))/lf;
    pts=floor((points - spec(i).field(1))/step);

    if pts(1)==0 pts(1)=1; end;

    for id=1:1:length(points);
        fs(id) = spec(i).data(pts(id));
    end
    
    
%     pts = fieldId(spec(i), points); %/////

    bline = interp1(points,fs,spec(i).field,'spline');

    spec(i).data = spec(i).data - bline;

end