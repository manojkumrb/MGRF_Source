% plot checkborad
function patchCheckBoard(checkbsize, papersize, Twcb, ax, tag)

% checkbsize: checkbsize size
% papersize: paper size
% Twcb: trasformation matrix

if nargin==2
    Twcb=eye(4,4);
    ax=gca;
    tag='checkboard';
end

if nargin==3
    ax=gca;
    tag='checkboard';
end

if nargin==4
    tag='checkboard';
end


% define points into c-borad ref. frame
vcb=[papersize(1)/2 papersize(2)/2 0
    papersize(1)/2 -papersize(2)/2 0
    -papersize(1)/2 -papersize(2)/2 0
    -papersize(1)/2 papersize(2)/2 0];

xmin = min(vcb(:,1));
xmax = max(vcb(:,1));
ymin = min(vcb(:,2));
ymax = max(vcb(:,2));

% create a colored tiled floor
xt = xmin:checkbsize:xmax;
yt = ymin:checkbsize:ymax;
[X,Y] = meshgrid(xt, yt);
Z = zeros(size(X));
C = zeros(size(X));

[r,c] = ind2sub(size(C), 1:numel(C));
C = bitand(r+c,1);
C = reshape(C, size(Z));

ct1=[1 1 1]; % white
ct2=[0 0 0]; % black

C = cat(3, ct1(1)*C + ct2(1)*(1-C), ...
           ct1(2)*C + ct2(2)*(1-C), ...
           ct1(3)*C + ct2(3)*(1-C));

% transform it into world frame
P=[X(:),Y(:),Z(:)];

P=apply4x4(P, Twcb(1:3,1:3), Twcb(1:3,4)');

%... then plot 
res=size(X);
X=reshape(P(:,1),res(1),res(2));
Y=reshape(P(:,2),res(1),res(2));
Z=reshape(P(:,3),res(1),res(2));

surface(X, Y, Z, C, ...
    'FaceColor','texturemap',...
    'EdgeColor','none',...
    'CDataMapping','direct',...
    'parent',ax,...
    'tag',tag);
