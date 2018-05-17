%% NOTE
% The purpose of this script is to generate a mat file which is to be used
% by attendees of the workshop. Do not run.
% Author: Rakshit Kothari

clear all
close all
clc

%% 

str_Data = 'C:\Users\Rudra\Documents\MATLAB\VSS2018_workshop\WorkshopData\ETG_Test\1\Gaze\';
Eye0_T = readtable([str_Data, 'Eye0\timing.txt']);
Eye1_T = readtable([str_Data, 'Eye0\timing.txt']);
Scene_T = readtable([str_Data, 'Scene\timing.txt']);

GazeData = readtable([str_Data, 'exports\gaze_positions.csv']);
PupilData = readtable([str_Data, 'exports\pupil_positions.csv']);

loc0 = PupilData.id == 0; loc1 = PupilData.id == 1;
PD_0 = PupilData.diameter_3d(loc0); PD_1 = PupilData.diameter_3d(loc1);
T_0 = PupilData.timestamp(loc0); T_1 = PupilData.timestamp(loc1);

ETG_Table.T = GazeData.timestamp;
ETG_Table.Eye0_fr = interp1(Eye0_T.Var2, Eye0_T.Var1, ETG_Table.T, 'nearest');
ETG_Table.Eye1_fr = interp1(Eye1_T.Var2, Eye1_T.Var1, ETG_Table.T, 'nearest');
ETG_Table.Scene_fr = interp1(Scene_T.Var2, Scene_T.Var1, ETG_Table.T, 'nearest');
ETG_Table.L_gv = [GazeData.gaze_normal0_x, GazeData.gaze_normal0_y, GazeData.gaze_normal0_z];
ETG_Table.R_gv = [GazeData.gaze_normal1_x, GazeData.gaze_normal1_y, GazeData.gaze_normal1_z];
ETG_Table.Confidence = GazeData.confidence;
ETG_Table.POR = [1080*(1 - GazeData.norm_pos_y), 1920*GazeData.norm_pos_x];
ETG_Table.L_pd = interp1(T_0, PD_0, ETG_Table.T, 'spline');
ETG_Table.R_pd = interp1(T_1, PD_1, ETG_Table.T, 'spline');

writetable(struct2table(ETG_Table), 'ExpData.csv')