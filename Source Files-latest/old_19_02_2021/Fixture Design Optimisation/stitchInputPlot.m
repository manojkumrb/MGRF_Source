% plot stitch data
function stitchInputPlot(fem, inputData)

if ~isempty(inputData.Stitch.Ps)
    
    for j=1:size(inputData.Stitch.Ps,1)

        Ps=inputData.Stitch.Ps(j,:);
        Pe=inputData.Stitch.Pe(j,:);

        pj=[Ps
            Pe];

        plot3(pj(:,1),pj(:,2),pj(:,3),'-','linewidth',6,'color','k','parent',fem.Post.Options.ParentAxes)

        st=sprintf('RLW%g-Ps', j);
        text(Ps(1), Ps(2), Ps(3), st, 'parent',fem.Post.Options.ParentAxes) 
        
        st=sprintf('RLW%g-Pe', j);
        text(Pe(1), Pe(2), Pe(3), st, 'parent',fem.Post.Options.ParentAxes) 

    end

end

view(3)
axis equal

if fem.Post.Options.ShowAxes
    set(fem.Post.Options.ParentAxes,'visible','on')
else
    set(fem.Post.Options.ParentAxes,'visible','off')
end