% write robot model to controller
function robotModel2Controller(filename, rob, jointData, processData)

% rob: robot model
% jointData.
    % Joint: joint coordinates
    % speedData
    % zoneData
% processData.
    % speedData 
    % zoneData  
    
if strcmp(rob.Model,'ABB6620') % 7-axis robot
    writeABB6620(filename, rob, jointData, processData)
else
    
    
    
    %--------------
    
    
    
end


%-------------------
function writeABB6620(filename, rob, jointData, processData)

% jointData.
    % Joint: joint coordinates (mm, radians)
    % speedData
    % zoneData
    
% processData.
    % speedData - [linear TCP, rotation TCP, linear auxiliar axis rotation auxiliar axis] (mm/sec - degree/sec)
    % zoneData  - (mm)

if ~isfield(jointData, 'Tag')
    jointData.Tag=[];
end

% define comment header
com='!---'; 
 
[~,filen,~]=fileparts(filename);


% open file
idf=fopen(filename,'w');

fprintf(idf,'%s Created in MatLAB\r\n', com);  
fprintf(idf, '\r\n');

fprintf(idf, 'MODULE %s\r\n', filen);

% STEP 1: write tool
fprintf(idf,'%s Tool data\r\n', com);  
ptool=rob.Parameter.Tool.P;
qtool=rot2Quat(rob.Parameter.Tool.R);
mass=rob.Parameter.Tool.Load.Mass;
Cmass=rob.Parameter.Tool.Load.P;
qmass=rot2Quat(rob.Parameter.Tool.Load.R);
Imass=rob.Parameter.Tool.Load.I;

fprintf(idf, 'PERS tooldata tool_%s:=[TRUE,[[%f, %f, %f],[%f, %f, %f, %f]],[%f,[%f, %f, %f],[%f, %f, %f, %f],%f,%f,%f]];\r\n',...
                                            filen,...
                                            ptool(1), ptool(2), ptool(3),...
                                            qtool(1), qtool(2), qtool(3), qtool(4),...
                                            mass,...
                                            Cmass(1), Cmass(2), Cmass(3),...
                                            qmass(1), qmass(2), qmass(3), qmass(4),...
                                            Imass(1), Imass(2), Imass(3));

% STEP 2: write speeddata
fprintf(idf,'%s Speed data\r\n', com);  
ns=size(processData.speedData,1);
for i=1:ns
    sdata= processData.speedData(i,:);
    
    fprintf(idf, 'CONST speeddata speed_%g_%s:=[%f,%f,%f,%f];\r\n',...
                                            i, filen, ...
                                            sdata(1), sdata(2), sdata(3), sdata(4));
end

% STEP 3: write zonedata
fprintf(idf,'%s Zone data\r\n', com);  
nz=size(processData.zoneData,1);
for i=1:nz
    zdata= processData.zoneData(i,:);
    
    fprintf(idf, 'CONST zonedata zone_%g_%s:=[FALSE, %f, %f, %f, %f, %f, %f];\r\n',...
                                            i, filen, ...
                                            zdata(1), zdata(2), zdata(3), zdata(4), zdata(5), zdata(6));
    
end
 
% STEP 4: write program
fprintf(idf, '\r\n');
fprintf(idf, '  PROC %s_program()\r\n', filen);
nq=size(jointData.Joint,1);

for i=1:nq
    
    % raed joint coordinates
    qa=jointData.Joint(i,1); % mm
    qr=jointData.Joint(i,2:end)*180/pi; % passed in degrees
    
    % read speed data
    speedid=jointData.speedData(i);
    
    % read zone data
    zoneid=jointData.zoneData(i);
    
    % tag
    if ~isempty(jointData.Tag)
        tagi=sprintf('    %s %s', com, jointData.Tag{i});
    else
        tagi=sprintf('    %s Joint movement[%g]', com, i);
    end
    
    % write joint movement
    fprintf(idf, '%s\r\n', tagi);
    fprintf(idf, '    MoveAbsJ [[%f, %f, %f, %f, %f, %f], [%f, 9E+09, 9E+09, 9E+09, 9E+09, 9E+09]], speed_%g_%s, zone_%g_%s, tool_%s;',...
                              qr(1), qr(2), qr(3), qr(4), qr(5), qr(6),...
                              qa,...
                              speedid, filen,...
                              zoneid, filen,...
                              filen);
    fprintf(idf, '\r\n');
    fprintf(idf, '\r\n');
    
end

%--
fprintf(idf, '\r\n');
fprintf(idf, '  ENDPROC\r\n');

%--
fprintf(idf, '\r\n');
fprintf(idf, 'ENDMODULE\r\n');

%--
fclose(idf); % close file...


    
    
