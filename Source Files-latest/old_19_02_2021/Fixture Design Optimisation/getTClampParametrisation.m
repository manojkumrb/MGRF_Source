% define (T) parametrisation 
function [fem, parameter]=getTClampParametrisation(fem0, fem, inData, parameter, searchDist)

% fem0: fem0 structure (nominal geometry)
% fem: fem structure (current geometry)

% inData: input data structure

% parameter.Clamp.T=[2 x no. of clamps] - in plane parameters
% It varies in [-inf, +inf] range
% first row: master
% second row: slave

% parameter.Clamp.V=[2 x no. of clamps] - in plane parameters
% It varies in [0, R] range % R: radius
% first row: master
% second row: slave

% parameter.Clamp.N=[2 x no. of variables] - out of plane parameters
% It varies in [-inf, +inf] range
% first row: master
% second row: slave

% parameter.GeomConstr: geometric constraints
   % .dc
   % .ds
   % .de
   
% searchDist: searching distance
  
parameter.Clamp.Status=[];

% define movable clamps
if isfield(inData.Clamp.Variable,'Ps')

  if ~isempty(inData.Clamp.Variable.Ps)

    np=length(inData.Clamp.Variable.Ps);

    % set initial status
    parameter.Clamp.Status=true(2, np); 

    for i=1:np

    fprintf('Processing variable clamp: %g\n', i);

        if inData.Clamp.Variable.Operation(i)~=4 % active

            % reference points
            Pst=inData.Clamp.Variable.Ps(i,:);
            Pen=inData.Clamp.Variable.Pe(i,:);

            % part id
            idmaster=inData.Clamp.Variable.Master(i);
            idslave=inData.Clamp.Variable.Slave(i);

            v=Pen-Pst;

            % MASTER

            t1=parameter.Clamp.T(1,i);
            n1=parameter.Clamp.N(1,i);

            % get paranetrised point
            Pm0=Pst + t1*v;

            fprintf('==>MASTER part\n');

            % get normal vector                
            [Nm, flagN]=point2Normal(fem0, Pm0, idmaster, searchDist);

            % get projected point
            [Pm, flagP]=pointNormal2PointProjection(fem0, Pm0, Nm, idmaster);

            if flagN==false && flagP==false         
                parameter.Clamp.Status(1,i)=false;

                st=sprintf('inputData.Variable.Clamp (master) - Point id: %g: Failed to project point on the nominal surface!', i);
                warning(st)
            else

                % add n1 parameter
                Pmp=Pm+n1*Nm;

                % check if constraints are satisfied
                flag=checkGeomConstraint(Pmp, inData, parameter.GeomConstr);

                % save the clamp as unilateral constraint
                if flag
                    fem=saveUnilateral(fem, Pmp, Nm, inData, i, idmaster, searchDist);
                else
                    parameter.Clamp.Status(1,i)=false;
                end

                % SLAVE     

                fprintf('==>SLAVE part\n');

                t2=parameter.Clamp.T(2,i);
                n2=parameter.Clamp.N(2,i);

                Ps0=Pst + t2*v;

                [Ps, flagS]=pointNormal2PointProjection(fem0, Ps0, Nm, idslave);

                if flagS==false
                    parameter.Clamp.Status(2,i)=false;

                    st=sprintf('inputData.Variable.Clamp (slave) - Point id: %g: Failed to project point on the nominal surface!', i);
                    warning(st)
                else

                    % add n2 parameter
                    Psp=Ps - n2*Nm;

                    % check if constraints are satisfied
                    flag=checkGeomConstraint(Psp, inData, parameter.GeomConstr);

                    % save the clamp as unilateral constraint
                    if flag
                        fem=saveUnilateral(fem, Psp, -Nm, inData, i, idslave, searchDist);
                    else
                        parameter.Clamp.Status(2,i)=false;
                    end

                end

            end

        end

    end
  end
end
%-------------------------------------------


% check geometric constraint
function flag=checkGeomConstraint(P, inData, geomConstr)
% P: testing point
% inData: input data structure
% geomConstr: geometric constraints
   % .dc
   % .ds
   % .de

flag=true;
   
% run over all stitches
ns=size(inData.Stitch.Ps,1);

