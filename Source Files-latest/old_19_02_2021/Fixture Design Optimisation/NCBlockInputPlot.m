% plot refs clamp data
function NCBlockInputPlot(fem, inputData)

if ~isempty(inputData.NcBlock.Pm)
    
    for j=1:size(inputData.NcBlock.Pm,1)

        pj=inputData.NcBlock.Pm(j,:);

        plot3(pj(:,1),pj(:,2),pj(:,3),'s','color','c','parent',fem.Post.Options.ParentAxes)

        st=sprintf('NC%g', j);

        m=mean(pj,1);
        text(m(1), m(2), m(3), st, 'parent',fem.Post.Options.ParentAxes) 

    end

end

view(3)
axis equal

if fem.Post.Options.ShowAxes
    set(fem.Post.Options.ParentAxes,'visible','on')
else
    set(fem.Post.Options.ParentAxes,'visible','off')
end