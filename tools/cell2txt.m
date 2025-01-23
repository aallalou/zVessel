%cell2txt   writes txt file from a cell array
%
% cell2txt( file,data )
%
%
% Inputs:
%    file - file to write
%    data - cell array to write
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
function cell2txt( file,data )
%Create txt file from matlab cell

fid = fopen(file,'w');
for i=1:numel(data)
    fprintf(fid,'%s\n',data{i});
end
fclose(fid);
end

