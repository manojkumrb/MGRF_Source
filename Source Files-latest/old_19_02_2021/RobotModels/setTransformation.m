% set trasformation ul to "idaxis"
function Tout=setTransformation(T, idaxis)

Tout=eye(4,4);
for i=1:idaxis
    Tout=Tout * T{i};
end