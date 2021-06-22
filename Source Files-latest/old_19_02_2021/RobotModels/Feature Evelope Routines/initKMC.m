% init Key meaurement charactetics
function KMC = initKMC(varargin)

if nargin==3
    t=varargin{1};
    theta=varargin{2};
    phi=varargin{3};
else
    t=[600 800];
    theta=[15 45];
    phi=[0 360];
end

% TYPE
KMC(1).Type='Round_Hole'; % {Round_Hole, Rectangular_Hole, Square_Hole, Hexagonal_Hole,...}

% VECTOR
KMC(1).Vectors.Point=zeros(1,3);
KMC(1).Vectors.Normal=[0 0 1];
KMC(1).Vectors.Length=[1 0 0]; % tangent 1 axis (along length of the feature)
KMC(1).Vectors.Width=[0 1 0]; % tangent 2 axis (along width of the feature)

% SCALAR
KMC(1).Scalars.Diameter=13; % mm
KMC(1).Scalars.Length=10; % mm
KMC(1).Scalars.Width=10; % mm
KMC(1).Scalars.Height=20; % mm

% CONSTRAINT (parameters)
KMC(1).Constraints.Distance=t; % mm (t)
KMC(1).Constraints.Angle.Normal=theta; % degrees (theta)
KMC(1).Constraints.Angle.Tangent=phi; % degrees (phi)

% FRAME
KMC(1).R=eye(3,3); % rotation matrix

% STATUS
KMC(1).Status=true;

% GRAPHICS
KMC(1).Graphic.Color=[0.5 0.5 0.5]; 
KMC(1).Graphic.EdgeColor='none';
KMC(1).Graphic.FaceAlpha=0.5;
KMC(1).Graphic.Show=true;
KMC(1).Graphic.ShowEdge=false;
KMC(1).Graphic.ShowFrame=true;
KMC(1).Graphic.LengthAxis=100;
