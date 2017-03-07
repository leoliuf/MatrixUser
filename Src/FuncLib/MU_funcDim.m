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

function MU_funcDim(Temp,Event,handles)
handles = guidata(handles.MU_matrix_display);

dim = inputdlg(['Please specify which dimension to inspect (1 ~ ' num2str(numel(handles.V.DimSize)) ').'],'Specify Dimension',1,{'1'});
if isempty(dim)
    warndlg('Cancel dimension profile inspection.');
    return;
end

try % test for dimension info
    dim=str2double(dim{1});
    if dim<1 | dim> numel(handles.V.DimSize) | dim~=round(dim)
        error('Wrong dimension input!');
    end
catch me
    error_msg{1,1}='ERROR!!! dimension profile inspection aborted.';
    error_msg{2,1}=me.message;
    errordlg(error_msg);
    return;
end

Plot_handle=MU_Plot;
set(Plot_handle,'Name', 'Dimension Profile at Current Cursor Position');
Plot_handles=guidata(Plot_handle);
VLine=Plot_handles.Plot_axes;
handles.KFlag=1;
handles.KDim(end+1)=dim;
handles.KCurve{end+1}=zeros(1,handles.V.DimSize(dim));
handles.KHandle(end+1)=plot(VLine,1:handles.V.DimSize(dim),handles.KCurve{end},'o-','MarkerFaceColor','green','Color','green',...
                      'LineWidth',2,'MarkerSize',5,'YDataSource',['handles.KCurve{' num2str(numel(handles.KDim)) '}']);

set(VLine,'Color','black','FontSize',10);
axis(VLine,[1 handles.V.DimSize(dim) handles.V.Min_D handles.V.Max_D]);
ylabel(VLine,'Voxel Value','FontSize',10);
xlabel(VLine,['Dimension ' num2str(dim)],'FontSize',10);
set(VLine,'XGrid','on','XColor',[255 128 64]./255);
axes(handles.Matrix_display_axes);

guidata(handles.MU_matrix_display, handles);

end