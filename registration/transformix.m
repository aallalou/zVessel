%uint8norm   Funtion to call transformix from matlab
%
% varargout = transformix(I,transform,varargin)
%
% Inputs:
%    I - Image to transform
%    transform - Can be txt file with elastix transformation or a cell
%                array with elastix transformation information
%    varagin - can be set to 'gpu' to use gpu for transformation
% Outputs:
%    Iout - transformed image
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
function Iout = transformix(I,filename,varargin)
useGPU =  any(cell2mat(strfind(varargin, 'gpu')));

if iscell(filename)
    if useGPU
        for p=1:numel(filename)
            cell2txt(['param',num2str(p),'.txt'], setGPUTransform(filename{p}));
        end
    else
        for p=1:numel(filename)
            cell2txt(['param',num2str(p),'.txt'],  filename{p});
        end
    end
    filename = ['param',num2str(p),'.txt'];
end
 
outpath = '.\Registration\transformCustom\';
imname= 'im1.vtk';

writeVTKRGB(single(I),imname); 
cmd =   ['.\3rdparty\elastix-5.0.0-win64\transformix '...
        '-out ',outpath,' ',...
        '-tp ',filename,' ',...
        ]
cmd = strcat(cmd,[' -in ',imname,' '])
 
try
    system(cmd);
    Iout=readVTK([outpath,'result.vtk']);
catch
    error('Error in transformation')
end

end
 