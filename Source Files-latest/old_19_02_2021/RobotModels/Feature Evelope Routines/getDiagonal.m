function diagonal = getDiagonal(feature, feature_id)

i= feature_id;

if strcmp('Rectangular_Hole',feature(i).type) == 1 || strcmp('Square_Hole',feature(i).type) == 1
    
    R=feature(i).R;
    v_diag1 = R(:,1)'+R(:,2)';
    v_diag2 = R(:,1)'-R(:,2)';

    diagonal = [v_diag1
                -v_diag1
                v_diag2
                -v_diag2];
else
    diagonal = [];
end