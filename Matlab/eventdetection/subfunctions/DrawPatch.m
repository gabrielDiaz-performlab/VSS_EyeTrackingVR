function p = DrawPatch(Ax, Dim, PatchColor)
%% DrawPatch
% Given the axes and dimensions, this function plots a patch with the color
% 'PatchColor'. Can be used recursively by DrawPatches.m
% Author: Rakshit Kothari
% email: rsk3900@rit.edu

x = [Dim(1) Dim(2) Dim(2) Dim(1)];
y = [Dim(3) Dim(3) Dim(4) Dim(4)];
p = patch(x, y , PatchColor, 'EdgeColor', [0 0 0], 'LineWidth', 1, 'FaceAlpha', 0.5);
p.Parent = Ax;
end