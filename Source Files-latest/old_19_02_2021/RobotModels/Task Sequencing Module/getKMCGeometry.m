function geom=getKMCGeometry(KMC, idkmct, res)

%INPUTS:
    % KMC - KMC structure
    % idkmc - id of KMC
    % res - geoemtrical resolution
    
% OUTPUTs:
%geom.
    % Face
    % Vertex

% set init output
geom.Face=[];
geom.Vertex=[];

% loop over all KMCs
for idkmc=idkmct 

    % get all the information for the feature
    P0 = KMC(idkmc).Vectors.Point;
    N0 = KMC(idkmc).Vectors.Normal;

    % get all the constraints
    teta(1) = min(KMC(idkmc).Constraints.Angle.Normal);
    teta(2) = max(KMC(idkmc).Constraints.Angle.Normal);

    phi(1) = min(KMC(idkmc).Constraints.Angle.Tangent);
    phi(2) = max(KMC(idkmc).Constraints.Angle.Tangent);

    f(1)=max(KMC(idkmc).Constraints.Distance);
    f(2)=min(KMC(idkmc).Constraints.Distance);

    h_max = [f(1) * cos(teta(1)*pi/180) f(1) * cos(teta(2)*pi/180)];
    h_min = [f(2) * cos(teta(1)*pi/180) f(2) * cos(teta(2)*pi/180)];

    %--
    % 1=inner; 2=outer
    for i=1:2

        if teta(i)~=0
            % inner/outer boundary
            [X, Y, Z] = renderConeObj(h_min(i), h_max(i), 2*teta(i), phi, P0, N0, res);

            % save
            geom=lclStore(X, Y, Z, geom);

        end

             % lower/upper boundary
             [X, Y, Z]=renderSpherePatchObj(f(i), 90-teta, phi, P0, N0, res);

             % save
             geom=lclStore(X, Y, Z, geom);

    end
    
end

%------------------------
function geom=lclStore(X, Y, Z, geom)

 fv=surf2patch(X, Y, Z);

 geom.Vertex=[geom.Vertex
              fv.vertices];

 %
 if ~isempty(geom.Face)
   nnode=max(geom.Face(:));
 else
   nnode=0;
 end

 tface=fv.faces+nnode;

 % save
 if size(tface,2)==4
    tface=splitQuad2Tria(tface);
 end

 geom.Face=[geom.Face
            tface];
        
        
        
        
        
