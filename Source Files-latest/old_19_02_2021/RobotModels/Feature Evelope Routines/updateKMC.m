% update KMC structure
function KMC= updateKMC(KMC)

% INPUTS:
    % KMC - KMC structure

% OUTPUTS:
    % updated .Status - true/false => updated/not updated
   
eps=1e-6;
    
%--

% loop over all KMCs
nkmc = length(KMC);
for i=1:nkmc
    
    fprintf('Updating KMC[%g]\n', i);

    if strcmp('Round_Hole',KMC(i).Type) == 1 || strcmp('Hexagonal_Hole',KMC(i).Type) == 1
       
    % check and update mandatory vectors
        if length(KMC(i).Vectors.Point) ~= 3
            fprintf('   Error: you must provide centre POINT of KMC [%g]\n', i);
            KMC(i).Status = false;
            return
        end
        if length(KMC(i).Vectors.Normal) ~= 3
            fprintf('   Error: you must provide NORMAL of KMC [%g]\n', i);
            KMC(i).Status = false;
            return
        end
        
        l=norm(KMC(i).Vectors.Normal);
        
        if l<eps
            fprintf('   Error: you must provide non-zero NORMAL of KMC [%g]\n', i);
            KMC(i).Status = false;
            return
        end
        
        % update frame
        KMC = getLocalFrameKMC(KMC);
               
     % check mandatory scalars i.e. diameter
        if isempty(KMC(i).Scalars.Diameter) 
            fprintf('   Error: you must provide non-zero DIAMETER of KMC [%g]\n', i);
            KMC(i).Status = false;
            return
        end 
        
     % check mandatory constraints
        if length(KMC(i).Constraints.Distance) ~= 2
            fprintf('   Error: you must provide non-zero Distance Constraint of KMC [%g]\n', i);
            KMC(i).Status = false;
            return
        end
        if length(KMC(i).Constraints.Angle.Normal) ~= 2
            fprintf('   Error: you must provide non-zero Normal Constraint of KMC [%g]\n', i);
            KMC(i).Status = false;
            return
        end
        if length(KMC(i).Constraints.Angle.Tangent) ~= 2
            fprintf('   Error: you must provide non-zero Tangent Constraint of KMC [%g]\n', i);
            KMC(i).Status = false;
            return
        end
    
    end
    
    
    
    
    
                %     if strcmp('Rectangular_Hole',KMC(i).type) == 1 || strcmp('Square_Hole',KMC(i).type) == 1
                %        
                % %       check mandatory vectors i.e. centre of hole, surface normal, vector of length and width
                %         if isempty(KMC(i).Vectors.Point) == 1
                %             x = ['... You must provide centre POINT of ', KMC(i).type, '!!!'];
                %             disp (x);
                %             flag = 1;
                %         end
                %         if isempty(KMC(i).Vectors.Normal) == 1
                %             x = ['... You must provide surface NORMAL of ', KMC(i).type, '!!!'];
                %             disp (x);
                %             flag = 1;
                %         end
                %         if isempty(KMC(i).Vectors.Length) == 1
                %             x = ['... You must provide VECTOR OF LENGTH of ', KMC(i).type, '!!!'];
                %             disp (x);
                %             flag = 1;
                %         end
                %         if isempty(KMC(i).Vectors.Width) == 1
                %             x = ['... You must provide VECTOR OF WIDTH of ', KMC(i).type, '!!!'];
                %             disp (x);
                %             flag = 1;
                %         else
                %             
                %             KMC = getLocCord(KMC); 
                %         end
                %         
                % %       check mandatory scalars i.e. length and width
                %         if isempty(KMC(i).Scalars.Length) == 1
                %             x = ['... You must provide Length of ', KMC(i).type, '!!!'];
                %             disp (x);
                %             flag = 1;
                %         end 
                %         if isempty(KMC(i).Scalars.Width) == 1
                %             x = ['... You must provide Width of ', KMC(i).type, '!!!'];
                %             disp (x);
                %             flag = 1;
                %         end  
                %         
                %   %     check constraints      
                %         if size(KMC(i).Constraints.Con1) ~= 2
                %             x = ['... You must provide constraint1 of ', KMC(i).type, '!!!'];
                %             disp (x);
                %             flag = 1;
                %         end
                %         if size(KMC(i).Constraints.Con2) ~= 2
                %             x = ['... You must provide constraint2 of ', KMC(i).type, '!!!'];
                %             disp (x);
                %             flag = 1;
                %         end
                %         if size(KMC(i).Constraints.Con3) ~= 2
                %             x = ['... You must provide constraint3 of ', KMC(i).type, '!!!'];
                %             disp (x);
                %             flag = 1;
                %         end
                %         if size(KMC(i).Constraints.Con4) ~= 2
                %             x = ['... You must provide constraint4 of ', KMC(i).type, '!!!'];
                %             disp (x);
                %             flag = 1;
                %         end 
                %     end
                %    
                %     flag1 = flag; 
                % %     if flag==0
                %         KMC_structure = KMC;
                % %     end
end


