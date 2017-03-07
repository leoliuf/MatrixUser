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

function MU_funcSubRegion(Temp,Event,handles)
handles = guidata(handles.MU_matrix_display);

defaultSize = [ceil(handles.V.DimSize(2)/2) ceil(handles.V.DimSize(1)/2) 0];

Input = inputdlg({'Please input top left corner [x,y].'; 'Please input size [x,y].'},'Input Value',1, ...
                 {'[1,1]', ['[' num2str(defaultSize(1)) ',' num2str(defaultSize(2)) ']'],'0'});
if isempty(Input)
    warndlg('Displaying sub region was cancelled.');
    return;
end

try
    eval(['Ori=' Input{1} ';']);
    eval(['Size=' Input{2} ';']);
    MU_enable('off',[],handles);
    ROI_h=imrect(handles.Matrix_display_axes, [Ori(1), Ori(2), Size(1), Size(2)]);
%     ROI_h=imrect(handles.Matrix_display_axes, [100, 100, 300, 300]);
    MU_enable('on',[],handles);
catch me
    MU_enable('on',[],handles);
    errordlg('The input value is invalid.');
    return;
end

p=round(getPosition(ROI_h));
if p(1)+p(3)>handles.V.Column | p(2)+p(4)>handles.V.Row | p(1)<1 | p(2)<1
    delete(ROI_h);     
    errordlg('Out of range subscript.');     
    return; 
end

ROI_Stat_h=text(p(1)+p(3),p(2)+p(4),{[' pos:' num2str([p(1), p(2), p(1)+p(3), p(2)+p(4)])]}, ...
                                     'FontSize',10,'Color','g');
handles.V.ROI=struct(...
                     'ROI_flag', 8,...
                     'ROI_mov',[],...  % ROI movement track
                     'ROI_Stat_h', ROI_Stat_h,...    
                     'ROI_h', ROI_h ...
                     );
                 
guidata(handles.MU_matrix_display, handles);
addNewPositionCallback(ROI_h,@(p) MU_ROI_stat(p,ROI_h,[],handles));
fcn=makeConstrainToRectFcn('imrect',[0.5 handles.V.Column+0.4],[0.5 handles.V.Row+0.4]);
setPositionConstraintFcn(ROI_h,fcn);

end