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

%Create 3D rendering
function MU_update_3D_render(axes_handle,h,flag)
    
Show_threshold=h.V.Show_threshold;
Show_opacity=h.V.Show_opacity;
Show_connectivity=h.V.Show_connectivity;

switch flag
    case 1 % thresholding
        %------------------------------------------Volume Check
        L=zeros(size(h.TMatrix));
        L(h.TMatrix>=Show_threshold)=1;
        
        if h.V.ConnectFlag
            [L,num]=bwlabeln(L);
            h.idxSize=zeros(num,1);
            for i=1:num
                idx=find(L==i);
                h.idxSize(i)=length(idx);
                if length(idx)>=Show_connectivity
                    L(idx)=1;
                else
                    L(idx)=0;
                end
                MU_update_waitbar(h.Progress_axes,i,num);
            end
        end
        
        h.idxMask=L.*h.TMatrix;
        guidata(axes_handle,h);
        %------------------------------------------End
    case 2 % colormap
        colormap(h.V.Color_map);
        guidata(axes_handle,h);
        return;
    case 3 % red surface
        try
            set(h.V.p,'FaceColor',h.V.FaceColor);
        catch me
            eval(['FaceColor=' h.V.FaceColor ';']);
            set(h.V.p,'FaceColor',FaceColor);
        end
        guidata(axes_handle,h);
        return;
    case 4 % box
        box(axes_handle,h.V.BoxFlag);
        guidata(axes_handle,h);
        return;
    otherwise % others
        % do nothing
end
set(h.MaxCon_text,'string',['@' num2str(max(h.idxSize))]);
%------------------------------------------Rendering

cla(axes_handle);
axes(axes_handle);
h.V.p=patch(isosurface(h.idxMask,Show_threshold,'noshare'),'EdgeColor','none');
try
    set(h.V.p,'FaceColor',h.V.FaceColor);
catch me
    eval(['FaceColor=' h.V.FaceColor ';']);
    set(h.V.p,'FaceColor',FaceColor);
end
h.V.pp=patch(isocaps(h.idxMask,Show_threshold),'FaceColor','interp','EdgeColor','none');
set(h.V.pp,'AmbientStrength',0.6);
set(h.V.p,'SpecularColorReflectance',0,'SpecularExponent',50);
if h.V.PatchPercent~=1
    reducepatch(h.V.p,h.V.PatchPercent);
    reducepatch(h.V.pp,h.V.PatchPercent);
end
isocolors(h.TMatrix,h.V.p);
isocolors(h.TMatrix,h.V.pp);
isonormals(h.idxMask,h.V.p);
% isonormals(h.idxMask,h.V.pp);
alpha(Show_opacity);

% set(axes_handle,'YDir','rev');
zlabel(axes_handle,'Z');
xlabel(axes_handle,'X');
ylabel(axes_handle,'Y');

view(h.V.Viewpoint);
daspect(h.V.AspectRatio);
lightangle(h.V.Viewpoint(1),h.V.Viewpoint(2));
lighting phong;

box(axes_handle,h.V.BoxFlag);
colormap(h.V.Color_map);
colorbar;
axis ([1 h.V.Column 1 h.V.Row 1 h.V.Layer h.V.Min_D h.V.Max_D]);
% axis tight;
%------------------------------------------End
guidata(axes_handle,h);

if Show_connectivity > max(h.idxSize)
    warndlg('No object will be rendered, consider reduce connectivity value or threshold value.');
end

end