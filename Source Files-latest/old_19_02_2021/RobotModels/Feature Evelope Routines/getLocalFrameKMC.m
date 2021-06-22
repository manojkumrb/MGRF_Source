function KMC = getLocalFrameKMC(KMC)

nkmc = length(KMC);
for i=1:nkmc
    
    if strcmp('Round_Hole',KMC(i).Type) == 1 || strcmp('Hexagonal_Hole',KMC(i).Type) == 1
        
       N0 = KMC(i).Vectors.Normal;
       Rkmc=vector2Rotation(N0);

    elseif strcmp('Rectangular_Hole',KMC(i).Type) == 1 || strcmp('Square_Hole',KMC(i).Type) == 1
        
        N0 = KMC(i).Vectors.Normal;
        Nx = KMC(i).Vectors.Length;
        Ny = KMC(i).Vectors.Width;
        N0 = N0/norm(N0);
        Nx = Nx/norm(Nx);
        Ny = Ny/norm(Ny);
        
        Rkmc=[Nx',Ny',N0'];
        
    end
    
        KMC(i).R = Rkmc;
    
end

