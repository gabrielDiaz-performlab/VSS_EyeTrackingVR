%% GazeClassification
% The purpose of this script is to provide a sandbox file for users to run
% a basic I-VDT algorithm to detect Saccades and fixations.
% Author: Rakshit Kothari
% email: rsk3900@rit.edu

clear all
close all
clc

%% Load previously filtered data
load('FilteredData.mat')

%% Calculate Dispersion from POR values around a window
POR = [ExpData.POR_1(:), ExpData.POR_2(:)];

% Normalize POR values between -1 and 1
POR(:, 1) = POR(:, 1) - min(POR(:, 1));
POR(:, 1) = POR(:, 1)/max(POR(:, 1));
POR(:, 1) = 2*POR(:, 1) - 1;

POR(:, 2) = POR(:, 2) - min(POR(:, 2));
POR(:, 2) = POR(:, 2)/max(POR(:, 2));
POR(:, 2) = 2*POR(:, 2) - 1;

%% Compute Dispersion
N = length(ExpData.T);
ExpData.Disper = zeros(N, 1);

% Choose a window size
HalfWinSize = 15;
for i = (HalfWinSize + 1):(N - HalfWinSize) 
    iterx = i - HalfWinSize; itery = i + HalfWinSize;
    pxWindow = POR(iterx:itery, :);
    pxCurrent = POR(i, :);
    
    % Find distance of every point to the centrol point in the window
    D = sqrt(sum((pxWindow - repmat(pxCurrent, [HalfWinSize*2 + 1, 1])).^2, 2));
    ExpData.Disper(i) = std(D);
end

% Replicate the ExpData.Dispersion values for initial conds
ExpData.Disper(1:HalfWinSize) = ExpData.Disper(HalfWinSize + 1);
ExpData.Disper(end - HalfWinSize + 1:end) = ExpData.Disper(end - HalfWinSize);
LabelData = Classify_GUI(ExpData);