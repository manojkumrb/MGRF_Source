function [f, inData]=getObjStitchTuning(X, inData, femCurrent, npoint, searchDist, tolgap, tolSatisfact, tunOpt)

% X: inpput variable for stitch parametrisation (nStitch x 2)
    % first column: parameter T (stitch line)
    % first column: parameter V (stitch trasversal direction)

% inData: inout data structure
% femCurrent: fem structure
% npoint: no. of interpolation point
% searchDist: searching distance
% tolgap: tolerance for gap acceptance
% tolSatisfact: tolerance for stitch length satisfaction (percentage - %)
% tunOpt: "move"/"add"/"remove" = move stitch / add stitch / remove stitch

% f: objective function to be "MINIMISED (no. of unfeasible stitches)"
%---------------

if strcmp(tunOpt,'move')
   
   % STEP 1: create parametrisation
   tinData=inData;
   
   tsatLength=tinData.Stitch.StfLength;
   tinData.Stitch.Type(tsatLength>tolSatisfact)=0;
   
   parameter.V=X;
   
   %--------------------------
   % to be updated later on
   parameter.T=zeros(length(X),1);
   %--------------------------
   
   parameter.T(tsatLength>tolSatisfact)=0;
   parameter.V(tsatLength>tolSatisfact)=0;
   tinData=stitchParametrisation(tinData, parameter); % create a temporary copy of it
   
   % STEP 2: calculate new gap data   
   [gap, ~]=postProcessGap(femCurrent, tinData, npoint, searchDist);
   
   % STEP 3: calculate fitting function
    ng=length(gap); % total no. of stitches
    satLength=ones(ng,1);   

    for i=1:ng
        % get no. of stitch point in tolerance
        intoli=length(find(gap{i}<=tolgap));

        % check how much length is in tolerance
        satLength(i)=intoli/length(gap{i});

    end

    % fitting function
    f = length(satLength(satLength<=tolSatisfact));
       
    % STEP 4: update inData
    inData.Stitch.StfLength(tsatLength<=tolSatisfact) = satLength(tsatLength<=tolSatisfact);
    
%----------------------------
% add here other options
%----------------------------


else
   
    error('FEMP (Stitch tuning): Option for stitch tuning not supported')
    
end






        