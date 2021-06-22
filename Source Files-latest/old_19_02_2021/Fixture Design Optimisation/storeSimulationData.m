% store current data set
function storeSim=storeSimulationData(fem, gapdistr, Pgap, reacForce)

% INPUT:
% fem: current fem solution
% gapdistr: gap distribution along stitches
% Pgap: xyx coordinates of evaluation points
% reacForce: reaction forces

% OUTPUT
% storeSim: updated database

%------------
% store:
% 1: solution: gap / U / UserExp / reacForce
% 2: boundary conditions
% 3: domain conditions

%-------
% storeSim.Gap
% storeSim.U
% storeSim.UserExp
% storeSim.ReacForce

% storeSim.GapStitch
% storeSim.ModelSet.Boundary
% storeSim.ModelSet.Domain
%-------

if nargin==1
    gapdistr=[];
    Pgap=[];
end

if nargin<4
    reacForce=[];
end

% store gap
storeSim.Gap=fem.Sol.Gap;
storeSim.GapStitch=gapdistr;
storeSim.PStitch=Pgap;

% store solutuion
storeSim.U=fem.Sol.U;

%--
storeSim.Log=fem.Sol.Log;

% store solutuion
storeSim.UserExp=fem.Sol.UserExp;

% store react force
storeSim.ReacForce=reacForce;

% store boundary
storeSim.ModelSet.Boundary=fem.Boundary;

% store domain
storeSim.ModelSet.Domain=fem.Domain;
