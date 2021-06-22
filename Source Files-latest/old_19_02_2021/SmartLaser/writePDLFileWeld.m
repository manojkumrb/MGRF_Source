% create PDL file
function writePDLFileWeld(filepdl, data)

% data.
    % Option.
        % "cartesian": program cartesian location of the robot (Trobot is required)
        % "joint": progra, joint of the robot (theta is required)
    % Stitch(id).
        % Type (1/2) => linear/circular
        % Arm{2}.Position (1x3/4)
        % Arm{2}.Orientation (1x3)
        % Arm{1}: position (1x3)
        % Parameter: parameter id (it corresponds to the tech. table (power and speed) on the robot controller)
        
%--
% open file
idf=fopen(filepdl,'w');

fprintf(idf,'--created in MatLAB\r\n');  

[~,filepdlname,~]=fileparts(filepdl);

fprintf(idf,'PROGRAM %s EZ, PROG_ARM = 1, STACK = 2048\r\n',filepdlname);
fprintf(idf,'\r\n'); 

% define variables
if strcmp(data.Option,'cartesian')
    fprintf(idf,'VAR armp : POSITION\r\n');
elseif strcmp(data.Option,'joint')
    fprintf(idf,'VAR armp : JOINTPOS FOR ARM[2]\r\n');
end

fprintf(idf,'VAR tcpp : POSITION\r\n');
fprintf(idf,'VAR tcpp1 : POSITION\r\n');
fprintf(idf,'VAR tcpp2 : POSITION\r\n');
fprintf(idf,'VAR tcpp3 : POSITION\r\n');
fprintf(idf,'VAR tcpp4 : POSITION\r\n');
fprintf(idf,'\r\n'); 

% import laser routines
fprintf(idf,'ROUTINE l_start(ai_ntab : INTEGER) EXPORTED FROM rl_appl\r\n');
fprintf(idf,'ROUTINE l_init EXPORTED FROM rl_appl\r\n');
fprintf(idf,'ROUTINE l_power(ab_req, ab_pstart : BOOLEAN) EXPORTED FROM rl_appl\r\n');
fprintf(idf,'ROUTINE l_startup EXPORTED FROM rl_appl\r\n');
fprintf(idf,'ROUTINE l_prog(ai_nprog, ai_nfiber : INTEGER) EXPORTED FROM rl_appl\r\n');
fprintf(idf,'ROUTINE l_end EXPORTED FROM rl_appl\r\n');

% start program
fprintf(idf,'\r\n'); 
fprintf(idf,'BEGIN\r\n'); 
fprintf(idf,'\r\n'); 

fprintf(idf,'ATTACH ARM[2]\r\n'); 
fprintf(idf,'\r\n'); 

fprintf(idf,'l_init\r\n'); 
fprintf(idf,'l_prog(0, 1)\r\n'); 
fprintf(idf,'l_startup\r\n'); 
fprintf(idf,'l_power(ON, ON)\r\n'); 

% move to calibration position
fprintf(idf,'\r\n'); 
fprintf(idf,'MOVE ARM[2] TO $ARM_DATA[2].CAL_SYS\r\n'); 
fprintf(idf,'\r\n'); 

% write stitches
nst=length(data.Stitch);

