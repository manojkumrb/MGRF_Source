% calculate joint angles for given position and orientation
function theta=pos2Joint(p, rob)

% p: point to be reached
% R: rotation matrix

% rob:
%   .P0: location of axis[2]
%   .L2: length of link[2]
%   .L3: length of link[3]
%   .L4: length of link[4]
%   .L5: offset between fixed mirror and moving mirror
%   .jointLim: joint  (first line: positive limit; second line: negative limit)

% initialise parameters
P0=rob.P0;
L2=rob.L2;
L3=rob.L3;
L4=rob.L4;
R=rob.R;

% define indices
sg=[-1 1];
s=fullfact([2 2 2 2]);

s1=sg(s(:,1));
s2=sg(s(:,2));
s3=sg(s(:,3));
s4=sg(s(:,4));

%%
nogo=true;
for i=1:size(s,1)

    % get theta[1]
    t(1) = getTheta1(p, P0, s1(i));
    
    % get theta[4]
    t(4) =  getTheta4(R, t(1), s4(i));
    
    % get theta[3]
    t(3) = getTheta3(p, P0, L2, L3, L4, t(1), s3(i));

    % get theta[2]
    t(2) = getTheta2(p, P0, L2, L3, L4, t(1), t(3), s2(i));

    count=0;
    for j=1:4
      if t(j)>=rob.jointLim(2,j) && t(j)<=rob.jointLim(1,j)
         count=count+1;
      end
    end
    
    if count==4
      nogo=false;
      break
    end

%    theta(i,:)=t;

end

if nogo
    error('Inverse Kinematics: Position cannot be reached')
else
    theta=t;
end

%------------------------------------------------------------
% get theta[1]
function theta = getTheta1(p, P0, s)

% b=R(2,3);
a=p(1);
b=p(2);
c=P0(2);

theta=atan2(a, b) + s*atan2( real(sqrt(a^2+b^2-c^2)), c);

% get theta[4]
function theta = getTheta4(R, theta1, s)

a=cos(theta1)*R(2,2)+sin(theta1)*R(1,2);
b=-(cos(theta1)*R(2,1)+sin(theta1)*R(1,1));

if s==1
    theta=atan2(-b, a);
elseif s==-1
    theta=atan2(b, -a);
end

% get theta[3]
function theta = getTheta3(p, P0, L2, L3, L4, theta1, s)

k1=(p(3)-P0(3))^2 + (-P0(1) + p(1)*cos(theta1) - p(2)*sin(theta1))^2;
k2=L2^2 + L3^2 + L4^2;
c=k1-k2;

a=2*L2*L4;
b=2*L2*L3;

theta=atan2(a,b) + s* atan2( real(sqrt(a^2+b^2-c^2)), c);

% get theta[2]
function theta = getTheta2(p, P0, L2, L3, L4, theta1, theta3, s)

a=-P0(1) + p(1)*cos(theta1) - p(2)*sin(theta1);
b=p(3)-P0(3);
c=L2 + L3*cos(theta3) + L4*sin(theta3);

theta=atan2(a,b) + s * atan2( real(sqrt( a^2+b^2-c^2 )),c);


