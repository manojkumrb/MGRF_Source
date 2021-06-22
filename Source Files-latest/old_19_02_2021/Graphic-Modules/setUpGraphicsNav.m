% axes pre-processing
function setUpGraphicsNav(source, event, fig, frame3d, haxes3d, visopt, redfc, mode)

%---
obj=get(haxes3d,'Children'); % total obj on axes
nobj=length(obj);

num_pth=0;
hlight=[];
for i=1:nobj
    if strcmp(get(obj(i),'Type'),'patch') 
        num_pth=num_pth+1;
    elseif strcmp(get(obj(i),'Type'),'light')
        hlight=obj(i);
    end
end

c=1;
flag=false;
type_pth=zeros(1,num_pth);
for i=1:nobj
    if strcmp(get(obj(i),'Type'),'patch') 
        flag=true;
        type_pth(c)=i;
        c=c+1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~flag  % there is NO PATCH

    if strcmp(mode,'rotate')
        rotate3d on;
    elseif strcmp(mode,'pan')
        pan('on');
    elseif strcmp(mode,'zoom')
        zoom('on');
    end   
    
    if ~isempty(hlight)
        camlight(hlight,'headlight')
    end

else     % there is at least one patch

    %get properties of initial axes
    pos=get(haxes3d,'CameraTarget');
    cmpos=get(haxes3d,'Cameraposition');
    upvt=get(haxes3d,'CameraUpVector');
    camva=get(haxes3d,'cameraviewangle');
    posaxes=get(haxes3d,'pos');
    xliminit=get(haxes3d,'xlim');
    yliminit=get(haxes3d,'ylim');
    zliminit=get(haxes3d,'zlim');

    %----------------------------------
    % delete temp objs
    delete(findobj(fig,'Tag','copya'));
    %----------------------------------

    % Create a new axes
    newaxes=axes('Parent',frame3d,'Units','normalized','Position',posaxes,'Tag','copya', 'visible','off');

    % set properties of visualization to new axes    
    set(newaxes,'CameraTarget',pos);
    set(newaxes,'Cameraposition',cmpos);
    set(newaxes,'CameraUpVector',upvt);
    set(newaxes,'cameraviewangle',camva);
    set(newaxes,'xlim',xliminit);
    set(newaxes,'ylim',yliminit);
    set(newaxes,'zlim',zliminit);
    set(newaxes,'DataAspectRatio',[1 1 1])
    hold on

    pv=zeros(1, num_pth);
    for i=1:num_pth

        if strcmp(get(obj(type_pth(i)),'visible'),'on')

            %get vertices of patch
            vi=get(obj(type_pth(i)),'vertices');

            % random selection
            n=size(vi,1);
            sel = randperm(n);

            % subs percentage
            lsample=floor(n*redfc);

            % safety check
            if lsample==0
                lsample=n;
            end

            sel = sel(1:lsample);

            vi=vi(sel,:);

            %plot sample points
            pv(i)=plot3(vi(:,1),vi(:,2),vi(:,3),'.','Parent',newaxes, 'visible', 'off');

        end

    end

    if strcmp(mode,'rotate')
         h=rotate3d(newaxes);
         set(h,'Enable','on', 'RotateStyle', 'orbit');
    elseif strcmp(mode,'pan')
         h=pan(fig);
         set(h,'Enable','on');
    elseif strcmp(mode,'zoom')
         h=zoom(newaxes);
         set(h,'Enable','on');
    end   

    set(h,'ActionPreCallback',{@preClb, fig, frame3d, haxes3d, visopt, newaxes, pv, redfc, mode, h, hlight});

end

%--
function preClb(~, ~, fig, frame3d, haxes3d,  visopt, newaxes, pv, redfc, mode, h, hlight)
   
% show destination axes
set(newaxes,'visible', 'off');
set(pv,'visible','on')

% hide source axes
if strcmp(visopt, 'on')
    set(haxes3d, 'visible','off')
end

obj=get(haxes3d,'Children');

% get vis status
vis_obj=cell(1,length(obj));
for i=1:length(obj)
    vis_obj{i}=get(obj(i), 'visible');
end

set(obj,'visible','off')

set(h,'ActionPostCallback',{@postClb, fig, frame3d, haxes3d, visopt, vis_obj, newaxes, redfc, mode, hlight});
    
%---
function postClb(~, ~, fig, frame3d, haxes3d, visopt, vis_obj, newaxes, redfc, mode, hlight)

% get properties of visualization from newaxes
pos=get(newaxes,'CameraTarget');
cmpos=get(newaxes,'Cameraposition');
upvt=get(newaxes,'CameraUpVector');
camva=get(newaxes,'cameraviewangle');
posaxes=get(newaxes,'pos');
xliminit=get(newaxes,'xlim');
yliminit=get(newaxes,'ylim');
zliminit=get(newaxes,'zlim');

% delete new axes and sampled points
delete(newaxes);

set(haxes3d, 'visible',visopt)

obj=get(haxes3d,'Children'); % total obj on axes

for i=1:length(obj)
    set(obj(i),'Visible',vis_obj{i});
end

%set properties of visualization to old axes
set(haxes3d,'CameraTarget',pos);
set(haxes3d,'Cameraposition',cmpos);
set(haxes3d,'CameraUpVector',upvt);
set(haxes3d,'cameraviewangle',camva);
set(haxes3d,'pos',posaxes);
set(haxes3d,'xlim',xliminit);
set(haxes3d,'ylim',yliminit);
set(haxes3d,'zlim',zliminit);

if ~isempty(hlight)
    camlight(hlight,'headlight')
end

% start again
setUpGraphicsNav([], [], fig, frame3d, haxes3d, visopt, redfc, mode);


