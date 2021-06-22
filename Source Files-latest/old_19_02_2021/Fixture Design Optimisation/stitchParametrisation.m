function inData=stitchParametrisation(inData, parameter)

% inData: inout data structure
% parameter.T: parameter T (stitch line)
% parameter.V: parameter V (stitch trasversal direction)
    
% run over all stitches
ns=size(inData.Stitch.Ps,1);

% run over all stitches
for i=1:ns

    typest=inData.Stitch.Type(i);
    
    if typest==1 % linear
                
        %%
        % starting/ending point
        Ps=inData.Stitch.Ps(i,:);
        Pe=inData.Stitch.Pe(i,:);
        
        L=norm(Ps-Pe);
        
        % tangential vector
        T=(Pe-Ps)/L;
        
        % normal vector
        N=inData.Stitch.Ns(i,:);
        
        V=cross(N, T)/norm(cross(N, T));
        
        N=cross(T, V)/norm(cross(T, V));
        
        R=[T' V' N'];
        
        % define parametrised point into local frame
        ts=[parameter.T(i) parameter.V(i) 0];
        te=[parameter.T(i)+L parameter.V(i) 0];
        
        % transform back into global frame
        Ps=apply4x4(ts,R,Ps);
        inData.Stitch.Ps(i,:)=Ps;
        
        Pe=apply4x4(te,R,Ps);
        inData.Stitch.Pe(i,:)=Pe;
        
      if typest==2 % circular
          
          %-------------------------
          % to be completed
          %-------------------------
          
      end
        
    end
    
end

