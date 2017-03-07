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

function MU_MIP(h)


dim = inputdlg(['Please specify which dimension to perform projection (1 ~ ' num2str(numel(h.V.DimSize)) ').'],'Specify dimension',1,{num2str(min(3,numel(h.V.DimSize)))});
if isempty(dim)
    warndlg('Projection was cancelled.');
    return;
end

[Selection,ok] = listdlg('ListString',{'Max Intensity','Min Intensity','Average Intenstity','Sum Slices','Median Intensity','Standard Deviation'}, ...
                         'SelectionMode','single',...
                         'PromptString','Projection Methods',... 
                         'Name','Projection');
if ok==0
    Selection = 1;
    warndlg('Max intensity projection is used.');
end

try
    switch Selection
        case 1
            eval(['TMatrix=max(h.TMatrix,[],' dim{1} ');']);
        case 2
            eval(['TMatrix=min(h.TMatrix,[],' dim{1} ');']);
        case 3
            eval(['TMatrix=mean(h.TMatrix,' dim{1} ');']);
        case 4
            eval(['TMatrix=sum(h.TMatrix,' dim{1} ');']);
        case 5
            eval(['TMatrix=median(h.TMatrix,' dim{1} ');']);
        case 6
            eval(['TMatrix=cast(std(double(h.TMatrix),0,' dim{1} '),class(h.TMatrix));']);
    end
    msize = size(TMatrix);
    if length(msize) > 2
        msize(msize==1) = [];
        msize = [ num2str(msize(1)) num2str(msize(2:end),',%d')];
        eval(['TMatrix=reshape(TMatrix,[' msize ']);']);
    end
catch me
    errordlg('The input dimension is invalid.');
    return;
end

MatrixName=get(h.Matrix_name_edit,'String');

if ~MU_load_matrix([MatrixName '_prj'], TMatrix, 1)
    errordlg('Projection failed!');
end

end