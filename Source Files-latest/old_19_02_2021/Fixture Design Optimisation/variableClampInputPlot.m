% plot variable clamp data
function variableClampInputPlot(fem, inputData)

if ~isempty(inputData.Clamp.Variable.Ps)
    
    for j=1:size(inputData.Clamp.Variable.Ps,1)

        pj=inputData.Clamp.Variable.Ps(j,:);

        plot3(pj(:,1),pj(:,2),pj(:,3),'s','color','c','parent',fem.Post.Options.ParentAxes)

        st=sprintf('VarC-Ps %g', j);
        text(pj(1), pj(2), pj(3), st, 'parent',fem.Post.Options.ParentAxes) 
        
        pj=inputData.Clamp.Variable.Pe(j,:);

        plot3(pj(:,1),pj(:,2),pj(:,3),'s','color','c','parent',fem.Post.Options.ParentAxes)

        st=sprintf('VarC-Pe %g', j);
        text(pj(1), pj(2), pj(3), st, 'parent',fem.Post.Options.ParentAxes) 

    end

end

view(3)
axis equal

if fem.Post.Options.ShowAxes
    set(fem.Post.Options.ParentAxes,'visible','on')
else
    set(fem.Post.Options.ParentAxes,'visible','off')
end