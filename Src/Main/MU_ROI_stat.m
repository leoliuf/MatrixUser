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

function MU_ROI_stat(p,ROI_h,ROI_ind,handles)
global Figure_handles;
MU_main_handles=guidata(Figure_handles.MU_main);

if handles.V.ROI.ROI_flag==5 % line ROI
    p=getPosition(ROI_h);
    set(handles.V.ROI.ROI_Stat_h,'position',[p(2),p(4)],'string',{['length: ' num2str(round(sqrt(((p(2)-p(1))^2+(p(4)-p(3))^2)))) ' p']});
elseif handles.V.ROI.ROI_flag==6 % line profile
    p=round(getPosition(ROI_h));
    p0=p;
    BW=createMask(ROI_h); 
    p=[min(p(:,1)) min(p(:,2)) max(p(:,1))-min(p(:,1)) max(p(:,2))-min(p(:,2))];
    dp=p0(1,:)-p(1:2)+1;
    TTMatrix=handles.BMatrix(p(2):p(2)+p(4),p(1):p(1)+p(3));
    TTMatrix=TTMatrix(double(BW(p(2):p(2)+p(4),p(1):p(1)+p(3)))~=0);
    TTMatrix=double(TTMatrix);
    
    [I,J] = ind2sub(size(BW(p(2):p(2)+p(4),p(1):p(1)+p(3))),find(BW(p(2):p(2)+p(4),p(1):p(1)+p(3))~=0));
    Dist=sqrt((I-repmat(dp(2),size(I))).^2+(J-repmat(dp(1),size(J))).^2); % distance, assume square pixel
    [DistS,ind]=sort(Dist(:));

    plot(handles.V.ROI.ROI_Stat_h,DistS,TTMatrix(ind));
    grid(handles.V.ROI.ROI_Stat_h,'on');
    ylabel(handles.V.ROI.ROI_Stat_h,'Voxel Value','FontSize',10);
    xlabel(handles.V.ROI.ROI_Stat_h,'Voxel Distance','FontSize',10);
elseif handles.V.ROI.ROI_flag==7 % angle
    p=getPosition(ROI_h);
    p2=circshift(p,[1,0]);
    p3=circshift(p,[-1,0]);
    dp=p-p2;
    dp2=p-p3;
    for i=1:length(p(:,1))
        theta = acos(dot(dp(i,:),dp2(i,:))./(norm(dp(i,:)).*norm(dp2(i,:))))*180/pi;
        set(handles.V.ROI.ROI_Stat_h(i),'position',[p(i,1),p(i,2)],'string',{['Angle: ' num2str(theta)]},'FontSize',10,'Color','g');
    end
elseif handles.V.ROI.ROI_flag==8 % sub region
    p=round(p);
    if min(size(p))~=1
        p=[min(p(:,1)) min(p(:,2)) max(p(:,1))-min(p(:,1)) max(p(:,2))-min(p(:,2))];
    end
    set(handles.V.ROI.ROI_Stat_h,'position',[p(1)+p(3),p(2)+p(4)],'string',{[' pos:' num2str([p(1), p(2), p(1)+p(3), p(2)+p(4)])]});
    num2str([p(1), p(2), p(1)+p(3), p(2)+p(4)])
else
    p=round(p);
    if min(size(p))~=1
        p=[min(p(:,1)) min(p(:,2)) max(p(:,1))-min(p(:,1)) max(p(:,2))-min(p(:,2))];
    end
    BW=createMask(ROI_h); 
    TTMatrix=handles.BMatrix(p(2):p(2)+p(4),p(1):p(1)+p(3));
    TTMatrix=TTMatrix(double(BW(p(2):p(2)+p(4),p(1):p(1)+p(3)))~=0);
    handles.ROIData=TTMatrix;
    set(handles.V.ROI.ROI_Stat_h,'position',[p(1)+p(3),p(2)+p(4)],'string',{[' ROI#: ' num2str(ROI_ind)]; ...
                                                                            [' mean: ' num2str(mean(double(TTMatrix(:))))]; ...
                                                                            [' sd:' num2str(std(double(TTMatrix(:))))]; ...
                                                                            [' sd(%):' num2str(abs(std(double(TTMatrix(:)))./mean(double(TTMatrix(:))))*100)]});
    MU_main_handles.V.ROIs{ROI_ind,3}=getPosition(ROI_h);
end
guidata(handles.MU_matrix_display, handles);
guidata(Figure_handles.MU_main,MU_main_handles);