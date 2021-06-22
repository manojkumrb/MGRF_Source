function [pointc, facec]=extractCompensationWM(rob, Tfk, T0w)

%--
compensationVal=rob.Tool.Parameter.Compensation.Value;
xo=rob.Tool.Parameter.Compensation.Offset;

yc=compensationVal(1); zc=compensationVal(2);

% get tranformation
T0tcp=getTCPLocation(rob, Tfk);

% get points
pointc=[xo yc/2 zc/2
        xo -yc/2 zc/2
        xo -yc/2 -zc/2
        xo yc/2 -zc/2];

facec=[1 2 3 4];

T=T0w*T0tcp;
pointc=apply4x4(pointc, T(1:3,1:3), T(1:3,4)');
