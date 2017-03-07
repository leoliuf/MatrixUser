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

function MU_changeRes(Temp,Event,h)

Xf=str2num(get(h.Xf_v,'String'));
Yf=str2num(get(h.Yf_v,'String'));
Zf=str2num(get(h.Zf_v,'String'));
Methods={'linear';'nearest';'cubic'};
Method=Methods{get(h.Method,'Value')};

delete(h.Set_Res);
pause(0.1);

MU_update_waitbar(h.main_h.Progress_axes,1,3);

[row,col,lay]=size(h.main_h.TMatrix);
try
    [x,y,z]=meshgrid(linspace(1,col,round(col*Xf)),linspace(1,row,round(row*Yf)),linspace(1,lay,round(lay*Zf)));
    if isempty(x)
        MU_update_waitbar(h.main_h.Progress_axes,3,3);
        errordlg('Input value is invalid');
        return;
    end
catch me
    MU_update_waitbar(h.main_h.Progress_axes,3,3);
    errordlg('Input value is invalid');
    return;
end
MU_update_waitbar(h.main_h.Progress_axes,2,3);

if numel(h.main_h.V.DimSize)==3
    try % try to use ba_interp3 as default
        TTMatrix=ba_interp3(double(h.main_h.TMatrix),x,y,z,Method);
    catch me % if not, try to compile it first
        try
            disp('Compiling ba_interp3 ...');
            ba_interp3_folder=[h.main_h.path filesep '..' filesep 'External' filesep 'ba_interp3'];
            eval(['mex -O ' char(39) [ba_interp3_folder filesep 'ba_interp3.cpp' char(39)] ' -output ' [char(39) ba_interp3_folder filesep 'ba_interp3' char(39)]]);
            disp('Compiling ba_interp3 finished successfully. Use ba_interp3 for interpolation.');
            pause(1);
            TTMatrix=ba_interp3(double(h.main_h.TMatrix),x,y,z,Method);
        catch me
            warndlg('Compiling ba_interp3 failed, use default matlab interp3.');
            TTMatrix=interp3(double(h.main_h.TMatrix),x,y,z,Method);
        end
    end
else
    TTMatrix=interp2(double(h.main_h.TMatrix),x,y,Method);
end

TTMatrix=cast(TTMatrix,class(h.main_h.TMatrix));
MU_update_waitbar(h.main_h.Progress_axes,3,3);

MatrixName=get(h.main_h.Matrix_name_edit,'String');
if ~MU_load_matrix([MatrixName '_itp'], TTMatrix, 1)
    errordlg('Matrix interpolation failed!');
end

end