function [warpImage, fimage, Mcb]=camera2warpedImage(impattern,...
                                                    boardSize,...
                                                    squareSize,...
                                                    Kcam,...
                                                    Rcam, tcam)
%- INPUT:
%- impattern: image to be warped
%- Kcam: internal camera parameters matrix
%- Rcam/tcam: camera rotation and translation vectors

%- OUTPUT:
%- warpImage: warped image

% calculate PPM
PPM=Kcam*[Rcam,tcam];
    
% get image point and world points
[fimage, Mcb]=getImagePoint(PPM, boardSize, squareSize);

%--
id=[1 boardSize(1)-1 (boardSize(1)-1)*(boardSize(2)-1) (boardSize(1)-1)*(boardSize(2)-1)-(boardSize(1)-2)];
Mworld=Mcb(id,:);

% transform points, accordingly into image frame (pixels)
mimage=PPM*[Mworld';zeros(1,size(Mworld,1)); ones(1,size(Mworld,1))];
mimage(1,:)=mimage(1,:)./mimage(3,:);
mimage(2,:)=mimage(2,:)./mimage(3,:);
mimage=mimage(1:2,:)';
    
% set M image data
imsizerow=size(impattern,1);
imsizecol=size(impattern,2);
Mimage=[1 1
        1 imsizerow
        imsizecol imsizerow
        imsizecol 1];
    
% calculate projection form (homography)...
H=maketform('projective',...
            Mimage ,...
            mimage); %#ok<*MTFP2>
     
% ... finally trasform image according to "T" (bicubic interpolation + homography transformation)... 
imsizec=Kcam(1,3)*2;
imsizer=Kcam(2,3)*2;
warpImage=imtransform(impattern, H, 'bilinear',...
                     'size',[imsizer imsizec],...
                     'xdata',[1 imsizec],...
                     'ydata',[1 imsizer],...
                     'FillValues',100);  % filling value 
 

%--
function [mimage, Mworld]=getImagePoint(PPM, boardSize, squareSize)

Mworld = generateCheckerboardPoints(boardSize, squareSize);

% transform points, accordingly into image frame (pixels)
mimage=PPM*[Mworld';zeros(1,size(Mworld,1)); ones(1,size(Mworld,1))];
mimage(1,:)=mimage(1,:)./mimage(3,:);
mimage(2,:)=mimage(2,:)./mimage(3,:);
mimage=mimage(1:2,:)';           
    

