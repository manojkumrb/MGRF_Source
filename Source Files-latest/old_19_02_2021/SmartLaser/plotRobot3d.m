% plot robot in 3D
function plotRobot3d(rob, Tfk, idlink)

% plot robot
for i=idlink
    
    % transform into local frame
    v=rob.Geom.Vertices{i};
    if i>1
        Ti=setTransformation(Tfk, i-1);
        v=apply4x4(v, Ti(1:3,1:3), Ti(1:3,4)');        
    end
    
    patch('faces',rob.Geom.Face{i},...
          'vertices',v,...
          'facecolor',rob.Geom.Color(i,:),...
          'edgecolor','none',...
          'FaceLighting','phong','tag','robot')
      
end

% plot beam

% TCP
t=setTransformation(Tfk, 7);
Ptcp=t(1:3,4);

% moving mirror
t=setTransformation(Tfk, 5);
Pmov=t(1:3,4);

line('xdata',[Ptcp(1) Pmov(1)],...
    'ydata',[Ptcp(2) Pmov(2)],...
    'zdata',[Ptcp(3) Pmov(3)],...
    'linestyle','-',...
    'color','r',...
    'marker','s',...
    'tag','robot')
    
