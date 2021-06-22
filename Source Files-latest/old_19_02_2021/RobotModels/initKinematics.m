% set initial kinematics settings
function Kinematics=initKinematics(robmodel, nq, qhome)

% robmodel: robot model
% nq: no. of joints
% qhome: joint coordinate of home position

% Kinematics
    % Goal.
        % .P: point to be reached (1x3)
        % .R: Rotation matrix to be reached (3x3) 
        
    % Theta
        % .JointNumber= numbers of joints
        % .Home= home joint coordinate
        % .Joint
            % .ID = joint IDs ("0" if not active)
            % .Coordinate = coordinate
        
    % .Solver
        % .Eps: solver accuracy (1x1)
        % .EpsIK: accuracy of "inverse kinematic" solution (1x1)
        % .MaxIter: solver iterations (1x1)
    
    %. Interpolation
        % .Method: joint/cartesian
        % .Resolution: no. of steps

%--  
Kinematics.Goal.P=[0 0 0];
Kinematics.Goal.R=eye(3,3);
    
%--
Kinematics.Theta.Home=qhome;
Kinematics.Theta.JointNumber=nq;

if strcmp(robmodel, 'ABB6620')
    Kinematics.Theta.Joint.ID=1:nq; % all joints are active
    Kinematics.Theta.Joint.Coordinate=qhome; 
elseif strcmp(robmodel, 'ABB6700-200')
    Kinematics.Theta.Joint.ID=[0 2:nq]; % all joints are active
    Kinematics.Theta.Joint.Coordinate=qhome; 
elseif strcmp(robmodel, 'ABB6700-235')
    Kinematics.Theta.Joint.ID=[0 2:nq]; % all joints are active
    Kinematics.Theta.Joint.Coordinate=qhome; 
else
    
    
    
    % add other robot models
    
    
    
end

%--
Kinematics.Solver.Eps=1e-12;
Kinematics.Solver.EpsIK=1e-2;
Kinematics.Solver.MaxIter=1000;

%--
Kinematics.Interpolation.Method='Joint'; % "Joint"; "Cartesian"
Kinematics.Interpolation.Resolution=20;
Kinematics.Interpolation.Trajectory.Joint=6; % 1:7; 8: tool




    
