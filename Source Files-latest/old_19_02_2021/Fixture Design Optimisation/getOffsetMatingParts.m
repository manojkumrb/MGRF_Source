% calculate initial part-to-part gaps
function fem=getOffsetMatingParts(fem0, fem)

% INPUT:
% fem0: fem0 structure (nominal geometry)
% fem: fem structure (current geometry - boundary constraints are here defined)

% NOTICE: part-to-part fittig is calculated on the nominal structure

fprintf('Calculating dynamic offset:\n');

% STEP 0 - import options
fem0.Options=fem.Options;

% STEP 1 - Assign contact pairs
fem0.Boundary.ContactPair=fem.Boundary.ContactPair;

nctpairs=length(fem0.Boundary.ContactPair);
nnode=size(fem0.xMesh.Node.Coordinate,1);

%%
% UPDATE CONTACT PAIRS
fprintf('=>    Contact Pairs:\n');
if nctpairs>0
    
    for i=1:nctpairs
       fem0.Sol.GapFitUp(i).Gap=ones(1,nnode)*fem0.Options.Max; % gap for each contact pair
       
       fem0.Sol.GapFitUp(i).max=fem0.Options.Min;
       fem0.Sol.GapFitUp(i).min=fem0.Options.Max;
       
    end
    
    % STEP 2 - Calculate initial gap distribution
    fem0=getGapsVariableFitUp(fem0);

    % STEP 3 - Update current structure
    fem.Sol.GapFitUp=fem0.Sol.GapFitUp;
    
else
    
    st=sprintf('=>     No contact pair has been detected!');
    warning(st)
                        
end


%%
% UPADTE DIMPLE PAIRS
fprintf('=>    Dimple Pairs:\n');
ndmpairs=length(fem.Boundary.DimplePair);

if ndmpairs>0
    
    % loop over dimple pairs
    for kct=1:ndmpairs

            % read id of master and slave part
            P0=fem.Boundary.DimplePair(kct).Pm;
            idmaster=fem.Boundary.DimplePair(kct).Master;
            mastflip=fem.Boundary.DimplePair(kct).MasterFlip;

            idslave=fem.Boundary.DimplePair(kct).Slave;

            dsearch=fem.Boundary.DimplePair(kct).SearchDist;
            matchd=fem.Boundary.DimplePair(kct).MatchDist; % matching distance

            offseth=fem.Boundary.DimplePair(kct).Offset; % offset value

            %--
            %etype=fem.Boundary.DimplePair(kct).Physic;
            %--

            % flip normal for master component
            if mastflip
               fem=flipNormalComponent(fem,idmaster);
            end

            % SLAVE DOMAIN:
            [Pps, ~, flags]=point2PointNormalProjection(fem, P0, idslave, dsearch);

            % MASTER DOMAIN:
            flagm=false;
            if flags
                [Ppm, Nm, flagm]=point2PointNormalProjection(fem, Pps, idmaster, dsearch);
            end
            
            % save data
            if flags && flagm

              % save gap
              gsign=dot( (Pps-Ppm), Nm);

              if gsign >= (offseth + matchd)
                  offgapmatch = offseth;
              else
                  offgapmatch = gsign;
              end

              % update all
              fprintf('=>      Dimple ID %g has been updated!\n', kct);
              fem.Boundary.DimplePair(kct).Offset=offgapmatch;

            else
                
              st=sprintf('=>      Dimple ID %g has not been updated!\n', kct);
              warning(st);  
              
            end

            % reset normal vectors for master component
            if mastflip
               fem=resetNormalComponent(fem, idmaster);
            end

    end

end



