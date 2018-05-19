function LabelStruct = UpdateLabels(handles, Lim1, Lim2)
    %% UpdateLabels
    % Finds the label structure matrix given the current thresholds.
    Labels = double(handles.EIH_vel > Lim1 & handles.Disper > Lim2);
    Labels(Labels == 1) = 3; % Reassign 1 to 3, which is our internal flag for Saccades
    Labels(Labels == 0) = 1; % Reassign 0 to 1, which is our internal flag for fixations
    LabelStruct = GenerateLabelStruct(Labels, handles.T);
    
    if length(handles.ViewPort.Children) > 1
    % Previous Labels do exist
        delete(handles.ViewPort.Children(1:end-1));
    end
    DrawPatches(handles.ViewPort, LabelStruct, 500)
end