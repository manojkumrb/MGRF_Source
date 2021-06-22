function Pfix=move2fixFrame(Pmov, Rmov, rob)

% define offset along Y:
off_mirror=rob.L5; % mm

% the origin of the fixed mirror is
Pfix=[-off_mirror 0 0];
Pfix=apply4x4(Pfix, Rmov, Pmov);

