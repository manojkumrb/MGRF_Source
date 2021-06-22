% usage contourDomainPlot(fem,domainID,userData,colourBar,ax)
function contourDomainPlot(fem,domainID,userData,colourBar,varargin)
% A helper fucntion to create contourplot of a given mesh (domain) within 
% fem structure of VRM for data specified by the user. 
%
% Args:
%  fem  : fem structure from VRM after loading the mesh
%  domainID : Domain ID of the current mesh file in the fem structure
%  userdata: vector of values to visualise, length = nNode X 1
%  colourBar : 0 or 1, creates a colourBar when = 1
%  vargin : typically ax, axis to plot the figure, if empty a new axis is created
%
% Returns:
% The coutourplot of the mesh with user given values ar mesh nodes


noOfNodesDomain=length(fem.Domain(domainID).Node);
if length(userData)~= noOfNodesDomain
    display('user data doesnot match the number of nodes in domain');

    return
end

nodeIDs=fem.Domain(domainID).Node;
if isempty(varargin)
    figure;
    ax=gca;
else
    ax=varargin{1};
end
% title('Predicted Deviation','fontweight','bold','fontsize',13);
% for all domains together for contourplot
AllNodesWholeDomain=zeros(size(fem.xMesh.Node.Coordinate,1),1);
AllNodesWholeDomain(nodeIDs)=userData;

% hold all
fem.Post.Options.ParentAxes=ax;
fem.Sol.UserExp=AllNodesWholeDomain';
fem.Post.Contour.Domain=domainID;
fem.Post.Contour.ContourVariable='user';
fem.Post.Contour.Resolution=1;
fem.Post.Contour.MinRangeCrop =-inf;
fem.Post.Contour.MaxRangeCrop=inf;
contourPlot(fem)

if colourBar==1
    barHandle=colorbar(ax);
    barHandle.FontSize=12;
%     set(barHandle, 'Position', [.95 .11 .025 .75])
    set(get(barHandle,'Ylabel'),'string',...
        'surface normal deviation (mm)','fontweight','bold','fontsize',13)    
else
     barHandle=colorbar;
     delete(barHandle);
end
axes(ax)
axis equal
axis tight
ax.Clipping = 'off'; 
axis off
view([0 0]);
