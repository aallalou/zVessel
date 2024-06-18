function imwriteMPTiff( I,filename,useCompression)
%IMWRITEMPTIFF Summary of this function goes here
%   Detailed explanation goes here
if ~exist('useCompression','var')
    useCompression = 0;
end
if useCompression
    imwrite(I(:,:,1), filename,'Compression', 'LZW','writemode', 'overwrite' );
    for i=2:size(I,3) 
        imwrite(I(:,:,i), filename,'Compression', 'LZW','writemode', 'append' );
    end
else
    imwrite(I(:,:,1), filename,'writemode', 'overwrite');
    for i=2:size(I,3) 
        imwrite(I(:,:,i), filename,'writemode', 'append' );
    end
end


