% get euler angles from Rotation matrix
function [alfa, beta, gamma]=rot2Euler(R, m)

% R: 3x3 rotation matrix
% m: a string of 3 characters from the set {'x','y','z'} e.g. "zxz" or "zyx" or, equivalently, a vector whose elements are 1, 2 or 3

% [alfa, beta, gamma]: euler angles returned in degrees

%-------------------------------------
if nargin==1
    m='zyz';
end

if strcmp(m,'zyz')
    [alfa, beta, gamma]=callZYZ(R);
elseif strcmp(m,'zyx')
    [alfa, beta, gamma]=callZYX(R);
end

% perform: Rz*Ry*Rz
function [alfa, beta, gamma]=callZYZ(R)

a=R(1,3);
b=R(2,3);
alfa=atan2(b, a);

a=R(3,3);
b=cos(alfa)*R(1,3) + sin(alfa)*R(2,3);
beta=atan2(b, a);

a=-R(3,1);
b=R(3,2);
gamma=atan2(b, a);

alfa=alfa*180/pi;
beta=beta*180/pi;
gamma=gamma*180/pi;


% perform: Rz*Ry*Rx
function [alfa, beta, gamma]=callZYX(R)

if ( R(3,1) < +1)
    if ( R(3,1) > -1)
        beta = asin (-R(3,1) ) ;
        gamma = atan2 ( R(2,1) , R(1,1) ) ;
        alfa = atan2 ( R(3,2) , R(3,3) ) ;
    else % R(3,1) = ?1
        beta = +pi / 2;
        gamma = -atan2 (-R(2,3) , R(2,2) ) ;
        alfa = 0 ;
    end
else % R(3,1) = +1
    beta = -pi / 2;
    gamma = atan2 (-R(3,2) , R(2,2) ) ;
    alfa = 0 ;
end

alfa=alfa*180/pi;
beta=beta*180/pi;
gamma=gamma*180/pi;




                % e=zeros(3,1);
                % 
                % if ischar(m)
                %     m=lower(m)-'w'; % convert in numeric index (1 to 3)
                % end
                % 
                % u=m(1);
                % v=m(2);
                % w=m(3);
                % 
                % % first we rotate around w to null element (v,u) with respect to element (!vw,u) of rotation matrix
                % g=2*mod(u-v,3)-3;   % +1 if v follows u or -1 if u follows v
                % h=2*mod(v-w,3)-3;   % +1 if w follows v or -1 if v follows w
                % [s,c,~,e(3)]=atan2sc(h*R(v,u),R(6-v-w,u));
                % r2=R;
                % ix=1+mod(w+(0:1),3);
                % r2(ix,:)=[c s; -s c]*R(ix,:);
                % % next we rotate around v to null element (!uv,u) with repect to element (u,u) of rotation matrix
                % e(2)=atan2(-g*r2(6-u-v,u),r2(u,u));
                % % finally we rotate around u to null element (v,!uv) with respect to element (!uv,!uv) = element (v,v)
                % e(1)=atan2(-g*r2(v,6-u-v),r2(v,v));
                % if (u==w && e(2)<0) || (u~=w && abs(e(2))>pi/2)  % remove redundancy
                %      mk=u~=w;
                %      e(2)=(2*mk-1)*e(2);
                %      e=e-((2*(e>0)-1) .* [1; mk; 1])*pi;
                % end
                % 
                % alfa=e(1)*180/pi;
                % beta=e(2)*180/pi;
                % gamma=e(3)*180/pi;



            % %----------------------------
            % %ATAN2SC    sin and cosine of atan(y/x) [S,C,R,T]=(Y,X)
            % function [s,c,r,t]=atan2sc(y,x)
            % 
            % % Outputs:
            % %    s    sin(t) where tan(t) = y/x
            % %    C    cos(t) where tan(t) = y/x
            % %    r    sqrt(x^2 + y^2)
            % %    t    arctan of y/x
            % 
            %  t=NaN;
            % if y == 0
            %      t=(x<0);
            %      c=1-2*t;
            %      s=0;
            %      r=abs(x);
            %      t=t*pi;
            % elseif x == 0
            %      s=2*(y>=0)-1;
            %      c=0;
            %      r=abs(y);
            %      t=s*0.5*pi;
            % elseif (abs(y) > abs(x))
            %      q = x/y;
            %      u = sqrt(1+q^2)*(2*(y>=0)-1);
            %      s = 1/u;
            %      c = s*q;
            %      r = y*u;
            % else
            %      q = y/x;
            %      u = sqrt(1+q^2)*(2*(x>=0)-1);
            %      c = 1/u;
            %      s = c*q;
            %      r = x*u;
            % end
            % 
            % if nargout>3 && isnan(t)
            %      t=atan2(s,c);
            % end







