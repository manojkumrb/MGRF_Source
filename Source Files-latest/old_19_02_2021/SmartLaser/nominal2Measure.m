function [Rmn, pmn, Rmeas, pmeas, Rnom, pnom, log]=nominal2Measure()

% datummeas/datumnom: measured and nominal datums

% Rmn/pmn: rotation and position vector
% log

%%
datummeas=[2002.95 167.95 222.22
           2141.76 443.30 848.51 
            2062.20 456.23 760.81];
           
datumnom=[2008 171.88 230.88
         2144.81 446.96 857.74
    2065.25 459.61 769.98];

%% build measured frame       
P0=datummeas(1,:);
P1=datummeas(2,:);
P2=datummeas(3,:);
[Rmeas, pmeas]=buildFrame3Pt(P0, P1, P2);

l1m=norm(P0-P1);
l2m=norm(P0-P2);

%% build nominal frame      
P0=datumnom(1,:);
P1=datumnom(2,:);
P2=datumnom(3,:);
[Rnom, pnom]=buildFrame3Pt(P0, P1, P2);

l1n=norm(P0-P1);
l2n=norm(P0-P2);

%% calculate transformation
Rmn=Rmeas*Rnom';
pmn=pmeas-(Rmn*pnom')';

log.errl1=l1m-l1n;
log.errl2=l2m-l2n;