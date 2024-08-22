%--------------------------------------------------------------------------
% This file is part of the tool zVessel
%
% Copyright: 2024   Department of information technology 
%                   Uppsala University
%                   Uppsala, Sweden
%
% License: GNU General Public License v3.0
% Contact: a.allalou@gmail.com
% Website: https://github.com/aallalou/zVessel
% If you use the zVessel for your research, we would appreciate 
% if you would refer to the following paper:
%
% -XYXY.
%
%--------------------------------------------------------------------------

The major part of the code is written in MATLAB. The open source registration
toolbox elastix (https://elastix.lumc.nl/) is used for registration and 
DIPimage (http://www.diplib.org/) is used in various places in the repository.  

This code shows the basic workflow of the the alignment of vessels in zebrafish.
To run an example run the script example_algin_vessel.m. This script will align 
the sample data in the folder ./data using an iterative registration workflow. 


 

System requirements
-------------------
Windows 7/8/10/11
Minimum RAM: 16GB RAM

License
-------
All code except the 3rd party code is coverd by the LICENSE.txt file. 
Files and folders covered by the LICENSE.txt file. 
example_align_vessel.m

\registration
\tools



3rd Party
---------
All 3rd party code is placed in a separate folder and is not covered by the LICENSE.txt file.
All 3rd party code is covered by their respective license. 


*******readVTK and writeVTKRGB ************************************
Both functions are modified version of code written by Erik Vidholm
Center for Image Analysis, Uppsala University, Sweden
Erik Vidholm 2005
Erik Vidholm 2006
*******************************************************************

References:
------------

If you use any part of this code for your research, we 
would appreciate it if you would refer to the following paper:

"Method to computationally average confocal images of zebrafish lymphatic vessels to identify phenotypes 
Hannah Arnold, Virginia Panara, Amin Allalou, Katarzyna Koltowska.
 
