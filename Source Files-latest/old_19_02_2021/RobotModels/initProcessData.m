% init process data
function processData=initProcessData(rob)

% processData

if strcmp(rob.Model,'ABB6620') % 7-axis robot
    processData=initABB6620;
    
else
    
    
    
    %--------------
    
    
    
end


%----
function processData=initABB6620()

% processData.
    % speedData - [linear TCP, rotation TCP, linear auxiliar axis rotation auxiliar axis] (mm/sec - degree/sec)
    % zoneData  - [TCP path, orientation, auxiliar axis, orientation, linear axis, rotating axis] (mm, degree)
    
 processData.speedData=[500, 500, 5000, 1000];
 processData.zoneData=[50, 75, 75, 7.5, 75, 7.5];
