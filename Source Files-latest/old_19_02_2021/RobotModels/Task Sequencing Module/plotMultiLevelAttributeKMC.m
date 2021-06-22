% plot multi-weigheted attributes for given KMC
function plotMultiLevelAttributeKMC(KMC, idkmc, WeightData, StationData, HierarchyData, res, nslices, tag, ax)

% WeightData.
    % Distance
    % Collision
    % Coverage
    % ...

% StationData.
    % Robot
    % Workpiece

% HierarchyData
    % Top: "distance", "collision", "coverage" (string)
    % Bottom: "distance", "collision", "coverage" (cell array [1xnc])
    
% opt: "point", "distance", "collision", "coverage"

% res: graphical resolution
% nslices: no. of slices
% tag: tag
% ax: current axes

minW=1e9;

t=linspace(KMC(idkmc).Constraints.Distance(1), KMC(idkmc).Constraints.Distance(2), nslices);
theta=linspace(KMC(idkmc).Constraints.Angle.Normal(1),KMC(idkmc).Constraints.Angle.Normal(2), res)*pi/180;
phi=linspace(KMC(idkmc).Constraints.Angle.Tangent(1),KMC(idkmc).Constraints.Angle.Tangent(2), res)*pi/180;

[THETA, PHI]=meshgrid(theta,phi);

% plot slices
for i=1:nslices
    % extract data
    [Px,Py,Pz, W]=lncGetMultiLevelAttributeKMC(t(i), THETA, PHI, KMC, idkmc, WeightData, StationData, HierarchyData);

    % clamp solution
    W(W>0)=0;
    
    % plot slice
    surf(Px, Py, Pz, W,'edgecolor','none','facecolor','interp', 'parent', ax, 'tag', tag);
    
    if min(W(:))<=minW
        minW=min(W(:));
    end

end

% plot KMC
KMC(idkmc).Graphic.Color='g'; 
KMC(idkmc).Graphic.Show=true;
KMC(idkmc).Graphic.FaceAlpha=0.1;
plotKMC(KMC, idkmc, res, tag, ax)

caxis(ax, [minW 0]);

%--
function [Px,Py,Pz,W]=lncGetMultiLevelAttributeKMC(t, theta, phi, KMC, idkmc, WeightData, StationData, HierarchyData)

n=size(theta,1);
Px=zeros(n);
Py=zeros(n);
Pz=zeros(n);
W=zeros(n);

for i=1:n
    for j=1:n
        X=[t theta(i,j) phi(i,j)];

        Pij=getMultiLevelAttributeKMC(X, KMC, idkmc, WeightData, StationData, 'point');
        
        Px(i,j)=Pij(1);
        Py(i,j)=Pij(2);
        Pz(i,j)=Pij(3);
              
        % calculate multi-level weights (using Hamacher T-norm)
        nc=length(HierarchyData.Bottom);
        Wij=getMultiLevelAttributeKMC(X, KMC, idkmc, WeightData, StationData, HierarchyData.Bottom{1});

        for k=2:nc
            Wij=HamacherTNorm( getMultiLevelAttributeKMC(X, KMC, idkmc, WeightData, StationData, HierarchyData.Bottom{k}), Wij );
        end
        
        W(i,j)=Wij;

    end
end


