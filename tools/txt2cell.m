%txt2cell   reads txt file int cell array
%
% data = txt2cell( file )
%
%
% Inputs:
%    file - text file to read
% Outputs:
%    data - output cell array
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
function data = txt2cell( file )
%Import txt file to matlab cell

fid = fopen(file);
data = textscan(fid,'%s','Delimiter','\n');
data=data{1};
fclose(fid);
end

