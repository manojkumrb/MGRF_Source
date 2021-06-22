% create PDL file
function writePDLFile(filepdl, posarm2, posarm1, thetaarm2)

if nargin==2
    thetaarm2=[];
end

% open file
idf=fopen(filepdl,'w');

fprintf(idf,'--created in MatLAB\r\n');  

[~,filepdlname,~]=fileparts(filepdl);

fprintf(idf,'PROGRAM %s EZ, PROG_ARM = 1, STACK = 2048\r\n',filepdlname);
fprintf(idf,'\r\n'); 

% define variables
if isempty(thetaarm2)
    fprintf(idf,'VAR armp : POSITION\r\n');
else
    fprintf(idf,'VAR armp : JOINTPOS FOR ARM[2]\r\n');
end

fprintf(idf,'VAR tcpp : POSITION\r\n');
fprintf(idf,'\r\n'); 

% start program
fprintf(idf,'\r\n'); 
fprintf(idf,'BEGIN\r\n'); 
fprintf(idf,'\r\n'); 

fprintf(idf,'ATTACH ARM[2]\r\n'); 
fprintf(idf,'\r\n'); 

% write stitches
nst=size(posarm2,1);

for k=1:nst

    % move ARM[2]
    fprintf(idf,'--STITCH[%d]\r\n', k); 
    if isempty(thetaarm2)
        fprintf(idf,'armp:=POS(%f, %f, %f, %f, %f, %f, %s)\r\n',posarm2(k,1), posarm2(k,2), posarm2(k,3), posarm2(k,4), posarm2(k,5), posarm2(k,6), ''''''); 
        fprintf(idf,'MOVE ARM[2] JOINT TO armp\r\n'); 
    else
        fprintf(idf, 'JNT(armp ,%f, %f, %f, %f)\r\n',thetaarm2(k,1), thetaarm2(k,2), thetaarm2(k,3), thetaarm2(k,4));
        fprintf(idf, 'MOVE ARM[2] to armp\r\n');
    end
    
    % move ARM[1]
    fprintf(idf,'tcpp:=POS(%f, %f, %f, %f, %f, %f, %s)\r\n',posarm1(k,1), posarm1(k,2), posarm1(k,3), posarm2(k,4), posarm2(k,5), posarm2(k,6), ''''''); 
    fprintf(idf,'MOVE JOINT TO tcpp\r\n'); 
    fprintf(idf,'\r\n'); 
    
end

fprintf(idf,'END %s\r\n', filepdlname); 

%--
fclose(idf); % close file...

