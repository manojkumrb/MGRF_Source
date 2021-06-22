function Pout=fix2MoveFrame(P, R, rob)

% define offset along Y:
off_mirror=rob.L5; % mm

% the origin of the moving mirror is
Pmov=[off_mirror 0 0];
Pout=apply4x4(Pmov, R, P);
