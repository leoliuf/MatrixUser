% MatrixUser, a multi-dimensional matrix analysis software package
% https://sourceforge.net/projects/matrixuser/
% 
% The MatrixUser is a matrix analysis software package developed under Matlab
% Graphical User Interface Developing Environment (GUIDE). It features 
% functions that are designed and optimized for working with multi-dimensional
% matrix under Matlab. These functions typically includes functions for 
% multi-dimensional matrix display, matrix (image stack) analysis and matrix 
% processing.
%
% Author:
%   Fang Liu <leoliuf@gmail.com>
%   University of Wisconsin-Madison
%   Aug-30-2014
% _________________________________________________________________________
% Copyright (c) 2011-2014, Fang Liu <leoliuf@gmail.com>
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.
% _________________________________________________________________________

function MU_funcRotate(Temp,Event,handles)
handles=guidata(handles.MU_matrix_display);

if ~isempty(handles.V.Segs)
    choice = questdlg('Segmentation mask is detected, transform operation will reset them, preceed?','Mask Reset', ...
                      'No, go save mask','Yes','No, go save mask');
    if isempty(choice)
        warndlg('Transform is cancelled.');
        return;
    end
    % Handle response
    switch choice
        case 'No, go save mask'
            warndlg('Save your mask before transform.');
            return;
    end
    
    handles.Mask=handles.Mask*0;
    handles.V.Segs=[];
end
% close 3D slicer
global Figure_handles
if isfield(Figure_handles,'MU_display2')
    slicer_display_handles=guidata(Figure_handles.MU_display2);
    if Figure_handles.MU_display == slicer_display_handles.Parent
        close(Figure_handles.MU_display2);
    end
end

if numel(handles.V.DimSize) == 3
    defaultOrigin = [ceil(handles.V.DimSize(2)/2) ceil(handles.V.DimSize(1)/2) ceil(handles.V.DimSize(3)/2)];
else
    defaultOrigin = [ceil(handles.V.DimSize(2)/2) ceil(handles.V.DimSize(1)/2) 0];
end

Input = inputdlg({'Please input a rotation origin [x,y,z].'; 'Please input a rotation axis [x,y,z].'; 'Please input a rotation angle (rad).'},'Input Value',1, ...
                 {['[' num2str(defaultOrigin(1)) ',' num2str(defaultOrigin(2)) ',' num2str(defaultOrigin(3)) ']'],'[0,0,1]','0'});
if isempty(Input)
    warndlg('Matrix rotation was cancelled.');
    return;
end

[Type,ok] = listdlg('ListString',{'Nearest','Linear','Cubic'}, ...
                    'SelectionMode','single',...
                    'PromptString','Interpolation Method',...
                    'Name','Interpolation');
if ok==0
    warndlg('Matrix rotation was cancelled.');
    return;
end

switch Type
    case 1
        interp = 'nearest';
    case 2
        interp = 'linear';
    case 3
        interp = 'cubic';
end

try
    MU_update_waitbar(handles.Progress_axes,1,3);
    pause(0.1);
    eval(['Ori=' Input{1} ';']);
    eval(['Axis=' Input{2} ';']);
    eval(['Angle=' Input{3} ';']);
    if Angle==0
        MU_update_waitbar(handles.Progress_axes,3,3);
        return;
    end
    [T, R]=rotate3DT_MU(Ori, Axis, Angle,interp);
    handles.TMatrix =rotate3D(handles.TMatrix, T, R);
    MU_update_waitbar(handles.Progress_axes,2,3);
    handles.Mask =round(rotate3D(handles.Mask, T, R));
    MergeM=get(handles.Matrix_name_edit,'String');
    set(handles.Matrix_name_edit,'String',[MergeM '_rot']);
    handles=MU_update_image(handles.Matrix_display_axes,{handles.TMatrix,handles.Mask},handles,0);
    MU_update_waitbar(handles.Progress_axes,3,3);
catch me
    errordlg('The input rotation value is invalid.');
    return;
end

guidata(handles.MU_matrix_display, handles);

end