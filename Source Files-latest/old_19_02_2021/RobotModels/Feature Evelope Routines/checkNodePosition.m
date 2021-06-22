function flag = checkNodePosition(feature, feature_id, Pi)

%********************************************************************************************************
%  the function will get the boundary conditions and check whether a given poin is inside the IME or not

%Inputs:

% feature - feature structure
% feature_name - the feature type for which the initial measurement envelope (IME) will be created
% Pi - Point location. It would be checked whether Pi is within the IME

% Output
% flag - 1 if Pi is inside IME; 0 otherwise

%*********************************************************************************************************

flag1 = 0;
flag2 = 0;
flag = 0;
flag3 = 0;

i = feature_id;
       
P0 = feature(i).Vectors.Point;
N0 = feature(i).Vectors.Normal;
N0 = N0/norm(N0);

alpha_inner = min(feature(i).Constraints.Con1);
alpha_outer = max(feature(i).Constraints.Con1);
h_max = max(feature(i).Constraints.Con4);
h_min = min(feature(i).Constraints.Con4);

t=dot((Pi-P0), N0);
Pp=P0+t*N0;
d_h=norm(Pp-P0);
d_r= norm(Pp-Pi);

if d_h > h_min && d_h < h_max
    flag1 = 1;
end 

alpha_Pi = acos(dot((Pi-P0), N0)/(norm(Pi-P0)*norm(N0)));
if alpha_Pi > degtorad(alpha_inner) && alpha_Pi < degtorad(alpha_outer)
    flag2 = 1;
end

if strcmp('Round_Hole',feature(i).type) == 1 || strcmp('Hexagonal_Hole',feature(i).type) == 1
    if flag1 ==1 && flag2 == 1
        flag = 1;
    else
        flag = 0;
    end  
end

if strcmp('Rectangular_Hole',feature(i).type) == 1 || strcmp('Square_Hole',feature(i).type) == 1

    diagonal = getDiagonal(feature, i);
    proj_v1 = calDotProductMatrixVector(Pi, P0, N0, 3);
    
    for k=1:size(diagonal,1)
        v2 = diagonal(k,:);
        dotval = calDotProductMatrixVector(proj_v1, [0 0 0], v2, 2);
        alpha_2(k) = acos(dotval);
        alpha_2_degree =radtodeg(alpha_2);
    end
    
    diag_ang_1 = max(feature(i).Constraints.Con3);
    
    loc = find(alpha_2_degree<diag_ang_1 & alpha_2_degree>0);
    if loc > 0
        flag3 = 1;
    end
    
    if flag1 ==1 && flag2 == 1 && flag3 ==1
        flag = 1;
    else
        flag = 0;
    end
    
    
end
