function nodeIME = initMeasueremntEnvelop(feature, feature_id, res_surface, res_envelop)

%**************************************************************************************************
%  the function will get the boundary conditions and identify the initial measurement envelope (IME)
%  for the feature type. It will also generate sample nodes which are inside IME

%Inputs:

% feature - feature structure
% feature_id - the feature for which the initial measurement envelope (IME) will be created
% res_surface - how mnay nodes will be created on reach surface, the number
% of nodes created on the surface would be res_surface*res_surface
% res_envelop - how many nodes will be created inside envelope. 

% Output
% nodeIME - sample points which are inside IME. 
% total number of node for regular hole= (res_envelop+1)*res_surface*res_surface
% for rectangular hole - modeIME is a cell 

%**************************************************************************************************

nodeIME = [];
i = feature_id;

%get all the information for the feature
P0 = feature(i).Vectors.Point;
N0 = feature(i).Vectors.Normal;
N0 = N0/norm(N0);

% get all the constraints
alpha_inner = min(feature(i).Constraints.Con1);
alpha_outer = max(feature(i).Constraints.Con1);
h_max = max(feature(i).Constraints.Con4);
h_min = min(feature(i).Constraints.Con4);

% get local coordinate
R=feature(i).R;

%*******************************************************************************
% this code is just for visualisation, not required for calculation 
% whether point is inside the envelope or not
[X, Y, Z] = renderConeObj(h_min, h_max, 2*alpha_inner, P0, N0, res_surface);
surf(X, Y, Z,'facecolor', 'r', 'edgecolor','b');
hold all
[X, Y, Z] = renderConeObj(h_min, h_max, 2*alpha_outer, P0, N0, res_surface);
surf(X, Y, Z,'facecolor', 'g', 'edgecolor','k');

view(3)
axis equal
%*******************************************************************************

alpha_net = alpha_outer - alpha_inner;
alpha_net_inc = alpha_net/res_envelop;

for j =1:res_envelop+1
    [X, Y, Z] = renderConeObj(h_min, h_max, 2*(alpha_inner+(j-1)*alpha_net_inc), P0, N0, res_surface);
    nodes = getNodes(X, Y, Z);
    nodeIME = [ nodeIME
                nodes];
end

if strcmp('Rectangular_Hole',feature(i).type) == 1 || strcmp('Square_Hole',feature(i).type) == 1
    
    diag_ang_1 = max(feature(i).Constraints.Con3);
    diag_ang_2 = min(feature(i).Constraints.Con3);
    
    diagonal = getDiagonal(feature, i);
    proj_v1 = calDotProductMatrixVector(nodeIME, P0, N0, 3);

    for k=1:4
     
        v2 = diagonal(k,:);
        dotval = calDotProductMatrixVector(proj_v1, [0 0 0], v2, 2);
        alpha_2 = acos(dotval);
        alpha_2_degree =radtodeg(alpha_2);
        loc = find(alpha_2_degree<diag_ang_1 & alpha_2_degree>0);
        nodes_1{k}=nodeIME(loc,:);
%         ppp = nodes_1{k};
%         scatter3(ppp(:,1), ppp(:,2), ppp(:,3));
        loc=[];
        
    end
    nodeIME = nodes_1;
end

% scatter3(nodeIME(:,1), nodeIME(:,2), nodeIME(:,3));
quiver3(P0(1,1), P0(1,2), P0(1,3), R(1,1), R(2,1), R(3,1), 1000);
quiver3(P0(1,1), P0(1,2), P0(1,3), R(1,2), R(2,2), R(3,2), 1000);
quiver3(P0(1,1), P0(1,2), P0(1,3), R(3,1), R(3,2), R(3,3), 1000);

plotFrame(R, P0, 1000, gca, '');




