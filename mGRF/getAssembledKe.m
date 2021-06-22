function Ke=getAssembledKe(fem,domainID)
% A function to assemble the stiffness matrix of a given mesh
% element=element strucutre
% 
% Args:
%  fem  : fem structure from VRM after loading the mesh
%  domainID : Domain ID of the current mesh file in the fem structure
%
% Returns:
%  Ke the assemble stiffness matrix


nnode		=length(fem.Domain(domainID).Node);
eleIdDomain	=fem.Domain(domainID).Element;
nelement	=length(eleIdDomain);
eleDomain	=fem.xMesh.Element(eleIdDomain);

X=zeros(nelement*16,1);
irow=zeros(nelement*16,1);
jcol=zeros(nelement*16,1);

count =1;

for i=1:nelement
	Kei = getElementStifness(fem, eleIdDomain(i));
	
	etype	=eleDomain(i).Type;
	element = eleDomain(i).Element;
	
	if strcmp(etype,'tria')
		for j=1:3
			for z=1:3
				X(count)=Kei(j,z);
				
				irow(count)=element(j);
				jcol(count)=element(z);
				
				count=count+1;
			end
		end
		
	elseif strcmp(etype,'quad')
		for j=1:4
			for z=1:4
				X(count)=Kei(j,z);
				
				irow(count)=element(j);
				jcol(count)=element(z);
				
				count=count+1;
			end
		end
	end
	
	
	
end


irow(count:end)	=[];
jcol(count:end)	=[];
X(count:end)	=[];
Ke=sparse(irow, jcol, X, nnode, nnode);


