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

%Convert DICOM-files to Matlab Matrix (orignally designed for Siemens MR scanner)
function [created_matrix,created_matrix_name,errflag]=MU_DICOM2Mat(filename,pathname,handles)
    
    created_matrix_name=[];
    if isempty(get(handles.Selected_file_list,'String'))
        errordlg('Please choose DICOM file(s) for creating matrix.');
        created_matrix=[];
        errflag=1;
        return;
    elseif isempty(get(handles.Edit_matrix_name,'String'))
        errordlg('Please provide a name for the matrix.');
        created_matrix=[];
        errflag=1;
        return;
    end
    
    try
        if iscell(filename)
            filenum=max(size(filename));
        else
            filenum=1;
            filename={filename};
        end
        for i=1:filenum
            created_matrix(:,:,i)=dicomread([pathname filename{i}]);
            if i==1
                tMx=created_matrix;
                tSize=size(tMx);
                created_matrix=zeros(tSize(1),tSize(2),filenum);
                created_matrix = cast(created_matrix, class(tMx)); % convert back to whatever original
                created_matrix(:,:,1)=tMx;
            end
            
            MU_update_waitbar(handles.DICOM_file_processing_waitbar_axes,i,filenum);
        end
%         created_matrix=double(created_matrix);
    catch me
        set(handles.DICOM_file_processing_waitbar_axes,'Visible','off');
        axes(handles.DICOM_file_processing_waitbar_axes);
        cla;

        errordlg('Ooops!!! DICOM files mismatch, conversion aborts.');
        errflag=1;
        return;
    end
    
    created_matrix_name=get(handles.Edit_matrix_name,'String');
    
    try
        eval([created_matrix_name '= 1;']);
    catch me
        errordlg('The input name is an invalid matlab name.');
        errflag = 1; % fail
        set(handles.DICOM_file_processing_waitbar_axes,'Visible','off');
        axes(handles.DICOM_file_processing_waitbar_axes);
        cla;
        return;
    end
    
    set(handles.Conversion_procedure_text,'String', 'Ready to go !!!');
    set(handles.Selected_file_list,'String', []);
    set(handles.Selected_file_list,'Value', 1);
    set(handles.Edit_matrix_name,'String', []);

    set(handles.DICOM_file_processing_waitbar_axes,'Visible','off');
    axes(handles.DICOM_file_processing_waitbar_axes);
    cla;

    errflag=0;

end