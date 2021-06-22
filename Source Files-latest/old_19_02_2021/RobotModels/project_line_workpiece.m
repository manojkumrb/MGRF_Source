% project line on workpiece surface
function [Pg, Ng]=project_line_workpiece(Pse, np, workpiece, idwp, Nprojection, searchdist)

% Pse: start/end point of line (2x3)
% np: no. of points to sample (1,1)
% workpiece: workpiece model
% idwp: id domain within workpiece model (1x1)
% Nprojection: direction of projection (1x3)
% searchdist: searching distance

% Pg: point projected (np,3)
% Ng: normal vector @point projected (np,3)

%--------------------------
t=linspace(0,1,np);
        % 
        % pi=zeros(np,3);
        % for i=1:np
        %     pi(i,:)=Pse(1,:)+t(i)*(Pse(2,:)-Pse(1,:));
        % end
        
pi=createBezierPoint(Pse, 3, t);

% % get projection
[Pg, ~]=pointNormal2PointProjection(workpiece, pi, Nprojection, idwp);
[Pg, Ng, flag]=point2PointNormalProjection(workpiece, Pg, idwp, searchdist);

Pg=Pg(flag,:);
Ng=Ng(flag,:);