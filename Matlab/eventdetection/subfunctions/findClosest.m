function [out, val] = findClosest(in, datapt)
%% findClosest
% This function finds the closest sample to the query point in a matrix and
% also returns the value. Similar is measured by Eucid distance. Consider
% using MATLAB's pdist function for more distance metric options.

% Author - Rakshit Kothari

% Inputs:
% 1. in - The input matrix or vector
% 2. datapt - Query sample

[a, b] = size(in);
if b > a
    in = in';
    datapt = datapt';
end

diffval = in - repmat(datapt, [length(in), 1]);
diffval = sqrt(sum(diffval.^2, 2));
[val, out] = min(diffval);
end