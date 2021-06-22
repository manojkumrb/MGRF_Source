function [Rrc, prc]=car2Robot()

% Rrc/prc: rotation and position vector

P0=[52.58 3071.26 284.64]; 
P1=[105.79 2884.30 291.47 ];
P2=[201.04 3109.37 171.22 ];

[Rrc, prc]=buildFrame3Pt(P0, P1, P2);








