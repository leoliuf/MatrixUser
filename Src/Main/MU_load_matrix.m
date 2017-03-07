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

% load matrix to base workspace
% open a new display with given matrix and matrix name if newWindowOpenFlag=1

function Flag=MU_load_matrix(matrixName, matrix, newWindowOpenFlag)

matrixList = evalin('base', 'who');
if ~isempty(matrixList)
    currentFlag=strcmp(matrixList,matrixName);
    if sum(currentFlag)~=0 % existing matrix 
       newName = inputdlg([char(39) matrixName ''' already exists in the base workspace. Input NEW matrix name, otherwise will overwrite existing matrix.'],'Overwrite',1,{matrixName});
       if isempty(newName)
           warndlg('Matrix name input was cancelled. You must provide an matrix name.');
           Flag = 0; % fail
           return;
       end
       if ~isempty(newName)
           matrixName = newName{1};
       end
    end
end

inputFlag=1;
while inputFlag==1
    try
        eval([matrixName '= 1;']);
        inputFlag = 0;
    catch me
        newName = inputdlg('The input name is invalid. Please input a valid matlab name.','Invalid Name',1,{matrixName});
        if isempty(newName)
            warndlg('Matrix name input was cancelled. You must provide an matrix name.');
            Flag = 0; % fail
            return;
        end
        if ~isempty(newName)
            matrixName = newName{1};
        end
    end
end

try
    assignin('base', matrixName, matrix);
catch me
    error_msg{1,1}='ERROR!!! Matrix creation aborted.';
    error_msg{2,1}=me.message;
    errordlg(error_msg);
    Flag = 0; % fail
    return;
end
display([char(39) matrixName ''' has been created in the base workspace.']);
Flag = 1; % OK

if newWindowOpenFlag
    if isreal(matrix)
        MU_Matrix_Display(matrixName,'Real');
    else
        MU_Matrix_Display(matrixName,'Magnitude');
        MU_Matrix_Display(matrixName,'Phase');
    end
end

end