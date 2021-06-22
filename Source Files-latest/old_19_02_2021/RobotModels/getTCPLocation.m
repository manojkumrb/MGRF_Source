% get TCP location
function Ttcp=getTCPLocation(rob, T)

robmodel=rob.Model{rob.Model{1}+1};

if strcmp(robmodel,'SmartLaser') 
    Ttcp=setTransformation(T, 7);
elseif strcmp(robmodel,'ABB6620') || strcmp(robmodel,'ABB6700-200') || strcmp(robmodel,'ABB6700-235')
        Tflange=setTransformation(T, 7);
        
        ptcp=rob.Tool.P;
        Rtcp=rob.Tool.R;

        Ttcp=eye(4,4);
        Ttcp(1:3,1:3)=Rtcp; Ttcp(1:3,4)=ptcp;

        Ttcp=Tflange*Ttcp;
else
    
    
    
    %-------------
    % add here any other model
    
    
    
    
end

