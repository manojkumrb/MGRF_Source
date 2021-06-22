function K = getElementStifness(fem, eleId)
% Helper function for :func:`getAssembledKe`


% gauss point for 2x2 gauss rule for quad element
gausPointQuad = [ -0.57735026918962595,  -0.57735026918962595
	0.57735026918962595,  -0.57735026918962595
	0.57735026918962595,   0.57735026918962595
	-0.57735026918962595,   0.57735026918962595];

% gauss point for tria element
gausPointTria = [0.5 0.0
	0.5 0.5
	0.0 0.5];

i = eleId;

% nodes ids
elei=fem.xMesh.Element(i).Element;
nnodeele=length(elei);
etype=fem.xMesh.Element(i).Type;
nSize = nnodeele; %
K = zeros(nSize, nSize);

% trasformation matrices
T0lDoF=fem.xMesh.Element(i).Tmatrix.T0lDoF; % local coordinate for each element shell
Tucs0=fem.xMesh.Element(i).Tmatrix.T0ucs'; % user defined coordinate
T0lGeom=fem.xMesh.Element(i).Tmatrix.T0lGeom; %local coordinate associated with each element shell
P0lGeom=fem.xMesh.Element(i).Tmatrix.P0lGeom;
th = fem.Domain(1).Constant.Th;
Pi=fem.xMesh.Node.Coordinate(elei,:);
Pi=applyinv4x4(Pi, T0lGeom, P0lGeom);

for k=1:nnodeele
	
	
	if strcmp(etype,'quad')
		csi = gausPointQuad(k,1);
		eta = gausPointQuad(k,2);
		[N, dN]=getNdNquad4node(csi,eta); % get shape function and derivative of it
		[J, detJ]=getJacobian2D(dN,Pi); % get jecobian
		dN=J\dN;
				
		B=zeros(2,4); % [eps_x, eps_y, eps_xy]
		B(1,[1 2 3 4])=dN(1,:);
		B(2,[1 2 3 4])=dN(2,:);
				
		
		K = K + B'*B*th*detJ;
		
	elseif strcmp(etype,'tria')
		
		csi = gausPointTria(k,1);
		eta = gausPointTria(k,2);
		
		[N,dN]=getNdNtria3node(csi,eta); % defined into natural space
		[J, detJ]=getJacobian2D(dN, Pi);
		dN=J\dN;
		
		
		B=zeros(2,3); % [eps_x, eps_y, eps_xy]
		B(1,[1 2 3])=dN(1,:);
		B(2,[1 2 3])=dN(2,:);
		
		K = K + B'*B*th*detJ;
		
	end
	
end

