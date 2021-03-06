function R = quat2Rot( Qrotation )
% Converts quaternion to 3x3 rotation matrix

% IN: 
%     Qrotation - quaternion describing rotation
% OUT:
%     R - rotation matrix 
   
w = Qrotation(1);
x = Qrotation(2);
y = Qrotation(3);
z = Qrotation(4);

Rxx = 1 - 2*(y^2 + z^2);
Rxy = 2*(x*y - z*w);
Rxz = 2*(x*z + y*w);

Ryx = 2*(x*y + z*w);
Ryy = 1 - 2*(x^2 + z^2);
Ryz = 2*(y*z - x*w );

Rzx = 2*(x*z - y*w );
Rzy = 2*(y*z + x*w );
Rzz = 1 - 2 *(x^2 + y^2);

R = [Rxx,    Rxy,    Rxz;
     Ryx,    Ryy,    Ryz;
     Rzx,    Rzy,    Rzz];
 
% force rotation matrix
R=plr(R);
