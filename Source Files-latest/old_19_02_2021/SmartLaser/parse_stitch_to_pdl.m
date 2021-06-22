function data=parse_stitch_to_pdl(option, Trobot, theta, parameter, typeweld, fem)

% Trobot: robot model
% parameter: parameter id (it corresponds to the tech. table (power and speed) on the robot controller)
% typeweld:(1/2) => linear/circular
% fem product

% data.
    % Option.
        % "cartesian": program cartesian location of the robot (Trobot is required)
        % "joint": progra, joint of the robot (theta is required)
    % Stitch(id).
        % Type (1/2) => linear/circular
        % Arm{2}.Position (1x3/4)
        % Arm{2}.Orientation (1x3)
        % Arm{1}: position (1x3)
        % Parameter: parameter id (it corresponds to the tech. table (power and speed) on the robot controller)
        
        
data.Option=option;        
np=length(Trobot);

data.Stitch=[];
for i=1:np
    
    data.Stitch(i).Type=typeweld(i);
    data.Stitch(i).Parameter=parameter(i);
    
    % ARM[2]
    t=setTransformation(Trobot{i}{1}, 4);
  
    [alfa, beta, gamma]=rot2Euler(t(1:3,1:3));
    data.Stitch(i).Arm(2).Orientation=[alfa, beta, gamma];
        
    if strcmp(option,'cartesian')
         data.Stitch(i).Arm(2).Position=t(1:3,4)';
    elseif strcmp(option,'joint')
         data.Stitch(i).Arm(2).Position=theta(i,:);
    end
    
    
    % ARM[1]
    data.Stitch(i).Arm(1).Orientation=[alfa, beta, gamma];
    if typeweld(i)==1 % linear
        t=setTransformation(Trobot{i}{1}, 7);
        ps=t(1:3,4)';

        t=setTransformation(Trobot{i}{2}, 7);
        pe=t(1:3,4)';
        
        data.Stitch(i).Arm(1).Position=[ps; pe];
        
    elseif typeweld(i)==2 % circular 
        t=setTransformation(Trobot{i}{1}, 7);
        P0=t(1:3,4)';
        
        Pcirc=get3pointsCircular(P0, fem);
        
        data.Stitch(i).Arm(1).Position=Pcirc;
    end
        
end     
        
%--
function Pcirc=get3pointsCircular(P0, fem)

diam=8; % mm

% get normal vector
searchdist=10; % mm

[N0, ~]=point2Normal(fem, P0, 1, searchdist);

% build local ref. frame
NS=null(N0);

Nx=NS(:,1);
Ny=cross(N0,Nx);

Rc=[Nx,Ny',N0'];

% define 3 points into local frame
Pcirc=[diam/2 0 0
       0      diam/2 0
       -diam/2 0 0
       0      -diam/2 0];
   
% trasnform into global ref. frame
Pcirc=apply4x4(Pcirc, Rc, P0);

