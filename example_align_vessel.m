%example_align_vessel   Example file for aligning vessel structures in
%zebrafish
%--------------------------------------------------------------------------
% This file is part of the XYZ toolbox
%
% Copyright: 2023,  Department of Information Technology,
%                   Uppsala University
%                   Uppsala, Sweden
% License: 
% Contact: a.allalou@gmail.com
% Website: https://github.com/aallalou/align_vessel

%% Load data 

data_folder = './data\';
files = dir([data_folder,'*.tif']);

% Resolution of input image
resolutionInput=[0.114,0.114,0.424 ];

% Desired isotropic resolution of output image
resolutionTarget=[0.424 0.424 0.424];

I = []  
for i=1:numel(files)
     
    I_load = imreadMPTiff([files(i).folder,'\',files(i).name]);
    I_load = isoVoxels(I_load,resolutionInput,resolutionTarget,'linear');
    I = cat(4,I,I_load);
end

% Initial reference image
Iref =  I(:,:,:,1);

% Uncomment this section if you want to select your region of interest
% manually
% 
% figure;imshow(max(Iref,[],3),[])
% h = drawfreehand()
% mask = createMask(h)
% close all

% Set the region of interest to exclude 5% at the borders. 
mask = zeros(size(Iref(:,:,1)));
[rows, cols] = size(mask);
rows_indent= round(0.05*rows);
cols_indent= round(0.05*cols);
mask(rows_indent:end-rows_indent,cols_indent:end-cols_indent) = 1;
mask3D = repmat(mask,[1 1 size(I,3)]);

%% run the iterative shape averaging on all wildtype fish
I_isa =iterativeShapeAveraging( I, I(:,:,:,1),mask3D );

imwriteMPTiff(uint8(uint8norm(I_isa(:,:,:,end))),'Iisa.tif')