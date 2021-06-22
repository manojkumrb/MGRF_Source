% interpolate robot motion for given kinematics (q)
function intData=interpolationRobotMotion(rob, q)

% rob: robot model
% q: coordinates: [nq, naxis]

% intData: (res, nseg)
    % .Point: xyz
    % .Tfk: forward kinematics
    % .Length: length

if strcmp(rob.Model,'ABB6620') % 7-axis robot
    intData=trajectoryABB6xxx(rob, q);
  
elseif strcmp(rob.Model,'ABB6700') % 6-axis robot
    intData=trajectoryABB6xxx(rob, q);
    
else
    
    
    
    %--------------
    
    
    
end


%--
function intData=trajectoryABB6xxx(rob, q)

% intData: (1, nseg)
    % .Point: xyz
    % .Tfk: forward kinematics
    % .Length: length
  
% idjoint=1:7 (robot joint); 8: TCP: 9/10/11/12: camera 1/camera 2/ camera 3/ camera centre
    
idjoint=rob.Kinematics.Interpolation.Trajectory.Joint;

mode=rob.Kinematics.Interpolation.Method;
res=rob.Kinematics.Interpolation.Resolution;

njoint=rob.Kinematics.Theta.JointNumber;

nq=size(q,1);
nseg=nq-1; % no. of segments interpolated

% check and save
if nseg==0
    rob.Kinematics.Theta.JointFree.Coordinate=q;
            
        Tfk=cell(1,res); % FK
        pk=zeros(res,3); % point
        for i=1:res
            rob.Kinematics.Theta.JointFree.Coordinate=q;
            
            % solve FK
            Tfk{i}=solveForwardKinematics(rob);
            
            % get point
            pk(i,:)=extractPoint(rob, Tfk{i}, idjoint);
        end
         
        % save
        intData.Point=pk;
        intData.Tfk=Tfk;
        intData.Length=0.0;
        
    return
end

% init output data
out=initOut;
intData(1,1)=out; intData(1, nseg)=out;
if strcmp(mode,'Joint')
    % q: [nq, njoint]
    
    for k=1:nseg
        
        qs=q(k,:); % start joint configuration
        qe=q(k+1,:); % end joint configuration
        
        qk=zeros(res, njoint);
        for i=1:njoint % loop over joints
            qk(:,i)=linspace(qs(i), qe(i), res);
        end

        % set robot
        Tfk=cell(1,res); % FK
        pk=zeros(res,3); % point
        L=0; % length
        for i=1:res
            rob.Kinematics.Theta.JointFree.Coordinate=qk(i,:);
            
            % solve FK
            Tfk{i}=solveForwardKinematics(rob);
            
            % get point
            pk(i,:)=extractPoint(rob, Tfk{i}, idjoint);
            
            if i>1
                L=L+norm(pk(i,:)-pk(i-1,:));
            end
                        
        end
        
        % save
        intData(k).Point=pk;
        intData(k).Tfk=Tfk;
        intData(k).Length=L;
                
    end
    
elseif strcmp(mode,'Cartesian')
    
    
    
        %--------------
    
        
        
end

%--
function p=extractPoint(rob, Tfk, idjoint)

if idjoint<=7
    T=setTransformation(Tfk, idjoint);
    p=T(1:3,4)';
elseif idjoint==8 % get TCP (tool)
    T=getTCPLocation(rob, Tfk);
    p=T(1:3,4)';
elseif idjoint==9 % camera 1
    T07=setTransformation(Tfk, 7); 
    
    p=rob.Parameter.Tool.Camera.P(1,:);
    p=apply4x4(p, T07(1:3,1:3), T07(1:3,4)');   
elseif idjoint==10 % camera 2
    T07=setTransformation(Tfk, 7); 
    
    p=rob.Parameter.Tool.Camera.P(2,:);
    p=apply4x4(p, T07(1:3,1:3), T07(1:3,4)');  
elseif idjoint==11 % camera 3
    T07=setTransformation(Tfk, 7); 
    
    p=rob.Parameter.Tool.Camera.P(3,:);
    p=apply4x4(p, T07(1:3,1:3), T07(1:3,4)');  
elseif idjoint==12 % camera centre
    T07=setTransformation(Tfk, 7); 
    
    p=rob.Parameter.Tool.Camera.Centre;
    p=apply4x4(p, T07(1:3,1:3), T07(1:3,4)');  
end


%--
function out=initOut()

out.Point=[0 0 0];
out.Tfk=cell(0,0);
out.Length=0;



    