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

function [img mat] = MU_load_nifti(fname)
% Load a NIfTI file in as a matlab marix.
% Supports a 4-D NIfTI File
% Format FUNCTION [img mat] = load_nifti(fname)
%
% Inputs:
%    fname - the name of the .nii file
%
% Outputs:
%    img - a 3d (or 4d) matlab image matrix
%    mat - affine matrix describing voxel size & position
%
% External Requirements: SPM (Tested with SPM8)
% Acknowledge to Samuel A. Hurley

% Check if its a .nii.gz
ftype = 0;

if strcmp(fname(length(fname)-2:length(fname)), '.gz');
  ftype = 1;  % gzipped image
  disp('Unzipping image...');
  eval(['!gunzip ' fname]);
  
  % Change the fname to reflect the un-zipped image
  fname = fname(1:length(fname)-3);
end

% Grab SPM header
D = spm_vol(fname);

% Preallocate img matrix
img = zeros([D(1).dim length(D)]);

% Grab the image
for ii = 1:length(D)
  img(:,:,:,ii) = spm_read_vols(D(ii));
end

% Re-orient the image
img = imflipud(imtranspose(img));

% Grab the mat
mat = D.mat;

% Check if the file needs to be re-zipped
if ftype == 1
  disp('Re-zipping image...');
  eval(['!gzip ' fname]);
end
% Done.

function imout = imtranspose(imin)

% Preallocate, but only for a square image
dims = size(imin);
if dims(1) == dims(2)
  imout = zeros(size(imin));
end

if ndims(imin) == 2
  imout = imin';

% 3-D Image Matrix
elseif ndims(imin) == 3
  zdim = size(imin, 3);

  if zdim == 1
    imout = imin';
  else
    for j = 1:zdim
      imout(:,:,j) = imin(:,:,j)';
    end
  end

% 4-D Image
elseif ndims(imin) == 4
  % Do some recursive magic!
  for ii = 1:size(imin, 4)
    imout(:,:,:,ii) = imtranspose(imin(:,:,:,ii));
  end

% Will we ever do a 5-D image?
else
  error('Does not support 5-D image');
end
  

% Flips a 3-d array in the up/down direction
function flipped = imflipud(im)

flipped = zeros(size(im));

% 3-D
if ndims(im) == 2
  flipped = flipud(im);

elseif ndims(im) == 3
  for j = 1:size(im,3)
    flipped(:,:,j) = flipud(im(:,:,j));
  end
  
% 4-D

elseif ndims(im) == 4
  for ii = 1:size(im, 4)
    flipped(:,:,:,ii) = imflipud(im(:,:,:,ii));
  end
  
else
  error('Does not support 5-D image');
end

