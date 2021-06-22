% extract robot geometry for given kinematics (Tfk)
function [tria, coordinate]=robotDK2Geom(rob, Tfk, idlink)

% rob: rotob model
% Tfk: DK kinematics
% idlink: list of links to be extracted

% coordinate: (xyz - doubles) => vertices of polygonal mesh
% tria: ([corner1 corner2 corner3] - doubles) => trias of polygonal mesh

nlink=length(rob.Geom.Face);

coordinate=[];
tria=[];
for i=idlink
    
    % extract coordinates
    coordinatei=rob.Geom.Vertices{i};
    triai=rob.Geom.Face{i};

    %--
    if i>1 
        if i<nlink
            T=setTransformation(Tfk, i-1); 
        else % build tool (TCP)s
            T=getTCPLocation(rob, Tfk);
        end
      coordinatei=apply4x4(coordinatei, T(1:3,1:3), T(1:3,4)'); 
    end
    
    % save out
    coordinate=[coordinate
                coordinatei]; %#ok<AGROW>
    
    if isempty(tria)
        ntria=0;
    else
        ntria=max(tria(:));
    end
    
    tria=[tria
          triai+ntria]; %#ok<AGROW>

end
