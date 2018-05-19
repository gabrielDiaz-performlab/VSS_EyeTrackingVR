function LabelStruct = GenerateLabelStruct(in, T)
%% Generate updated label structure based on labels
% We generate a label structure again because the labeller essentially
% overwrites labels based on overwritten events.

[Val, ~, StartEnd_Idx] = RunLength(in);
LabelStruct = struct('LabelTime',[], 'LabelLoc', [], 'Label', []);

for i = 1:size(StartEnd_Idx, 1)
    LabelStruct(i).LabelLoc =  StartEnd_Idx(i,:);
    LabelStruct(i).LabelTime = [T(StartEnd_Idx(i,1)), T(StartEnd_Idx(i,2))];
    LabelStruct(i).Label = Val(i);
end

end