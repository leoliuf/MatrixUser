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

function MU_update_dim_control(handles, dimSize)

% refresh dimension tabgroup
if isfield(handles,'MDimension_tabgroup')
    tabs=get(handles.MDimension_tabgroup,'Children');
    for i=1:length(tabs)
        delete(get(tabs(i),'Children'));
    end
    delete(handles.MDimension_tabgroup);
    handles = rmfield(handles,'MDimension_tabgroup');
end

% initialize dimension tabgroup
if  numel(dimSize)> 2
    handles.MDimension_tabgroup=uitabgroup(handles.MDimension_uipanel);
    for i=3:numel(dimSize)
        
        handles.(['MDim' num2str(i) '_tab'])=uitab( handles.MDimension_tabgroup,'title',['Dim' num2str(i)] ,'Units','normalized');
        handles.(['Dim' num2str(i) '_edit'])=uicontrol(handles.(['MDim' num2str(i) '_tab']),'Style', 'edit','Units','normalized','BackgroundColor',[1 1 1],...
            'Position', [0.81 0 0.1 1],'TooltipString',['Matrix Dimension ' num2str(i)],'string',1,'Enable','off');
        handles.(['Dim' num2str(i) '_text'])=uicontrol(handles.(['MDim' num2str(i) '_tab']),'Style', 'text','Units','normalized','BackgroundColor',[1 1 1],...
            'Position', [0.91 0 0.08 1],'string',['/' num2str(dimSize(i))]);
        if dimSize(i) > 1
            set(handles.(['Dim' num2str(i) '_edit']),'Enable','on');
            handles.(['Dim' num2str(i) '_slider'])=uicontrol(handles.(['MDim' num2str(i) '_tab']),'Style', 'slider','Units','normalized','BackgroundColor',[1 1 1],...
                'Position', [0.01 0 0.8 1],'TooltipString',['Matrix Dimension ' num2str(i)],...
                'Value',1,'Min',1,'Max',dimSize(i),'SliderStep',[1/dimSize(i), 4/dimSize(i)]);
            set(handles.(['Dim' num2str(i) '_slider']),'Callback',{@MU_linkSliderEditDim,handles.(['Dim' num2str(i) '_slider']),handles.(['Dim' num2str(i) '_slider']),handles.(['Dim' num2str(i) '_edit']),i});
            set(handles.(['Dim' num2str(i) '_edit'])  ,'Callback',{@MU_linkSliderEditDim,handles.(['Dim' num2str(i) '_edit']),handles.(['Dim' num2str(i) '_slider']),handles.(['Dim' num2str(i) '_edit']),i});
        end
    end
end

% turn off uitab warning
warning('off');
guidata(handles.MU_matrix_display, handles);

end