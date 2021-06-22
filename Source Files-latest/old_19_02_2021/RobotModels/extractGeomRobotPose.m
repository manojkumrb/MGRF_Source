% extract robot geometry for given kinematics (Tfk)
function [tria, coordinate, T]=extractGeomRobotPose(rob, Tfk, Tw0, idlink)

% rob: rotobo model
% Tfk: DK kinematics
% Tw0: trasform world ref. system
% idlink: id of the link to be extracted

% coordinate: (xyz - doubles) => vertices of polygonal mesh
% tria: ([corner1 corner2 corner3] - doubles) => trias of polygonal mesh
% T: corresponding trasformation matrix

nlink=length(rob.Options.ShowLink);

robtype=rob.Model{rob.Model{1}+1};

%--
if idlink>1 
    if idlink<nlink
        
        % extract coordinates
        coordinate=rob.Geom.Vertices{idlink};
        tria=rob.Geom.Face{idlink};
        
        if strcmp(robtype,'ABB6620')
            T=setTransformation(Tfk, idlink-1); 
        elseif strcmp(robtype,'ABB6700-200') || strcmp(robtype,'ABB6700-235')
            if idlink==8 % cylinder
                T=setTransformationCylABB6700(rob, Tfk);
            else
                T=setTransformation(Tfk, idlink); 
            end
        else
            
            %------------------------
            
        end
        
        T=Tw0*T;
    else % build tool (TCP)
        T=getTCPLocation(rob, Tfk);
        T=Tw0*T;
        
        % extract coordinates
        coordinate=rob.Tool.Geom.Vertices;
        tria=rob.Tool.Geom.Face;
    end
  coordinate=apply4x4(coordinate, T(1:3,1:3), T(1:3,4)'); 
else
    T=Tw0;
    
    % extract coordinates
    coordinate=rob.Geom.Vertices{idlink};
    tria=rob.Geom.Face{idlink};
        
    coordinate=apply4x4(coordinate, T(1:3,1:3), T(1:3,4)'); 
end
