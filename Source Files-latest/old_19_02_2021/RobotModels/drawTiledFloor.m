% draw a tiled floor in the current axes
function drawTiledFloor(rob, tag)
   
%--
if nargin==1
    tag='robotfloor';
end

xmin = rob.Options.AxisLim.X(1);
xmax = rob.Options.AxisLim.X(2);
ymin = rob.Options.AxisLim.Y(1);
ymax = rob.Options.AxisLim.Y(2);

% create a colored tiled floor
xt = xmin:rob.Options.Floor.Tile.Size(1):xmax;
yt = ymin:rob.Options.Floor.Tile.Size(2):ymax;
Z = rob.Options.Floor.Level*ones( numel(yt), numel(xt));
C = zeros(size(Z));

[r,c] = ind2sub(size(C), 1:numel(C));
C = bitand(r+c,1);
C = reshape(C, size(Z));

ct1=rob.Options.Floor.Tile.Color(1,:); % color tile 1
ct2=rob.Options.Floor.Tile.Color(2,:); % color tile 2

C = cat(3, ct1(1)*C + ct2(1)*(1-C), ...
           ct1(2)*C + ct2(2)*(1-C), ...
           ct1(3)*C + ct2(3)*(1-C));
[X,Y] = meshgrid(xt, yt);

surface(X, Y, Z, C, ...
    'FaceColor','texturemap',...
    'EdgeColor','none',...
    'CDataMapping','direct',...
    'parent',rob.Options.ParentAxes,...
    'tag',tag);

