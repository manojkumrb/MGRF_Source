function distData=getMinGeometricDistanceKMC(KMC, res)

% INPUT
% KMC: kmc structure
% res: geometry resolution

% OUTPUT
% distData(i,j).
    % P=[Pi; Pj]
    % D=distance norm(pi-Pj)
    
err=1e-2;

nKmc=length(KMC);

distData(1,1)=lcnInitDistData(); distData(nKmc,nKmc)=lcnInitDistData();
for i=1:nKmc
    kmci=getKMCGeometry(KMC, i, res);
    for j=1+1:nKmc
        kmcj=getKMCGeometry(KMC, j, res);
        [dij, Pi, Pj]=distanceChecker(kmci.Vertex, kmci.Face, kmcj.Vertex, kmcj.Face, err, err);
        
        % save out
        distData(i, j).P=[Pi; Pj];
        distData(i, j).D=dij;
        
        %---- symmetric condition
        distData(j, i).P=[Pi; Pj];
        distData(j, i).D=dij;
    end
end


%---
function distData=lcnInitDistData()

distData.P=zeros(2,3);
distData.D=0.0;
