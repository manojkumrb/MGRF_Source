% estimate bounding volume using best enveloped rectangle
function bb=getBoundingVolume(point, N, S)

% point: xyz coordinates
% N: viewpoint direction
% S=[W0, L0, D0]: width, length and depth of the box 

% bb.
   % .Range.X/Y/Z
   % .R: rotation matrix
   % .Pm: centre of point cloud
   
%----------------------------------------------
% Notice: rotation is calculated wrt to [0 0 0]
%----------------------------------------------

% build local frame (Z parallel to N)
R0n=vector2Rotation(N);

% transform back
pointn=applyinv4x4(point, R0n, [0 0 0]);

% get local frame (best enveloped rectangle)
[rectx,recty,~,~] = minboundrect(pointn(:,1),pointn(:,2),'a');

if size(rectx,2)>1
    rectx=rectx';
    recty=recty';
end

Pr=[rectx recty];

x=(Pr(2,:)-Pr(1,:))/norm((Pr(2,:)-Pr(1,:)));
y=(Pr(3,:)-Pr(2,:))/norm((Pr(3,:)-Pr(2,:)));

a(1)=acos(dot([1 0 0], [x 0]));
a(2)=acos(dot([1 0 0], [y 0]));

if a(1)<=a(2)
  x=[x 0];
  y=cross([0 0 1], x);
  Rnb=eye(3,3); Rnb(1:3,1:2)=[x' y']; % rotation around local 
else
  x=[y 0];
  y=cross([0 0 1], [y 0]);
  Rnb=eye(3,3); Rnb(1:3,1:2)=[x' y']; % rotation around local 
end


% Rnb=eye(3,3); Rnb(1:2,1:2)=[x' y']; % rotation around local Z
% 
% if det(Rnb)<0
%     Rnb(:,2)=-Rnb(:,2);
% end

% back into to local frame
pointb=applyinv4x4(pointn, Rnb, [0 0 0]);

maxx=max(pointb(:,1));
minx=min(pointb(:,1));

maxy=max(pointb(:,2));
miny=min(pointb(:,2));

maxz=max(pointb(:,3));
minz=min(pointb(:,3));

% X
mx=mean([minx, maxx]);
if abs(minx-maxx)<S(1)
    bb.Range.X=[mx-S(1)/2 mx+S(1)/2];
else
    bb.Range.X=[minx, maxx];
end

% Y
my=mean([miny, maxy]);
if abs(miny-maxy)<S(2)
    bb.Range.Y=[my-S(2)/2 my+S(2)/2];
else
    bb.Range.Y=[miny, maxy];
end

% Z
mz=mean([minz, maxz]);
if abs(minz-maxz)<S(3)
    bb.Range.Z=[mz-S(3)/2 mz+S(3)/2];
else
    bb.Range.Z=[minz, maxz];
end

%--
bb.R=R0n*Rnb;

bb.Pm=apply4x4([mx, my, mz], R0n*Rnb, [0 0 0]);

