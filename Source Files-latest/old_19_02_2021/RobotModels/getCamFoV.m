function [vfov, ffof]=getCamFoV(rob, R0c, P0c)

%
Lmin=rob.Tool.Camera.Intrinsic.Parameter.WorkingDistance(1);
Lmax=rob.Tool.Camera.Intrinsic.Parameter.WorkingDistance(2);

%
scw=Lmin / rob.Tool.Camera.Intrinsic.Parameter.Focal(1);
sch=Lmin / rob.Tool.Camera.Intrinsic.Parameter.Focal(2);

x0m=rob.Tool.Camera.Intrinsic.Parameter.W/2*scw; % principal point x
y0m=rob.Tool.Camera.Intrinsic.Parameter.H/2*sch; % principal point y

%
scw=Lmax / rob.Tool.Camera.Intrinsic.Parameter.Focal(1);
sch=Lmax / rob.Tool.Camera.Intrinsic.Parameter.Focal(2);

x0M=rob.Tool.Camera.Intrinsic.Parameter.W/2*scw; % principal point x
y0M=rob.Tool.Camera.Intrinsic.Parameter.H/2*sch; % principal point y

% vertex
vfov=[0 0 0
      x0m -y0m Lmin
      x0m y0m Lmin
      -x0m y0m Lmin
      -x0m -y0m Lmin
      x0M -y0M Lmax
      x0M y0M Lmax
      -x0M y0M Lmax
      -x0M -y0M Lmax];
vfov=apply4x4(vfov, R0c, P0c); 

% trias
ffofall =  [1 2 5
            1 5 4
            1 4 3
            1 3 2
            2 6 9
            2 5 9
            5 4 8
            5 9 8
            4 3 7
            4 8 7
            2 3 7
            2 6 7
            6 7 8
            6 9 8
            2 3 5
            3 4 5];
    
ffof{1,1}=ffofall(1:4,:); % top FoV
ffof{2,1}=ffofall(5:end-4,:); % truncted FoV
ffof{3,1}=ffofall(end-3:end-2,:); % cap bottom
ffof{4,1}=ffofall(end-1:end,:); % cap top

