function calValue = calDotProductMatrixVector(matrixvector, vector1, vector2, flag) 

% **********************************************************************************
% the function calculate various kind of dot products

%Inputs

% matrixvector - list of vectors in matrix form, row number represent each
% vector, three column represent the componenet of each vector.
% fisrt vector in the dot product (say v1)

% vector1 - it can be a vcetor or list of vectors in maytrix form. If it is
% a vector, it creates the repmat to produce same size of matrixvector.
% This vector is used to make subtraction from matrixvector (v)
% if nothing is to be substracted, make vector1 = [0 0 0]

% vector2 = it can be a vcetor or list of vectors in maytrix form. If it is
% a vector, it creates the repmat to produce same size of matrixvector.
% second vector in the dot product (sya(v2)
% 
% flag - to check whihc operation to perform
%   1  - just return list of vectors by subtracting vector1 from matrixvector
%        i.e. v1 - v
%   2  - calculate the dot product of the two vectors and then divide it by
%        mits norm . it is useful to calulate the angle between two vectors 
%        i.e. dot(v1,v2)/norm(v1)*norm(v2)
%   3 - make a projection of matrixvector on vector2 and return the
%       projected vector
%         i.e. v1 - (dot(v1,v2)/norm(v2))*v2


%outpu1

% for flag =1 - subtracted vector or list of vectors
% for flag =2 - dot product devided by nor of the vetors - useful to get
% the angle between the vectors
% for flag =3 - projcetion of vector v1 on v2
       
% ***********************************************************************************

% check whether vector1 is 1x3 form, it should not be 3x1 form. if it is
% 1x3 form, repmat required, otherise if it is mx3 form where m > 1 and m
% is equal to row number of matrixvector, then no opreation will be done
if size(vector1,1)==1
    vector1_repmat = repmat(vector1, size(matrixvector,1),1);
elseif size(vector1,1)==size(matrixvector,1)
   vector1_repmat =  vector1;
end

% check whether vector2 is 1x3 form. it should not be 3x1 form. if it is
% 1x3 form, repmat required, otherise if it is mx3 form where m > 1 and m
% is equal to row number of matrixvector, then no opreation will be done
if size(vector2,1)==1
    vector2_repmat = repmat(vector2, size(matrixvector,1),1);
elseif size(vector2,1)== size(matrixvector,1)
   vector2_repmat =  vector2;
end


v1 = matrixvector - vector1_repmat;

if flag ==1
    
    calValue = v1;
    
elseif flag==2
    
    v1_norm = sqrt(sum(abs(v1).^2,2));
    vector2_norm = sqrt(sum(abs(vector2_repmat).^2,2));

    v1_vector2_norm = vector2_norm.* v1_norm;

    val1 = (dot(v1', vector2_repmat'))';
    calValue = val1./v1_vector2_norm;
    
elseif flag ==3
    
    vector2_norm = sqrt(sum(abs(vector2_repmat).^2,2));
    val1 = (dot(v1', vector2_repmat'))';
    val2 = val1./vector2_norm;
    
    val3 = vector2_repmat.*repmat(val2, 1, 3);
    
    calValue = v1 - val3;
    
end


