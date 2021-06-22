function [perpDist]=keyPointDistances(a1,a2, points,projectTO )
% A function to calculate the distance from axis defined by two nodes a1 and a2 to all mesh nodes
% 
% Args:
%   a1, a2: ID of two nodes defining the axis
%   points: nNodes x 3 matrix of points whose distance have to be calculated
%   projectTO: 1x3 vector specifying the plane, points have to be projected to, [0,0,1] represents z plane
%
% Returns:
%    **perpDIst** the vector of distances of mesh nodes from the axis, length = nNodes 
%
% .. note::
%   - the code calculates angle between point and line, so calculations limited to three dimensions
%   - for this two dimensinal projectioncase perpDist gives the sign as well


if sum(projectTO)~=0
    index=find(projectTO==1);
    points(:,index)=0;
    a1(:,index)=0;
    a2(:,index)=0;
end

[~,d]=size(points);
axis=(a2-a1)/norm(a2-a1); % a unit vector representing the line bw two points
vPoint2line=bsxfun(@minus,points,a1);
crossProd=cross(vPoint2line,repmat(axis,size(vPoint2line,1),1)); % not normalizing vPoint2line as we have to find distance
% distance = |aXb|/|b|, -using the definition; magnitude of cross product is equal to the area of the parallelogram-
% where b is a vector representing the line, if b is
% unit vector distance reduces to |aXb|, a is a vector from the line to the
% point to which the distance is to be measured


perpDist=sqrt(sum(crossProd.^2,2)); % sum(crossProd,2);%



% normPerpDist2=sqrt(sum(crossProd.^2,2)); % 
% normPerpDist=crossProd./repmat(normPerpDist2,1,d);
% % *onOneSide has 1 and -1 to represent two sides
% normVpoint2Line=sqrt(sum(vPoint2line.^2,2));
% vPoint2line=vPoint2line./repmat(normVpoint2Line,1,d); %normalised vector
% theta=acos(dot(vPoint2line,repmat(axis,size(vPoint2line,1),1),2));
% onOneSide=(theta<pi);
% onOneSide(onOneSide==0)=-1;

end