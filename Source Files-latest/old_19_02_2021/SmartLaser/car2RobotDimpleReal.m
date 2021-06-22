function [Rrc, prc]=car2RobotDimpleReal()

% Rrc/prc: rotation and position vector

P0=[3057.54 -3480.61  -110.45]; 
P1=[3016.08  -2464.41 -108.37];
P2=[1916.68 -3527.17 -108.32];

[Rrc, prc]=buildFrame3Pt(P0, P1, P2);











