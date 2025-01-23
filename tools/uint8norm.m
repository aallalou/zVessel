%uint8norm   normalize data to 8bit
%
% I=uint8norm(I)
%
% Inputs:
%    I - Image before normalization
% Outputs:
%    I - Image normalized to 8bit
%
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
function I=uint8norm(I)
I=single(I);
Imax=max(I(:));
Imin=min(I(:));

I=(I-Imin)/(Imax-Imin)*255;

