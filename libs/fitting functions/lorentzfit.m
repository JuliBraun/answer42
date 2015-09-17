function [yprime params resnorm residual lor_freqs] = lorentzfit(x,y,p0,bounds,nparams)
% LORENTZFIT fits a single- or multi-parameter Lorentzian function to data
%
%   LORENTZFIT(X,Y) returns YPRIME(X), a Lorentzian fit to the data
%   found using LSQCURVEFIT. The function Y(X) is fit by the model:
%       YPRIME(X) = P1./((X - P2).^2 + P3) + C.
%
%   [YPRIME PARAMS RESNORM RESIDUAL] = LORENTZFIT(X,Y) returns YPRIME(X) 
%   values in addition to fit-parameters PARAMS = [P1 P2 P3 C]. The RESNORM
%   and RESIDUAL outputs from LSQCURVEFIT are also returned.
%
%   [...] = LORENTZFIT(X,Y,P0) can be used to provide starting
%   values (P0 = [P01 P02 P03 C0]) for the parameters in PARAMS.
%
%   [...] = LORENTZFIT(X,Y,P0,BOUNDS) may be used to define lower 
%   and upper bounds for the possbile values for each parameter in PARAMS.
%       BOUNDS = [LB1 LB2 LB3 LB4;
%                 UB1 UB2 UB3 UB4].
%   If the user does not wish to manually define values for P0, it may be
%   enetered as an empty matrix P0 = []. In this case, default values will
%   be used. The default bounds for all parameters are (-Inf,Inf).
%
%   [...] = LORENTZFIT(X,Y,P0,BOUNDS,NPARAMS) may be used to specify the
%   number of parameters used in the Lorentzian fitting function. The 
%   number of parameters defined in P0 and BOUNDS must match the function 
%   specified by NPARAMS. If the user does not wish to manually define 
%   values for P0 or BOUNDS, both may be enetered as empty matricies: 
%   P0 = []; BOUNDS = [].
%
%   -NPARAMS options
%       
%           '1'     - Single parameter Lorentzian (no constant term)
%                     L1(X) = 1./(P1(X.^2 + 1))
%
%           '1c'    - Single parameter Lorentzian (with constant term)
%                     L1C(X) = 1./(P1(X.^2 + 1)) + C
% 
%           '2'     - Two parameter Lorentzian (no constant term)
%                     L2(X) = P1./(X.^2 + P2)
%
%           '2c'    - Two parameter Lorentzian (with constant term)
%                     L2C(X) = P1./(X.^2 + P2) + C
%
%           '3'     - Three parameter Lorentzian (no constant term)
%                     L3(X) = P1./((X - P2).^2 + P3)
%
% [DEFAULT] '3c'    - Three parameter Lorentzian (with constant term)
%                     L3C(X) = P1./((X - P2).^2 + P3) + C
%
%   X and Y must be the same size, numeric, and non-complex. P0 and BOUNDS
%   must also be numeric and non-complex. NPARAMS is a character array.
%
%   Examples: 
%       x = -16:0.1:35;
%       y = 19.4./((x - 7).^2 + 15.8) + randn(size(x))./10;
%       [yprime1 params1 resnorm1 residual1] = lorentzfit(x,y,[20 10 15 0]);
%       figure; plot(x,y,'b.','LineWidth',2)
%       hold on; plot(x,yprime1,'r-','LineWidth',2)
%
%       [yprime2 params2 resnorm2 residual2] = lorentzfit(x,y,[],[],'3');
%       figure; plot(x,y,'b.','LineWidth',2)
%       hold on; plot(x,yprime2,'r-','LineWidth',2)
%
%   See also: lsqcurvefit.

% Jered R Wells
% 11/15/11
% jered [dot] wells [at] duke [dot] edu
%
% v1.1 (03/09/12)
%
% REF: http://www.home.uos.de/kbetzler/notes/fitp.pdf
%

% Check inputs

p3 = ((max(x(:))-min(x(:)))./30);
p2 = (max(x(:))+min(x(:)))./2;
p1 = max(y(:)).*p3; 
c = min(y(:));

lb = [-Inf,-Inf,-Inf,-Inf];
ub = [Inf,Inf,Inf,Inf];

if ~all(size(x)==size(y)); error 'X and Y must be the same size'; end
if ~isnumeric(x)||~isreal(x); error 'X must be numeric and real'; end
if ~isnumeric(y)||~isreal(y); error 'Y must be numeric and real'; end
xcheck=x;
ycheck=y;
counter=0;
for i=1:numel(xcheck)
    if isnan(xcheck(i))
        x(i-counter)=[];
        y(i-counter)=[];
        counter=counter+1;
    end
    if isnan(ycheck(i))
        x(i-counter)=[];
        y(i-counter)=[];
        counter=counter+1;
    end
end

if nargin==2; 
    p0 = [p1 p2 p3 c];
elseif nargin==3
    if ~isnumeric(p0)||~isreal(p0);
        p0 = [p1 p2 p3 c];
    end
    if isempty(p0);
        p0 = [p1 p2 p3 c];
    elseif numel(p0)~=4
        error 'P0 must be empty or it must contain four parameter values'; 
    end
elseif nargin==4
    if ~isnumeric(p0)||~isreal(p0);
        p0 = [p1 p2 p3 c];
    end
    if isempty(p0);
        p0 = [p1 p2 p3 c];
    elseif numel(p0)~=4
        error 'P0 must be empty or it must contain four parameter values'; 
    end
    if ~isnumeric(bounds)||~isreal(bounds)
        p0 = [p1 p2 p3 c];
    end
    if isempty(bounds)
    elseif ~all(size(bounds)==[2 4]) 
        error 'BOUNDS must be empty or it must be a 2x4 matrix';
    else
        lb = bounds(1,:);
        ub = bounds(2,:);
    end
    if any(lb>=ub)
        error 'Lower bounds must be less than upper bounds'; 
    end
    
elseif nargin==5
    if ~isnumeric(p0)||~isreal(p0);
        p0 = [p1 p2 p3 c];
    end
    if ~isnumeric(bounds)||~isreal(bounds)
        error 'BOUNDS must be numeric and real';
    end
    
    switch lower(nparams)
        case '3c'
            % Define P0, LB, UB
            if isempty(p0);
                p0 = [p1 p2 p3 c];
            elseif numel(p0)~=4
                error 'P0 must be empty or have four elements for NPARAMS = ''3c'''; 
            end
            
            if isempty(bounds)
            elseif ~all(size(bounds)==[2 4]) 
                error 'BOUNDS must be empty or it must be a 2x4 matrix for NPARAMS = ''3c''';
            else
                lb = bounds(1,:); ub = bounds(2,:);
            end
            
            if any(lb>=ub)
                error 'Lower bounds must be less than upper bounds'; 
            end
        otherwise
            error 'Invalid entry for NPARAMS'
    end
    return
else
    error 'Invalid number of input arguments specified';
end

options=optimset('TolFun', 1e-12, 'TolX', 1e-12)
[params resnorm residual] = lsqcurvefit(@lfun3c,p0,x,y,lb,ub,options);
yprime = lfun3c(params,x);
lor_freqs=x;
end % MAIN

function F = lfun3c(p,x)
F =  p(4)+p(1).*p(3)./(4.*(x-p(2)).^2+p(3).^2);
end % LFUN3C