for k=1:nst
    
    % move ARM[2]
    fprintf(idf,'--STITCH[%d]\r\n', k); 
    if strcmp(data.Option,'cartesian')
        fprintf(idf,'armp:=POS(%f, %f, %f, %f, %f, %f, %s)\r\n',data.Stitch(k).Arm(2).Position(1), data.Stitch(k).Arm(2).Position(2), data.Stitch(k).Arm(2).Position(3),...
                                                                data.Stitch(k).Arm(2).Orientation(1),data.Stitch(k).Arm(2).Orientation(2), data.Stitch(k).Arm(2),Orientation(3), ''''''); 
        fprintf(idf,'MOVE ARM[2] JOINT TO armp\r\n'); 
    elseif strcmp(data.Option,'joint')
        fprintf(idf, 'JNT(armp ,%f, %f, %f, %f)\r\n',data.Stitch(k).Arm(2).Position(1), data.Stitch(k).Arm(2).Position(2),data.Stitch(k).Arm(2).Position(3),data.Stitch(k).Arm(2).Position(4));
        fprintf(idf, 'MOVE ARM[2] to armp\r\n');
    end
    
    % move ARM[1]
    if data.Stitch(k).Type==1 % linear
        fprintf(idf,'tcpp:=POS(%f, %f, %f, %f, %f, %f, %s)\r\n',data.Stitch(k).Arm(1).Position(1,1), data.Stitch(k).Arm(1).Position(1,2), data.Stitch(k).Arm(1).Position(1,3),...
                                                                data.Stitch(k).Arm(1).Orientation(1),data.Stitch(k).Arm(1).Orientation(2), data.Stitch(k).Arm(1).Orientation(3), ''''''); 
        fprintf(idf,'MOVE JOINT TO tcpp\r\n'); 
        fprintf(idf,'l_start(%g)\r\n', data.Stitch(k).Parameter); 
        fprintf(idf,'tcpp:=POS(%f, %f, %f, %f, %f, %f, %s)\r\n',data.Stitch(k).Arm(1).Position(2,1), data.Stitch(k).Arm(1).Position(2,2), data.Stitch(k).Arm(1).Position(2,3),...
                                                                data.Stitch(k).Arm(1).Orientation(1),data.Stitch(k).Arm(1).Orientation(2), data.Stitch(k).Arm(1).Orientation(3), '''''');
        fprintf(idf,'MOVE LINEAR TO tcpp\r\n');
        fprintf(idf,'l_end\r\n'); 
        fprintf(idf,'\r\n'); 
    elseif data.Stitch(k).Type==2 % circular
        
         fprintf(idf,'tcpp1:=POS(%f, %f, %f, %f, %f, %f, %s)\r\n',data.Stitch(k).Arm(1).Position(1,1), data.Stitch(k).Arm(1).Position(1,2), data.Stitch(k).Arm(1).Position(1,3),...
                                                                data.Stitch(k).Arm(1).Orientation(1),data.Stitch(k).Arm(1).Orientation(2), data.Stitch(k).Arm(1).Orientation(3), '''''');  
                                                              
         fprintf(idf,'tcpp2:=POS(%f, %f, %f, %f, %f, %f, %s)\r\n',data.Stitch(k).Arm(1).Position(2,1), data.Stitch(k).Arm(1).Position(2,2), data.Stitch(k).Arm(1).Position(2,3),...
                                                                data.Stitch(k).Arm(1).Orientation(1),data.Stitch(k).Arm(1).Orientation(2), data.Stitch(k).Arm(1).Orientation(3), '''''');

         fprintf(idf,'tcpp3:=POS(%f, %f, %f, %f, %f, %f, %s)\r\n',data.Stitch(k).Arm(1).Position(3,1), data.Stitch(k).Arm(1).Position(3,2), data.Stitch(k).Arm(1).Position(3,3),...
                                                                data.Stitch(k).Arm(1).Orientation(1),data.Stitch(k).Arm(1).Orientation(2), data.Stitch(k).Arm(1).Orientation(3), '''''');
                                                              
         fprintf(idf,'tcpp4:=POS(%f, %f, %f, %f, %f, %f, %s)\r\n',data.Stitch(k).Arm(1).Position(4,1), data.Stitch(k).Arm(1).Position(4,2), data.Stitch(k).Arm(1).Position(4,3),...
                                                                data.Stitch(k).Arm(1).Orientation(1),data.Stitch(k).Arm(1).Orientation(2), data.Stitch(k).Arm(1).Orientation(3), '''''');
                                                            
        fprintf(idf,'MOVE JOINT TO tcpp1\r\n'); 
        fprintf(idf,'l_start(%g)\r\n', data.Stitch(k).Parameter); 
        fprintf(idf,'MOVEFLY CIRCULAR TO tcpp3 VIA tcpp2 ADVANCE\r\n');
        fprintf(idf,'MOVE CIRCULAR TO tcpp1 VIA tcpp4\r\n');
        fprintf(idf,'l_end\r\n'); 
        fprintf(idf,'\r\n'); 
        
    end
        
    
end

% add small delay
fprintf(idf,'DELAY 1000\r\n'); 
fprintf(idf,'\r\n'); 

fprintf(idf,'l_power(OFF, OFF)\r\n'); 

fprintf(idf,'END %s\r\n', filepdlname); 

%--
fclose(idf); % close file...