% run over all stitches
for i=1:ns
    
    typest=inData.Stitch.Type(i);
    
    if typest==1 % linear
        
       Ps=inData.Stitch.Ps(i,:);
       Pe=inData.Stitch.Pe(i,:);
       
       flagi=checkLinear(P, Ps, Pe, geomConstr.dc, geomConstr.ds, geomConstr.de);
       
       if ~flagi
           flag=false;
           s=sprintf('    Geometric constraint not satisfied (overlapping on stitch %g)',i);
           warning(s);
           break % at least one constraint is not satisfied
       end
       
    elseif typest==2 % circular
        
       Ps=inData.Stitch.Ps(i,:);
       N=inData.Stitch.Ns(i,:);
       
       flagi=checkCircular(P, Ps, N, geomConstr.dc);
       
       if ~flagi
           flag=false;
           s=sprintf('    Geometric constraint not satisfied (overlapping on stitch %g)',i);
           warning(s);
           break % at least one constraint is not satisfied
       end
        
    end
        
end


function flag=checkLinear(P, Ps, Pe, dc, ds, de)
% P: testing point
% Ps/Pe: starting and ending point
% dc: cylinder diameter
% ds/de: offset wrt Ps and Pe
% flag: true/false (outside/inside the stitch area)

flag=false;

L=norm(Pe-Ps);

N=(Pe-Ps)/L;

Pss=Ps-ds*N;

% check condition no. 1 (projection on the stitch length)
t1=dot( N, (P-Pss) );

if t1<0 || abs(t1)>L+de
    flag=true;
else
    
    % check condition no. 1 (projection inside the cylinder)
    t2=norm(P - (Pss+t1*N));
    
    if t2>dc
       flag=true;
    end
    
end

function flag=checkCircular(P, Ps, N, dc)
% P: testing point
% Ps: starting point
% dc: cylinder diameter
% flag: true/false (outside/inside the stitch area)

% build ref. frame
R0l=vector2Rotation(N);

% transform point back to local frame
Pl=applyinv4x4(P, R0l, Ps);

t=sqrt( Pl(1)^2 + Pl(2)^2 );

if t>dc % P is not overlapping
    flag=true;
else
    flag=false;
end

% save constraint
function fem=saveUnilateral(fem, Pm, Nm,...
                            inData, idcmp, idpart, searchDist)

% fem: fem structure (current geometry)
% inData: input data structure
% idcmp: clamp id
% idpart: part id
% searchDist: searching distance


count=length(fem.Boundary.Constraint.Unilateral)+1;

fem.Boundary.Constraint.Unilateral(count).Pm=Pm; 
fem.Boundary.Constraint.Unilateral(count).Pmsize=[];
fem.Boundary.Constraint.Unilateral(count).SearchDist=searchDist; 
fem.Boundary.Constraint.Unilateral(count).Nm=Nm; 

if inData.Clamp.Variable.Size(idcmp)==0
   fem.Boundary.Constraint.Unilateral(count).Size=false; 
else
   fem.Boundary.Constraint.Unilateral(count).Size=true; 

   fem.Boundary.Constraint.Unilateral(count).SizeA=inData.Clamp.Variable.Size(idcmp); 
   fem.Boundary.Constraint.Unilateral(count).SizeB=inData.Clamp.Variable.Size(idcmp); 

   % get tangent vector (use null space)
   NS=null(Nm);

   Nt=NS(:,1); 
   fem.Boundary.Constraint.Unilateral(count).Nt=Nt';

   fem.Boundary.Constraint.Unilateral(count).Pmsize=[];
end

fem.Boundary.Constraint.Unilateral(count).Offset=0; 
fem.Boundary.Constraint.Unilateral(count).Domain=idpart;
fem.Boundary.Constraint.Unilateral(count).Constraint='free'; 

tag=getTag(inData.Clamp.Variable.Operation(idcmp));

fem.Boundary.Constraint.Unilateral(count).UserExp.Tag=tag;

fem.Boundary.Constraint.Unilateral(count).Frame='ref';


% run test
function tag=getTag(tagn)

if tagn==1
     tag='gun';
elseif tagn==2
     tag='keep';
elseif tagn==3
    tag='release';
end

