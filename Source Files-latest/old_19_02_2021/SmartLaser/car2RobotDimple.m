function [Rrc, prc]=car2RobotDimple()

% Rrc/prc: rotation and position vector

P0=[3063.10 -3477.47 -117.43]; 
P1=[3017.51 -2461.45 -112.16];
P2=[1922.43 -3528.66 -117.42];

[Rrc, prc]=buildFrame3Pt(P0, P1, P2);


















