% check wether point is insise or outside the bounding volume
function [inblock, tag, flag]=inBoundingBox(bb, point, tag)

%----------------------------------------------
% Notice: rotation is calculated wrt to [0 0 0]
%----------------------------------------------

% rotation matrix
Rc = bb.R;  

% ranges
rx=bb.Range.X;
ry=bb.Range.Y;
rz=bb.Range.Z;

% init output
n=size(point,1);
inblock=false(1,n);

flag=false;

% back to local frame
point=applyinv4x4(point, Rc, [0 0 0]);

% loop over points
for i=1:n
    
    % point i-th
    if ~tag(i) % never visited
        x=point(i,1); y=point(i,2); z=point(i,3); 

        if (x>=rx(1) && x<=rx(2)) && (y>=ry(1) && y<=ry(2)) && (z>=rz(1) && z<=rz(2)) % check if point is inside the volume
            inblock(i)=true;
            tag(i)=true;

            flag=true;
        end
    end
end


