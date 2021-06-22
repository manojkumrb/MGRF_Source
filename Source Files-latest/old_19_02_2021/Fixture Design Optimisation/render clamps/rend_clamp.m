%-----------------------
% sample_case_study_01.m
%-----------------------

clc
clear
close all
 
%% define VRM folder
wdir='E:\MAIN\PROGETTI\7FE-2011\VRM v01\Source Files';
path(path,wdir);
 
% init fem structure
fem=femInit(wdir);

eps=1e-6;
[tria,node]=readMeshStl('clamgeo_Lshape.stl',eps);

clampgeo.Face=tria;
clampgeo.Vertex=node;

save('clampgeo_Lshape','clampgeo')

hold all
patch('faces',tria,'vertices',node,'facecolor','g')

plot3(0,0,0,'s')
view(3)
axis equal

