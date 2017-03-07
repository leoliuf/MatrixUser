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


% load license file
function varargout = MU_Licensing(varargin)
% MU_LICENSING MATLAB code for MU_Licensing.fig
%      MU_LICENSING, by itself, creates a new MU_LICENSING or raises the existing
%      singleton*.
%
%      H = MU_LICENSING returns the handle to a new MU_LICENSING or the handle to
%      the existing singleton*.
%
%      MU_LICENSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MU_LICENSING.M with the given input arguments.
%
%      MU_LICENSING('Property','Value',...) creates a new MU_LICENSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MU_Licensing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MU_Licensing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MU_Licensing

% Last Modified by GUIDE v2.5 04-Feb-2014 14:43:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MU_Licensing_OpeningFcn, ...
                   'gui_OutputFcn',  @MU_Licensing_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MU_Licensing is made visible.
function MU_Licensing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MU_Licensing (see VARARGIN)

handles.Simuh=varargin{1};

%----load license text
fid=fopen([handles.Simuh.path filesep '..' filesep 'License.txt'],'r');
if fid==-1
    set(handles.Licensing_edit,'String','License file is missing!');
else
    tline = fgetl(fid);
    i=1;
    while ischar(tline)
        Memo{i,1}=tline;
        tline = fgetl(fid);
        i=i+1;
    end
    if i==1
        set(handles.Licensing_edit,'String','License file is empty!');
    else
        set(handles.Licensing_edit,'String',Memo);
    end
    
    fclose(fid);
end
%----end

% Choose default command line output for MU_Licensing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MU_Licensing wait for user response (see UIRESUME)
% uiwait(handles.MULicensing_figure);


% --- Outputs from this function are returned to the command line.
function varargout = MU_Licensing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Licensing_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Licensing_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Licensing_edit as text
%        str2double(get(hObject,'String')) returns contents of Licensing_edit as a double


% --- Executes during object creation, after setting all properties.
function Licensing_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Licensing_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
