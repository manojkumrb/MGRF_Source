function plotCompensationWM(rob, Tfk, T0w, tag, ax, logPanel)

if nargin==3
    logPanel=[];
end

%--
[pointc, facec]=extractCompensationWM(rob, Tfk, T0w);

% plot
tagi=[tag, '[', num2str(length(rob.Options.ShowLink)), ']'];
patch('faces',facec,...
          'vertices',pointc,...
          'facecolor','r',...
          'edgecolor','none',...
          'facealpha',0.4,...
           'tag',tagi,...
           'parent', ax,...
           'buttondownfcn',{@log_current_selection, logPanel})
           
           