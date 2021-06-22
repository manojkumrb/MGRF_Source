% plot robot in 3D
function plotRobot3d(rob, Tfk, tag, Tw0, logPanel)

% rob: robot model
% Tfk: forward kinemetics matrix stack-up
% tag: string
% Tw0: transform world ref. system

%--
if nargin==2
    tag='robot';
    Tw0=eye(4,4);
    logPanel=[];
end

if nargin==3
    Tw0=eye(4,4);
    logPanel=[];
end

if nargin==4
    logPanel=[];
end
    
% plot robot
for i=1:length(rob.Options.ShowLink)
      
        tagi=[tag, '[', num2str(i), ']'];
    
        %--
        [triai, coordinatei, Ti]=extractGeomRobotPose(rob, Tfk, Tw0, i);
        
        if rob.Options.ShowLink(i)  
            patch('faces',triai,...
                  'vertices',coordinatei,...
                  'facecolor',rob.Graphic.Color(i,:),...
                  'edgecolor','none',...
                   'tag',tagi,...
                   'parent', rob.Options.ParentAxes,...
                   'buttondownfcn',{@log_current_selection, logPanel})
        end

        % plot frames for each link
        if rob.Options.ShowFrame(i)
            L=rob.Options.LengthAxisFrame(i);
            plotFrame(Ti(1:3,1:3), Ti(1:3,4)', L, rob.Options.ParentAxes, tagi) 
        end
   
end

% plot tool settings
tooltype=rob.Tool.Model{rob.Tool.Model{1}+1};

if strcmp(tooltype, 'WeldMaster')
    
    plotCompensationWM(rob, Tfk, eye(4,4), tag, rob.Options.ParentAxes, logPanel);

else
    
    %----------
    % add here any other option for tool
    
end

% show TCP
T0tcp=getTCPLocation(rob, Tfk);

L=rob.Options.LengthAxisFrame(end);
plotFrame(T0tcp(1:3,1:3),T0tcp(1:3,4)',...
          rob.Options.ParentAxes,...
          L,...
          tagi)
      
      
      
      

                    % robtype=rob.Model{rob.Model{1}+1};


                    % % plot cameras
                    % if strcmp(robtype,'ABB6620')
                    %     rc=10;
                    %     L=rob.Options.LengthAxisFrame(9); % tool
                    %     
                    %     Tw7=Tw0*setTransformation(Tfk, 7); 
                    %     for i=1:3
                    %         % point
                    %         pcami=rob.Tool.Camera.P(i,:);
                    %         pcami=apply4x4(pcami, Tw7(1:3,1:3), Tw7(1:3,4)'); 
                    %         
                    %         [X,Y,Z]=renderSphereObj(rc, pcami);
                    %         surf(X,Y,Z,...
                    %               'facecolor','k',...
                    %               'edgecolor','none',...
                    %               'facealpha',1,...
                    %               'parent',ax,...
                    %               'tag', tag)
                    %           
                    %        % frame   
                    %        Rc=rob.Tool.Camera.R(:,:,i);
                    %        Rwc=Tw7(1:3,1:3)*Rc;
                    %        
                    %        plotFrame(Rwc, pcami,L,ax,tag);
                    %        
                    %        % FoV
                    %        if rob.Options.ShowCameraFoV(i)
                    %            
                    %            plotCamFoV(rob, Rwc, pcami, tag, ax);
                    %            
                    %        end
                    % 
                    %     end
                    %     
                    %     % camera centre
                    %     pcamc=rob.Tool.Camera.Centre;
                    %     pcamc=apply4x4(pcamc, Tw7(1:3,1:3), Tw7(1:3,4)');
                    %     
                    %     [X,Y,Z]=renderSphereObj(2*rc, pcamc);
                    %     surf(X,Y,Z,...
                    %               'facecolor','r',...
                    %               'edgecolor','none',...
                    %               'facealpha',1,...
                    %               'parent',ax,...
                    %               'tag', tag)
                    %           
                    %     T0t=getTCPLocation(rob, Tfk);
                    %     Twt=Tw0*T0t;
                    %         
                    %     plotFrame(Twt(1:3,1:3), pcamc, L,ax,tag);
                    %           
                    %     % 
                    %     if rob.Options.ShowCameraFoV(4) % plot FoF on camera centre
                    %         T0t=getTCPLocation(rob, Tfk);
                    %         Twt=Tw0*T0t;
                    %         
                    %         plotCamFoV(rob, Twt(1:3,1:3), pcamc, tag, ax);
                    %         
                    %     end
                    %     
                    % end










