%iterativeShapeAveraging   perform iterative shape averaging according to
%                          the methods described in paper
%
% [Iave transformMatrix]=iterativeShapeAveraging( I, I_reference,I_mask )
%
%
% Inputs:
%    I - 4D matrix of all images to be used for iterative shape averaging
%    I_reference - reference fish to used for inital positioning of average
%    I_mask - mask image used to mask region included in the registration
% Outputs:
%    I_isa - average image from iterative shape averaging
%    transformMatrix - transformation matrix containing all transformations
%                      used for all images
%--------------------------------------------------------------------------
% This file is part of the XYZ toolbox
%
% Copyright: 2023,  Department of Information Technology,
%                   Uppsala University
%                   Uppsala, Sweden
% License: 
% Contact: a.allalou@gmail.com
% Website: https://github.com/aallalou/align_vessel
%--------------------------------------------------------------------------
function  I_isa =iterativeShapeAveraging( I, I_reference,I_mask )
%If GPU is available it can be turn on for usage with elastix
useGPU = 0;

% Generate gradient image of the reference fish
I_reference_log=single(log(I_reference+1));
 
% initial alignment of all data to the I_reference
for i=1:size(I,4)
    
 
    registration3DElastix(I_reference_log,single(log(I(:,:,:,i)+1)),I_mask,'',...
    'Transform','rigid',...
    'Multires',[4 2  1],...
    'Iterations',[1500 300 300],...
    'Sampling',-1,...
    'ResampleInterpolator','linear',...
    'Interpolator','linear',...
    'Optimizer','regular',...
    'UseGPU',useGPU);
    transformMatrix{i,1}=txt2cell('.\Registration\transformCustom\TransformParameters.0.txt');
    I_transformed(:,:,:,i) = transformix(I(:,:,:,i),  '.\Registration\transformCustom\TransformParameters.0.txt');
end

% Generate average of aligned data
I_isa=mean(I_transformed,4);
I_isaLog=single(log(I_isa(:,:,:,1)+1));

% register to new average
for i=1:size(I,4)
    
    for p=1:1
        cell2txt(['param',num2str(p),'.txt'],transformMatrix{i,p});
    end
    registration3DElastix(I_isaLog,single(log(I(:,:,:,i)+1)),I_mask,['param1.txt'],...
    'Transform','affine',...
    'Multires',[8 4 2],...
    'Iterations',[1500 200 100 ],...
    'Sampling',-1,...
    'ResampleInterpolator','linear',...
    'Interpolator','linear',...
    'UseGPU',useGPU);
    
    transformMatrix{i,2}=txt2cell('.\Registration\transformCustom\TransformParameters.0.txt');
    I_transformed(:,:,:,i) = transformix(I(:,:,:,i),  '.\Registration\transformCustom\TransformParameters.0.txt');
end

% Generate average of aligned data
I_isa(:,:,:,2)=mean(I_transformed,4);
I_isaLog=single(log(I_isa(:,:,:,2)+1));

% register to new average
for i=1:size(I,4)
    
    for p=1:2
        cell2txt(['param',num2str(p),'.txt'],transformMatrix{i,p});
    end
    registration3DElastix(I_isaLog,single(log(I(:,:,:,i)+1)),I_mask,['param2.txt'],...
    'Transform','bspline',...
    'Multires',[6 3 1],...
    'Metric','corr_rigidp',...
    'Iterations',[1000 200 100 ],...
    'Sampling',-1,...
    'ResampleInterpolator','linear',...
    'Interpolator','linear',...
    'Optimizer','regular',...
    'UseGPU',useGPU);
    
    transformMatrix{i,3}=txt2cell('.\Registration\transformCustom\TransformParameters.0.txt');
    I_transformed(:,:,:,i) = transformix(I(:,:,:,i),  '.\Registration\transformCustom\TransformParameters.0.txt');
end

% final iterative shaped average image
I_isa(:,:,:,3)=mean(I_transformed,4);
I_isaLog=single(log(I_isa(:,:,:,3)+1));

% register to new average
for i=1:size(I,4)
    
    for p=1:3
        cell2txt(['param',num2str(p),'.txt'],transformMatrix{i,p});
    end
    registration3DElastix(I_isaLog,single(log(I(:,:,:,i)+1)),I_mask,['param3.txt'],...
    'Transform','bspline',...
    'Multires',[6 3 1],...
    'Metric','corr_rigidp',...
    'Iterations',[1000 200 100 ],...
    'Sampling',-1,...
    'ResampleInterpolator','linear',...
    'Interpolator','linear',...
    'Optimizer','regular',...
    'UseGPU',useGPU);
    
    transformMatrix{i,4}=txt2cell('.\Registration\transformCustom\TransformParameters.0.txt');
    I_transformed(:,:,:,i) = transformix(I(:,:,:,i),  '.\Registration\transformCustom\TransformParameters.0.txt');
end

% final iterative shaped average image
I_isa(:,:,:,4)=mean(I_transformed,4);
I_isaLog=single(log(I_isa(:,:,:,4)+1));
 

 
