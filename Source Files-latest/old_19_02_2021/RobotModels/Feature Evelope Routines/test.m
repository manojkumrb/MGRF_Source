clc;
clear;

% Inputs
filename = 'feature.xlsx';
sheet_1 = 1;
feature_id = 1;
Pi = [-280.6, 379.3, 766];
res_surface = 50;
res_envelop = 9;

wdir='Z:\Factory-of-the-future\Catapult\IPQI\ROBOT Model\VRM-code';
addpath(genpath(wdir));

% initialis feature parameters
feature = initFeature(filename, sheet_1);

if size(feature,1)~=0
    % get intial measure envelope (IME) and sample points inside the IME
    nodeIME = initMeasueremntEnvelop(feature, feature_id, res_surface, res_envelop);

    % check whether a particular point is inside the IME
    flag = checkNodePosition(feature, feature_id, Pi);
    
    if flag ==1
        x = ['.... Point [', num2str(Pi), '] is inside the Intial Measruement Envelop'];
        disp (x);
        % get the feasible position of second tile relative to first tile position
        nodeSecondTile = getSecondTilePostion(nodeIME, feature, feature_id, Pi);
        scatter3(Pi(:,1), Pi(:,2), Pi(:,3));
        scatter3(nodeSecondTile(:,1), nodeSecondTile(:,2), nodeSecondTile(:,3), 'r');
    else
        x = ['... Point [', strim(num2str(Pi)) , '] is not inside the Initial Measurement Envelop'];
        disp(x);
    end
end


