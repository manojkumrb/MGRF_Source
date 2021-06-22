function feature_structure = importFeature(filename, sheet)


%  inputs
% filename = 'feature.xlsx';
% sheet = 1;
vec_para = ['Point     '; 'Normal    '; 'Length    '; 'Width     '];
sca_para = ['Diameter  '; 'Length    '; 'Width     '; 'Height    '];
con_para = ['Con1'; 'Con2'; 'Con3'; 'Con4'; 'Con5'; 'Con6'];

max_f_vec = size(vec_para, 1);
max_f_sca = size(sca_para, 1);
max_f_con = size(con_para, 1);

flag = 0;

[~,~,raw] = xlsread(filename, sheet);

% number of defined features
feature_number = size(raw(:,1),1)- 2;

% create feature structure
for i=1:feature_number
    
    feature(i).type = raw{i+2,1};
    
    % for vector inputs
    for j=1:max_f_vec

        v1 = raw{i+2,j+1};
        if strfind(v1,',') > 0
            v = strsplit(v1, ',');
            if size(v,2) == 3
                field_name = strtrim(vec_para(j,:));
                v2 = [str2num(v{1,1}) str2num(v{1,2}) str2num(v{1,3})];
                feature(i).Vectors.(field_name) = v2;
                v = [];
                v1 = [];
                v2 =[];
            else
                field_name = strtrim(vec_para(j,:));
                x = ['... Please enter comma separated three (3) vector components for ', upper(field_name), ' of ', feature(i).type, '!!!'];
                disp (x); 
                flag = 1;
            end
        elseif isnan(v1)== 1   
            field_name = strtrim(vec_para(j,:));
            feature(i).Vectors.(field_name)= [];
        else
            field_name = strtrim(vec_para(j,:));
            x = ['... Please enter comma separated three (3) vector components (not scalar) for ', upper(field_name), ' of ', feature(i).type, '!!!'];
            disp (x); 
            flag = 1; 
        end
    end
    
    % for scalar inputs
    for j=1:max_f_sca
        s = raw{i+2,j+1+max_f_vec};

        if strfind(s,',') > 0 & isnan(s)== 0
            field_name = strtrim(sca_para(j,:));
            x = ['... Please enter scalar value (not comma seperated) for ', upper(field_name), ' of ', feature(i).type, '!!!'];
            disp (x);
            flag = 1;
        elseif s > 0
            field_name = strtrim(sca_para(j,:));
            feature(i).Scalars.(field_name) = s;
            s = [];
        elseif isnan(s)== 1   
            field_name = strtrim(sca_para(j,:));
            feature(i).Scalars.(field_name)= [];
        else
            field_name = strtrim(sca_para(j,:));
            x = ['... Please enter postive value for ', upper(field_name), ' of ', feature(i).type, '!!!'];
            disp (x);
            flag = 1;
        end
    end
    
    % for constraints
    for j=1:max_f_con
        
        con = raw{i+2,j+1+max_f_vec+max_f_sca};
        
        if strfind(con,',') > 0
            mm = strsplit(con, ',');
            if size(mm,2) == 2
                field_name = strtrim(con_para(j,:));
                feature(i).Constraints.(field_name) = [str2num(mm{1,1}) str2num(mm{1,2})];
                mm = [];
            else
                field_name = strtrim(con_para(j,:));
                x = ['... Please enter comma separated two(2) upper and lower boundary of contsraints for ', upper(field_name), ' of ', feature(i).type, '!!!'];
                disp (x); 
                flag = 1;
            end
        elseif isnan(con)== 1   
            field_name = strtrim(con_para(j,:));
            feature(i).Constraints.(field_name)= [];
        else
            field_name = strtrim(con_para(j,:));
            x = ['... Please enter comma separated two(2) upper and lower boundary of contsraints for ', upper(field_name), ' of ', feature(i).type, '!!!'];
            disp (x);  
            flag = 1; 
        end
    end   
end


% checking whether mandatory fileds are populated
if flag == 0
    [check, feature] = check_feature_inputs(feature);
    if check == 0
        disp '...  features entered correctly';
        feature_structure = feature;
    else
        disp '... ALL THE MANDATORY FIELD OF THE FEATURES ARE NOT POPULATED PROPERLY';
    end
else
    disp ' ';
    disp '...INPUTS ARE NOT CORRECT. CHECK THE DETAILS OF THE MATLAB OUTPUT FOR MISSING INFORMATION';
    feature_structure = [];
end














