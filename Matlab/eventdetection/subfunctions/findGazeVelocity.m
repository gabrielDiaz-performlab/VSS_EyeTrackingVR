function [GVel_out] = findGazeVelocity(t, EIH_vec, filterStyle, plotData)

%% Compute Gaze velocity by adjacent samples
%% Input:
% 1. t - array of time values.
% 2. EIH_vec - Eye-In-Head vector.
% 3. filterStyle - A number which indicates the filtering technique.
% 4. plotData - A flag to indicate if you want to visual the filtering.

%% Output;
% 1. Gaze velocity

% Normalize the rows to ensure we are working with unit vectors.
EIH_vec = normr(EIH_vec);

% 1 sample shifted signal to compute velocity. As the sampling rate of a
% system increases, it generally is considered detrimental to compute
% velocity using adjacent samples due to increasing effects of noise over
% higher sampling rates. However, if the correct filtering algorith is used
% then the issue can mitigated.
EIH_vec_t1 = EIH_vec(1:end-1, :); EIH_vec_t2 = EIH_vec(2:end, :);

%% Using inverse tan to compute velocity. Refer to the notes for the formula.
% Compute the dot product.
DotProduct = dot(EIH_vec_t1, EIH_vec_t2, 2); 

% Find all locations where the DOT product is < -1 or > 1. The intuition
% being that the dot product between two unit vectors cannot exceed 1 or -1. 
loc = DotProduct > 1 | DotProduct < -1; 
loc_bad_dot = find(loc); 
loc_good_dot = find(~loc);

CrossProduct = cross(EIH_vec_t1, EIH_vec_t2, 2);
CrossProduct_norm = vecnorm(CrossProduct, 2, 2);

% Find all locations where the CROSS product is < -1 or > 1. The intuition
% being that the cross product between two unit vectors cannot exceed 1 or -1.
loc = CrossProduct_norm > 1 | CrossProduct_norm < -1; 
loc_bad_cross = find(loc); 
loc_good_cross = find(~loc); 

loc_bad = unique([loc_bad_dot; loc_bad_cross]);

% Only consider samples which have appropriate cross and dot product.
loc_good = intersect(loc_good_dot, loc_good_cross);

% Iterate through every "bad" sample and replace it with the closest "good"
% sample.
for i = 1:length(loc_bad)
   x = loc_bad(i);

   % Find closest good sample
   loc = findClosest(loc_good, x);
   y = loc_good(loc);
   DotProduct(x) = DotProduct(y);
   CrossProduct_norm(x) = CrossProduct_norm(y);
end

% Use the inverse Tangent to find the absolute angular displacement between
% two vectors.
in_dTheta = atand(CrossProduct_norm./DotProduct);

% Constrain the algorithm such that the maximum angular displacement
% between two gaze positions cannot exceed 6 degrees per sample. This is
% because with a maximum gaze velocity of 700 deg/sec, the maximum angular
% distance travelled in 1/SR seconds is given by 700/SR. Angular
% velocities greater than 700 deg/sec are highly unlikely. SR - sampling
% rate. 

% Compute SR
SampRate = 1./mean(diff(t)); 

% Find location where angular displacement is exceeds 700/SR
loc = in_dTheta > (700/SampRate);

% Nearest interpolation by replacing those error values
in_dTheta = interp1(t(~loc), in_dTheta(~loc), t, 'nearest');

in_dTheta = in_dTheta(:);
GVel = in_dTheta(2:end)./diff(t(:));
GVel = [0; GVel]; % Gaze velocity will be 1 sample short 
GVel(GVel < 0) = 0;

if filterStyle == 1
    %% Method 1 - 1D Bilateral filtering
    % Normalize the signal by scaling it between 0 and 1, apply Bilateral
    % filtering, rescale it back to original dimensions.
    minPt = min(GVel);
    GVel_n = GVel - minPt; maxPt = max(GVel_n); GVel_n = GVel_n/maxPt;
    GVel_n = bfilter2(GVel_n, 10, [10/4 0.025/2]);
    GVel_n = GVel_n*maxPt;
    GVel_out = GVel_n + minPt;

    if plotData
        figure; hold on;
        plot(t, GVel_out, 'Color', [0, 0, 1])
        plot(t, GVel, 'Color', [0, 1, 0])
        hold off;
        legend('Filtered', 'Original')
    end
elseif filterStyle == 2
    %% Method 2 - Mean filtering
    % Compute Gaze velocity by measuring angular distance moved in window.
    % Left for reader to implement.
    GVel_out = smooth(GVel, 10, 'moving');
    
    if plotData
        figure; hold on;
        plot(t, GVel_out, 'Color', [0, 0, 1])
        plot(t, GVel, 'Color', [0, 1, 0])
        hold off;
        legend('Filtered', 'Original')
    end
elseif filterStyle == 3
    %% Method 3 - Filter of your own choice
    
    
elseif filterStyle == 0
    %% Method 0 - No filtering
    GVel_out = GVel;
end
end