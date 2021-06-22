% return true if "point" is inside the volume "bb"
function [inblock, flag]=inBlock3D(bb, point)
   
% init output
n=size(point,1);
inblock=false(1,n);
flag=false;

%--
Rc = bb.R;
Pc = bb.Pm;

% sizes of the bb
rc(1)=abs(bb.Range.X(1)-bb.Range.X(2));
rc(2)=abs(bb.Range.Y(1)-bb.Range.Y(2));
rc(3)=abs(bb.Range.Z(1)-bb.Range.Z(2));

% back to local frame
point=applyinv4x4(point, Rc, Pc);
    
% loop over points
for i=1:n
    
    % point i-th
    x=point(i,1); y=point(i,2); z=point(i,3); 
    
    if (x>=-rc(1)/2 && x<=rc(1)/2) && (y>=-rc(2)/2 && y<=rc(2)/2) && (z>=-rc(3)/2 && z<=rc(3)/2) % check if point is inside the volume
        inblock(i)=true;
        
        flag=true;
    end

end

