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

function MU_update_func_control(handles)

% if isfield(handles,'Function_tabgroup')
%     return;
% end

% refresh function tabgroup
if isfield(handles,'Function_tabgroup')
    tabs=get(handles.Function_tabgroup,'Children');
    for i=1:length(tabs)
        delete(get(tabs(i),'Children'));
    end
    delete(handles.Function_tabgroup);
    handles = rmfield(handles,'Function_tabgroup');
end

% initialize function bench tabgroup
handles.Function_tabgroup=uitabgroup(handles.Function_uipanel);
handles.FuncStruct=MU_parseXML([handles.path filesep '..' filesep 'FuncLib' filesep 'FuncLib.xml']);
for i=1:numel(handles.FuncStruct.Children)
    handles.(['Func_' handles.FuncStruct.Children(1,i).Name '_tab'])=uitab( handles.Function_tabgroup,'title',handles.FuncStruct.Children(1,i).Name,'Units','normalized');
    s=1; % loop counter for function button
    for j=1:numel(handles.FuncStruct.Children(1,i).Children)
        if strcmp(handles.FuncStruct.Children(1,i).Children(1,j).Attributes(1,4).Value(1),'@') % dimension only sign @
            if numel(handles.V.DimSize)~= str2num(handles.FuncStruct.Children(1,i).Children(1,j).Attributes(1,4).Value(2:end))
                continue;
            end
        else
            if numel(handles.V.DimSize)> str2num(handles.FuncStruct.Children(1,i).Children(1,j).Attributes(1,4).Value)
                continue;
            end
        end
        pushbutton_handle= uicontrol(handles.(['Func_' handles.FuncStruct.Children(1,i).Name '_tab']),'Style', 'pushbutton','Units','normalized',...
                                    'Position', [(s-1)*0.06+0.01 0 0.06 0.9],'TooltipString',handles.FuncStruct.Children(1,i).Children(1,j).Attributes(1,2).Value);  % create pushbutton
        
        MU_icon(pushbutton_handle,[handles.path filesep '..' filesep '..' filesep 'Resource' filesep 'Icon' filesep handles.FuncStruct.Children(1,i).Children(1,j).Attributes(1,3).Value]); % load icon
        
        eval(['set(pushbutton_handle, ''Callback'',{@' handles.FuncStruct.Children(1,i).Children(1,j).Attributes(1,1).Value ',handles});']); % map callback function
        
        handles.(['Func_' handles.FuncStruct.Children(1,i).Name '_' handles.FuncStruct.Children(1,i).Children(1,j).Name '_pushbutton']) = pushbutton_handle;
        s=s+1;
    end
end

% turn off uitab warning
warning('off');
guidata(handles.MU_matrix_display, handles);

end