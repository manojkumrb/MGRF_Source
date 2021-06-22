% get deformation patters based on PCA
function pcadata=processingPatternsPCA(fem, inData, dsear, tvar)

% INPUT:
% fem: fem structure
% inData: user data
% dsear: searching distance for deviation calculation
% tvar: percentage of variance to neglect

% OUTPUT:
% pcadata: PCA data


% set initial data structure
pcadata.EigenVect=[]; % eigenvectors
pcadata.EigenVal=[]; % eigenvalues
pcadata.Mean=[]; % average 
pcadata.Deviation=[]; % deviations
pcadata.CoP=[]; % clouds of points        
        
% no. part to process
if ~isempty(inData.Measurement)
    
        npart=length(inData.Measurement);

        % no. of nodes
        nnode=size(fem.xMesh.Node.Coordinate,1);

        % loop over all parts
        for k=1:npart

            idpart=inData.Measurement(k).Domain;
            folderbin=inData.Measurement(k).Folder;
            offset=inData.Measurement(k).Offset;

            flag=inData.Measurement(k).Enable;

            % set initial settings
            pcadata(idpart).EigenVect=[];
            pcadata(idpart).EigenVal=[]; 
            pcadata(idpart).Mean=[];  
            pcadata(idpart).Deviation=[]; 
            pcadata(idpart).CoP=[];    

            if flag==1

                disp('>>--')
                fprintf('Working on part: %g\n',idpart);

                filep=dir(folderbin); % read all files in the folder

                np=length(filep);

                % get all indexes and coordinates
                count=1;
                idnode=fem.Domain(idpart).Node;
                node=fem.xMesh.Node.Coordinate(idnode,:);
                normal=fem.xMesh.Node.Normal(idnode,:);

                d=[];
                tic;
                for i=1:np

                    if ~filep(i).isdir % get only COP files

                        fprintf('      Getting deviations - CoP: %g\n',count);

                        filename=filep(i).name;
                        cop=importdata([folderbin,'\',filename]);

                        % get deviations:    
                        dev=getNormalDevPoints2Points(node,...
                                                      normal,...
                                                      cop,...
                                                      dsear)+offset;

                        dtemp=zeros(nnode,1);                          
                        dtemp(idnode)=dev; 

                        d=[d, dtemp];

                        pcadata(idpart).CoP{count}=cop; % cop

                        count=count+1;

                    end
                end
                tcop=toc;

                fprintf('      Getting deviations - computational time: %f seconds\n',tcop);

                disp('>>--')
                disp('      Getting PCA decomposition');

                % apply PCA
                tic;
                [V, lamda, mu]=getPCADecomposition(d(idnode,:),tvar);
                tpca=toc;

                fprintf('      Getting PCA decomposition - computational time: %f seconds\n',tpca);

                % save results
                pcadata(idpart).EigenVect=zeros(nnode,size(V,2));
                pcadata(idpart).EigenVect(idnode,:)=V; % eigenvectors

                pcadata(idpart).Mean=zeros(nnode,1); 
                pcadata(idpart).Mean(idnode)=mu;

                pcadata(idpart).EigenVal=lamda; % eigenvalues

                pcadata(idpart).Deviation=d; % deviations

                % log report
                fprintf('      PCA report - percentage of variance neglected: %.2f%s\n',tvar*100,'%');
                fprintf('      PCA report - no. of main modes: %g\n',length(lamda));

            end


        end

end




