function nodes = getSecondTilePostion(nodeIME, feature, feature_id, tile1)

i =feature_id;
       
% get inputs
P0 = feature(i).Vectors.Point;
N0 = feature(i).Vectors.Normal;
N0 = N0/norm(N0);

alpha_inner = min(feature(i).Constraints.Con1);
alpha_outer = max(feature(i).Constraints.Con1);
h_max = max(feature(i).Constraints.Con4);
h_min = min(feature(i).Constraints.Con4);
angle_max = max(feature(i).Constraints.Con3);
angle_min = min(feature(i).Constraints.Con3);

if strcmp('Round_Hole',feature(i).type) == 1 || strcmp('Hexagonal_Hole',feature(i).type) == 1
    
%   get projection of v_tile_1 and v-other vectors on the plane of hole
    proj_v_tile_1 = calDotProductMatrixVector(tile1, P0, N0, 3);
    proj_v_other = calDotProductMatrixVector(nodeIME, P0, N0, 3);
   
    dotval = calDotProductMatrixVector(proj_v_other, [0 0 0], proj_v_tile_1, 2);
    alpha_2 = acos(dotval);
    alpha_2_degree =radtodeg(alpha_2);

    location = find(alpha_2_degree>angle_min & alpha_2_degree<angle_max);

    nodes = nodeIME(location,:);
end

if strcmp('Rectangular_Hole',feature(i).type) == 1 || strcmp('Square_Hole',feature(i).type) == 1
    
    diagonal = getDiagonal(feature, i);
    proj_v1 = calDotProductMatrixVector(tile1, P0, N0, 3);
    
    for k=1:size(diagonal,1)
        v2 = diagonal(k,:);
        dotval = calDotProductMatrixVector(proj_v1, [0 0 0], v2, 2);
        alpha_2(k) = acos(dotval);
        alpha_2_degree =radtodeg(alpha_2);
    end
    
    diag_ang_1 = max(feature(i).Constraints.Con3);
    
    loc = find(alpha_2_degree<diag_ang_1 & alpha_2_degree>0);  
    
    if loc ==1
        loc1 = 2;
    elseif loc ==2
        loc1 =1;
    elseif loc ==3
        loc1 =4;
    elseif loc ==4
        loc1 =3;
    end
    
    nodes = nodeIME{1, loc1};
    
end

