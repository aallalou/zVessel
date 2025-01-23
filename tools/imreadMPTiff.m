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
% This file is part of the zVessel toolbox
%
% Copyright: 2023,  Department of Information Technology,
%                   Uppsala University
%                   Uppsala, Sweden
% License: 
% Contact: a.allalou@gmail.com
% Website: https://github.com/aallalou/zVessel
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
