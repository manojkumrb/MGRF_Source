function viewPoint=getViewPoint(point, normal, ncluster, S)

% point: xyz coordinates
% normal: xyz normal vectors
% ncluster: no. of clusters
% S=[W0, L0, D0]: width, length and depth of the camera 

% viewPoint: {1, ncluster}(1, nviews)
       % .Range.X/Y/Z
       % .R: rotation matrix
       % .Pm: centre of point cloud
       % .CoP: xyz of cloud
   
%--
W0=S(1); % x
L0=S(2); % y
D0=S(3); % z
    
% init output
viewPoint=cell(1,ncluster);

% STEP 1: run clustering (K means)
idk=kmeans(normal, ncluster);

% loop over each cluster
for kc=1:ncluster
        
    % extrat points IDs
    id=find(idk==kc);

    % point
    pointk=point(id,:);
    
    % normal
    normalk=normal(id,:);
    
    % tag (visited/ not visited nodes)
    tagk=false(1,size(pointk,1));
    
    % estimate view direction
    Nvk=mean(normalk,1); Nvk=Nvk/norm(Nvk);
    
    % get bounding volume
    bb=getBoundingVolume(pointk, Nvk, S);

    %--
    rx=bb.Range.X; Nx=ceil(diff(rx)/W0);
    ry=bb.Range.Y; Ny=ceil(diff(ry)/L0);
    rz=bb.Range.Z; Nz=ceil(diff(rz)/D0);

    % loop over all sub-views
    viewPointk=[];
    c=1;
    for i=1:Nx
        for j=1:Ny
            for k=1:Nz
                
                % check sub-domain
                bbs=splitBoundingVolume(bb, [Nx, Ny, Nz], [i j k]);

                % check if any point inside
                [inblock, tagk, flag]=inBoundingBox(bbs, pointk, tagk);

                if flag % if yes

                    % adjust viewpoint
                    pointijk=pointk(inblock,:);
                    Nvijk=mean(normalk(inblock,:),1); Nvijk=Nvijk/norm(Nvijk);
%                     bbijk=getBoundingVolume(pointijk, Nvijk, S);
                    bbijk=getBoundingVolume(pointijk, Nvk, S);
                    
                    % extract CoP
                    [inblock, ~, flag]=inBoundingBox(bbijk, pointijk, false(1,size(pointijk,1)));
                    if flag
                        cop=pointijk(inblock,:);
                        
                        % save it back
                        if size(cop,1)>200;

                            % save it back
                            bbijk.CoP=cop;
                                                        
                            viewPointk{c}=bbijk; %#ok<AGROW>
                            c=c+1;
                        end
                    end

                end
            end
        end
    end
    
    viewPoint{kc}=viewPointk;
    
end


