function [figHand] = gdDrawAxisAtOrigin(transform,length,radius)

% A function to plot a set of axes at an origin
% THe input should be a set of 4 vertices: vert_xyzw_v, where the first colum
% is the origin of the axis space, and the 2:4 columns are the XYZ axes.

% Returns a handle to a group of figure objects 

figHand = hggroup;

vert_xyzw_v = [[0 0 0 1]' [1 0 0 1]' [0 1 0 1]' [0 0 1 1]'];
vert_xyzw_v(1:3,:) = vert_xyzw_v(1:3,:).*length;

vert_xyzw_v = transform * vert_xyzw_v;
%%
% for i = 1:size(vert_xyzw_v,2)
%     vert_xyzw_v(:,i) = vectorNorm3d(vert_xyzw_v(:,i));
% end
%%


zVals_v = vert_xyzw_v(3,:);
vert_xyzw_v(3,:) = vert_xyzw_v(2,:);
vert_xyzw_v(2,:) = zVals_v;

origin = vert_xyzw_v(1:3,1);
drawCylinder([origin' vert_xyzw_v(1:3,2)' radius], 16, 'facecolor', 'r', 'edgecolor', 'none','Parent',figHand);
drawCylinder([origin' vert_xyzw_v(1:3,3)' radius], 16, 'facecolor', 'g', 'edgecolor', 'none','Parent',figHand);
drawCylinder([origin' vert_xyzw_v(1:3,4)' radius], 16, 'facecolor', 'b', 'edgecolor', 'none','Parent',figHand);
drawSphere([origin' 2*radius], 'faceColor', 'black','Parent',figHand);

