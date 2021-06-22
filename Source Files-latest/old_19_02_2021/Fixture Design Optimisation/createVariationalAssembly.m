% create variational mesh based on PCA decomposition
function fem=createVariationalAssembly(fem, pcadata, maxsmooth, parameter)

% INPUT:
% fem: nominal fem structure
% pcadata: pca data structure
% maxsmooth: max smooth iterations
% parameter: random values for surface generation = [1 x npart x nmode]

% OUTPUT:
% fem: updated fem structure

% define options
fem.Options.StiffnessUpdate=false;
fem.Options.ConnectivityUpdate=false; 
fem.Denoise.Options.MaxIter=maxsmooth;

% no. part to process
npart=length(pcadata);

% generate variational part
domainlist=[];
for p=1:npart

    v=pcadata(p).Mean;
    
    if ~isempty(parameter{p})
    
        nmode=size(pcadata(p).EigenVect,2);
        for i=1:nmode

            sig=parameter{p}(i)*pcadata(p).EigenVal(i)^0.5;
            v=v+sig*pcadata(p).EigenVect(:,i);

        end
        
        % create variational geometry
        fem=createVariationalMesh(fem,...
                                   v);
                
        domainlist=[domainlist, p];
                                  
    end
    
end

% smoothing model
if ~isempty(domainlist)
    
    %--
    fem=femPreProcessing(fem);
        
    fem.Denoise.Options.Domain=domainlist;
    fem=meanFilterMesh(fem);
    
    %--
    fem=femPreProcessing(fem);
    
end






    