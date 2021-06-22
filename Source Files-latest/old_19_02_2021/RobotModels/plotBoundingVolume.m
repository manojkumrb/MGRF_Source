% plot bounding volume
function plotBoundingVolume(bb, ax, c, tag)

%----------------------------------------------
% Notice: rotation is calculated wrt to [0 0 0]
%----------------------------------------------

rx=bb.Range.X;
ry=bb.Range.Y;
rz=bb.Range.Z;

vb=[rx(2) ry(2) rz(2)
    rx(1) ry(2) rz(2)
    rx(1) ry(1) rz(2)
    rx(2) ry(1) rz(2)
    rx(2) ry(2) rz(1)
    rx(1) ry(2) rz(1)
    rx(1) ry(1) rz(1)
    rx(2) ry(1) rz(1)];

% back into global frame
vb=apply4x4(vb, bb.R(1:3,1:3), [0 0 0]);
face=[1 2 3 4
      5 6 7 8
      1 5 8 4
      2 6 7 3
      2 1 5 6
      3 7 8 4];

% plot geometry
patch('faces',face,'vertices',vb,...
      'facealpha',0.1,'edgecolor','k',...
      'facecolor',c,...
      'parent',ax, 'tag',tag);

