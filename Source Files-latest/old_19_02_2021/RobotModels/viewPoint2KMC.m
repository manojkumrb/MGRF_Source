% from viewpoint to KMC definition
function [KMC, CoP]=viewPoint2KMC(viewPoint, t, theta, phi)

% viewPoint: {1, ncluster}(1, nviews)
% t/theta/phi: tech parameters

% KMC: kmc data structure
% CoP: xyz coordinates

%--

% KMC=[];
% CoP=[];

% loop over all viewpoints
nc=length(viewPoint);

c=1;
for i=1:nc
   vpi=viewPoint{i}; 
   
   nci=length(vpi);
   
   for j=1:nci
       vpij=vpi{j};
       
       KMC(c)=initKMC(t, theta, phi); %#ok<AGROW>
       
       KMC(c).Vectors.Point=vpij.Pm; %#ok<AGROW>
       KMC(c).Vectors.Normal=vpij.R(:,3)'; %#ok<AGROW>
       KMC(c).R=vpij.R; %#ok<AGROW>
       
       KMC(c).Status=true; %#ok<AGROW>
       
       CoP{c}=vpij.CoP;
       
       c=c+1;
   end
end



