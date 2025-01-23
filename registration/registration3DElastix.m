%registration3DElastix   Funtion to call elastix from MATLAB
%
% Iout = registration3DElastix(varargin)
%
% Inputs:
%    varargin - see functoin createElastixParam for function input.
%
% Outputs:
%    Iout - registered image
%
% Example:
%   Igf = registration3DElastix(I_reference,I_float,ones(size(I_reference))>0,'initRot.txt',...
%        'Transform','rigid',...
%        'Multires',[4 3],...
%        'Iterations',[300 200 ],...
%        'Sampling',-1,...
%        'ResampleInterpolator','linear',...
%        'Interpolator','linear',...
%        'Optimizer','regular',...
%        'UseGPU',0);
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
function Iout = registration3DElastix(varargin)
I1 =varargin{1};
I2 = varargin{2};
mask = varargin{3};
t0 = varargin{4};
if numel(varargin)>4
    regParam=varargin(5:end);
else 
    regParam=[];
end
if nargout>0
    regParam=[regParam,{'Result',1}];
end

 
fp = createElastixParam(regParam);
 
outpath = '.\Registration\transformCustom\';
refname= 'ref.vtk';
floatname= 'float.vtk';
maskname= 'mask.vtk';
paramfile = 'Paramters_Custom.txt';

 


 writeVTKRGB(single(I1),refname);
 writeVTKRGB(single(I2),floatname);
 writeVTKRGB(uint8(mask),maskname);
 

%    
cmd = ['.\3rdparty\elastix-5.0.0-win64\elastix '...
   '-f ',refname,' ',...
   '-m ',floatname,' ',...
   '-out ',outpath,' ',...
   '-p ',outpath,paramfile,' ',...
   '-fMask ',maskname,' '...
   ];
   
if exist('t0','var')
    if t0~=0
        cmd=strcat(cmd,[' ','-t0 ',t0]);
    end
end
if fp
       cmd=strcat(cmd,[' -fp ',outpath,'\fixedlandmarks.txt',' ']);
end    
system(cmd);

if nargout>0
    Iout=readVTK([outpath,'result.0.vtk']);
else
    Iout =0;
end
end
