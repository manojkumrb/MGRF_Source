% plot "idkmc"
function plotKMC(KMC, idkmc, res, tag, ax)

%INPUTS:

    % KMC - KMC structure
    % idkmc - id of KMC
    % res - resolution of surfce
    % tag - tag
    % ax - axes

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

% plot
if KMC(idkmc).Graphic.Show
    
    for i=1:2
        if KMC(idkmc).Graphic.ShowEdge
            edgecol=KMC(idkmc).Graphic.EdgeColor;
        else
            edgecol='none';
        end

        if teta(i)~=0
            % inner/outer boundary
            [X, Y, Z] = renderConeObj(h_min(i), h_max(i), 2*teta(i), phi, P0, N0, res);
            surf(X, Y, Z,'facecolor', KMC(idkmc).Graphic.Color(1,:),...
                         'edgecolor',edgecol,...
                         'facealpha',KMC(idkmc).Graphic.FaceAlpha,...
                         'parent' , ax,...
                         'tag',tag);
        end

            % lower/upper boundary
            [X, Y, Z]=renderSpherePatchObj(f(i), 90-teta, phi, P0, N0, res);
            surf(X, Y, Z,'facecolor', KMC(idkmc).Graphic.Color(1,:),...
                         'edgecolor',edgecol,...
                         'facealpha',KMC(idkmc).Graphic.FaceAlpha,...
                         'parent' , ax,...
                         'tag',tag);
        
    end
    
end

% KMC point and frame
rc=KMC(idkmc).Scalars.Diameter; 
[X,Y,Z]=renderSphereObj(rc, P0);

if KMC(1).Graphic.ShowEdge
     surf(X,Y,Z,...
          'facecolor','k',...
          'edgecolor',KMC(idkmc).Graphic.EdgeColor(1,:),...
          'facealpha',1,...
          'parent',ax,...
          'tag', tag)
else
     surf(X,Y,Z,...
          'facecolor','k',...
          'edgecolor','none',...
          'facealpha',1,...
          'parent',ax,...
          'tag', tag)
end

if KMC(idkmc).Graphic.ShowFrame
    Laxis=KMC(idkmc).Graphic.LengthAxis;
    plotFrame(KMC(idkmc).R, KMC(idkmc).Vectors.Point, Laxis, ax, tag)
end
