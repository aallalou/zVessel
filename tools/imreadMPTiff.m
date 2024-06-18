%imreadMPTiff   reads txt file int cell array
%
% I = imreadMPTiff( fname )
%
%
% Inputs:
%    fname - filename of grayscale multipage tiff file
% Outputs:
%    I- output image in format (rows, cols,z-stacks)
%--------------------------------------------------------------------------
% This file is part of the OPT InSitu Toolbox
%
% Copyright: 2023,  Researchlab of electronicss,
%                   Massachusetts Institute of Technology (MIT)
%                   Cambridge, Massachusetts, USA
% License:
% Contact: a.allalou@gmail.com
% Website: https://github.com/aallalou/OPT-InSitu-Toolbox
%--------------------------------------------------------------------------
function I  = imreadMPTiff(fname)

info = imfinfo(fname);
rows = info.Height;
cols = info.Width;


nrFrames = length(info);
I  = zeros(rows,cols,nrFrames,1,'single');

frameCount=1;
for k = 1:nrFrames
    frame = imread(fname,k);
    I(:,:,frameCount)=frame(:,:,1);

    frameCount=frameCount+1;
end
