function [Rrc, prc]=car2RobotDimpleRealHinge()

% Rrc/prc: rotation and position vector

P0=[4731.65 -285.86 1931.41]; 
P1=[4164.60 -305.08 2004.42];
P2=[4688.38 -274.60 1598.31];

[Rrc, prc]=buildFrame3Pt(P0, P1, P2);














