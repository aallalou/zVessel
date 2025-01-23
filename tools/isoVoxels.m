 
%--------------------------------------------------------------------------
% This file is part of the zVessel toolbox
%
% Copyright: 2023,  Department of Information Technology,
%                   Uppsala University
%                   Uppsala, Sweden
% License: 
% Contact: a.allalou@gmail.com
% Website: https://github.com/aallalou/zVessel
%--------------------------------------------------------------------------
function Iiso = isoVoxels(I,resolutionInput,resolutionTarget,interp)
% correct for resolution diff between xy plane and z axis
Im = single(squeeze(I));
szD_a=size(Im);          % get size of original image stack
vox_a = resolutionInput;  % define size of voxel in original image stack
vox_b = resolutionTarget;% define size of voxel in target image stack
szD_b = ceil((size(Im)-1).*vox_a./vox_b)+1; % set size of target image stack

% define coordinates of voxels in original image stack
[Xa,Ya,Za]=(meshgrid(...
    [0:szD_a(2)-1]*vox_a(2),...
    [0:szD_a(1)-1].*vox_a(1),...
    [0:szD_a(3)-1].*vox_a(3)));
Xa=single(Xa);
Ya=single(Ya);
Za=single(Za);
% define coordinates of voxels in original image stack
[Xb,Yb,Zb]=meshgrid(...
    [0:szD_b(2)-1]*vox_b(2),...
    [0:szD_b(1)-1].*vox_b(1),...
    [0:szD_b(3)-1].*vox_b(3));
Xb=single(Xb);
Yb=single(Yb);
Zb=single(Zb);

Iiso = interp3(Xa,Ya,Za,Im,Xb,Yb,Zb,interp);
Iiso(isnan(Iiso))=0;
Iiso(isinf(Iiso))=0;