%OUT = COMPUTE2(OPERATION,IN1,IN2,OUT_DIP_TYPE)
%    This is the basis function for all the overloaded binary operators.
%    OUT_DIP_TYPE is optional, and can be used to overrule the output
%    type generated by the operation. OUT_DIP_TYPE is either a specific
%    DIPlib data type, or one of: 'forcedouble' or 'keepsame'.

% (C) Copyright 1999-2013, Cris Luengo.
% Centre for Image Analysis, Uppsala, Sweden.
%
% Cris Luengo, June 2011, based on the original DO2INPUT, COMPUTE2, and 
%                    COMPUTE2ARRAY.
% 26 September 2011: Calling 'dip_*' operations directly, they handle any
%                    data type.
% 28 September 2012: Not calling 'dip_*' operations if one of the inputs
%                    is an empty image.
% 24-25 May 2013:    Operations between an image and a scalar value are now computed
%                    correctly, but the output type will not be affected by the type
%                    of the scalar value. Using new function DIP_ARITH.
% 23 September 2013: Fixed: previous change caused operation between a binary and a
%                    scalar to yield a binary rather than an sfloat result.

function out = compute2(operation,in1,in2,force_type)
if nargin < 3
   error('Erroneus input.')
elseif nargin < 4
   force_type = '';
end

% Check inputs
isconstant1 = 0;
isconstant2 = 0;
if di_isdipimobj(in1)
   sz1 = imarsize(in1);
   isdip1 = 1;
else
   sz1 = size(in1);
   isdip1 = 0;
end
if prod(sz1)==1
   isscalar1 = 1;
else
   isscalar1 = 0;
end

if di_isdipimobj(in2)
   sz2 = imarsize(in2);
   isdip2 = 1;
else
   sz2 = size(in2);
   isdip2 = 0;
end
if prod(sz2)==1
   isscalar2 = 1;
else
   isscalar2 = 0;
end

% Convert non-dip_image input to dip_image.
if ~isdip1
   if ~isscalar1 & prod(sz1)==prod(sz2)
      in1 = reshape(in1,sz2);
      in1 = create_tensor(in1);
      sz1 = sz2;
      isconstant1 = 1;
   else
      in1 = dip_image(in1);
      if isscalar1
         isconstant1 = 1;
      end
      isscalar1 = 1;
      sz1 = [1,1];
   end
elseif ~isdip2 % It can never happen for both to not be dip_image objects.
   if ~isscalar2 & prod(sz1)==prod(sz2)
      in2 = reshape(in2,sz1);
      in2 = create_tensor(in2);
      sz2 = sz1;
      isconstant2 = 1;
   else
      in2 = dip_image(in2);
      if isscalar2
         isconstant2 = 1;
      end
      isscalar2 = 1;
      sz2 = [1,1];
   end
end

% More checks
if ~isscalar1 & ~isscalar2 & ~isequal(sz1,sz2)
   error('Tensor dimensions do not match.')
end
sz = sz1;
if isscalar1
   sz = sz2;
end

col1 = in1(1).color;
col2 = in2(1).color;
if isempty(col1)
   col = col2;
elseif ~isempty(col2) & ~strcmp(col1.space,col2.space)
   warning('Color spaces do not match: removing color space information.')
   col = '';
else
   col = col1;
end

if length(operation)>4 && isequal(operation(1:4),'dip_')
   dipfunc = true;
   operation = operation(5:end);
else
   dipfunc = false;  
end

% Iterate over array
out = dip_image('array',sz);
for ii=1:prod(sz)
   if isscalar1
      in1p = in1;
   else
      in1p = in1(ii);
   end
   if isscalar2
      in2p = in2;
   else
      in2p = in2(ii);
   end
   % Find output data type
   dt1 = in1p.dip_type;
   dt2 = in2p.dip_type;
   if strcmp(dt1,'bin') & ~strcmp(dt2,'bin')
      dt1 = 'uint8';
   elseif strcmp(dt2,'bin') & ~strcmp(dt1,'bin')
      dt2 = 'uint8';
   end
   if isconstant1 & strcmp(dt1,'dfloat')
      dt1 = dt2;
   end
   if isconstant2 & strcmp(dt2,'dfloat')
      dt2 = dt1;
   end
   switch force_type
      case ''
         out_dip_type = di_findtype(dt1,dt2);
      case 'forcedouble'
         out_dip_type = di_findtype(dt1,dt2);
         out_dip_type = di_findtype(out_dip_type,'dfloat');
      case 'keepsame'
         out_dip_type = di_findtypex(dt1,dt2);
      otherwise
         out_dip_type = force_type;
   end
   % Compute
   if isempty(in1p.data)
      out(ii) = in1p;
   elseif isempty(in2p.data)
      out(ii) = in2p;
   else      
      if dipfunc
         out(ii) = dip_arith(in1p,in2p,operation,out_dip_type);
      else
         out(ii) = compute2_scalar(operation,in1p,in2p,out_dip_type);
      end
   end
   out(ii).color = col;
end


%
% Sub-function that does "compute2" on scalar images
%
function out = compute2_scalar(operation,in1,in2,out_dip_type)

% Find output size
sz1 = imsize(in1);
sz2 = imsize(in2);
ndims = max(length(sz1),length(sz2));
if length(sz1)<ndims
   sz1(length(sz1)+1:ndims) = 1;
elseif length(sz2)<ndims
   sz2(length(sz2)+1:ndims) = 1;
end
if ndims==0
   sz1 = [1,1];
   sz2 = [1,1];
elseif ndims==1
   sz1 = [1,sz1];
   sz2 = [1,sz2];
else
   sz1 = sz1([2,1,3:end]);
   sz2 = sz2([2,1,3:end]); % the order of these dimensions is important when we do dimension expansion!
end
sz = max(sz1,sz2);
scalar = 0;
if all(sz1==1)
   scalar = 1;
elseif all(sz2==1)
   scalar = 2;
elseif any(sz1~=sz2)
   error('Image dimensions do not match.')
end

[out_type,complexity] = di_mattype(out_dip_type);
indata1 = in1.data;
indata2 = in2.data;

% Find computation method
direct = 0;    % no need to cast for computation
usesingle = 0; % cast to single for computation
usedouble = 0; % cast to double for computation
if strcmp(out_dip_type,'bin')
   direct = 1;
elseif matlabver_ge([7,0])
   if (isa(indata1,out_type)|(scalar==1 & isa(indata1,'double'))) & ...
      (isa(indata2,out_type)|(scalar==2 & isa(indata2,'double')))
      direct = 1;
   elseif ~strcmp(out_type,'double')
      usesingle = 1;
   else
      usedouble = 1;
   end
else
   if isa(indata1,'double') & isa(indata2,'double')
      direct = 1;
   else
      usedouble = 1;
   end
end
split = 0; % do the operation in smaller portions
buffersize = [];
if ~direct
   % If we need to cast data types or do dimension expansion, we should do the computation in chunks
   buffersize = dipgetpref('ComputationLimit');
   if prod(sz) > buffersize
      split = 1;
   end
end

% Compute!
if ~split
   if usedouble
      indata1 = double(indata1);
      indata2 = double(indata2);
   elseif usesingle
      indata1 = single(indata1);
      indata2 = single(indata2);
   end
   out = feval(operation,indata1,indata2);
   %#function int8, uint8, int16, uint16, int32, uint32, int64, uint64, single, double
   out = feval(out_type,out);
else
   % Compute in chunks
   out = di_create(sz,out_type,complexity);
   N = prod(sz);
   indx = 1:buffersize:N;
   if scalar==1 % in1 is scalar
      if usesingle
         for ii=1:length(indx)-1
            out(indx(ii):indx(ii+1)-1) = feval(operation,single(indata1),single(indata2(indx(ii):indx(ii+1)-1)));
         end
         out(indx(end):N) = feval(operation,single(indata1),single(indata2(indx(end):N)));
      elseif usedouble
         for ii=1:length(indx)-1
            out(indx(ii):indx(ii+1)-1) = feval(operation,double(indata1),double(indata2(indx(ii):indx(ii+1)-1)));
         end
         out(indx(end):N) = feval(operation,double(indata1),double(indata2(indx(end):N)));
      else
         for ii=1:length(indx)-1
            out(indx(ii):indx(ii+1)-1) = feval(operation,indata1,indata2(indx(ii):indx(ii+1)-1));
         end
         out(indx(end):N) = feval(operation,indata1,indata2(indx(end):N));
      end
   elseif scalar==2 % in2 is scalar
      if usesingle
         for ii=1:length(indx)-1
            out(indx(ii):indx(ii+1)-1) = feval(operation,single(indata1(indx(ii):indx(ii+1)-1)),single(indata2));
         end
         out(indx(end):N) = feval(operation,single(indata1(indx(end):N)),single(indata2));
      elseif usedouble
         for ii=1:length(indx)-1
            out(indx(ii):indx(ii+1)-1) = feval(operation,double(indata1(indx(ii):indx(ii+1)-1)),double(indata2));
         end
         out(indx(end):N) = feval(operation,double(indata1(indx(end):N)),double(indata2));
      else
         for ii=1:length(indx)-1
            out(indx(ii):indx(ii+1)-1) = feval(operation,indata1(indx(ii):indx(ii+1)-1),indata2);
         end
         out(indx(end):N) = feval(operation,indata1(indx(end):N),indata2);
      end
   else
      if usesingle
         for ii=1:length(indx)-1
            out(indx(ii):indx(ii+1)-1) = feval(operation,single(indata1(indx(ii):indx(ii+1)-1)),single(indata2(indx(ii):indx(ii+1)-1)));
         end
         out(indx(end):N) = feval(operation,single(indata1(indx(end):N)),single(indata2(indx(end):N)));
      elseif usedouble
         for ii=1:length(indx)-1
            out(indx(ii):indx(ii+1)-1) = feval(operation,double(indata1(indx(ii):indx(ii+1)-1)),double(indata2(indx(ii):indx(ii+1)-1)));
         end
         out(indx(end):N) = feval(operation,double(indata1(indx(end):N)),double(indata2(indx(end):N)));
      else % doesn't happen?!
         for ii=1:length(indx)-1
            out(indx(ii):indx(ii+1)-1) = feval(operation,indata1(indx(ii):indx(ii+1)-1),indata2(indx(ii):indx(ii+1)-1));
         end
         out(indx(end):N) = feval(operation,indata1(indx(end):N),indata2(indx(end):N));
      end
   end
end

% Make sure things are going fine if we produced a complex output:
if ~isreal(out)
   if strcmp(out_dip_type,'bin') | strcmp(out_dip_type(2:4),'int')
      error('Operation unexpectedly produced complex values.')
   else
      out_dip_type = [out_dip_type(1),'complex'];
   end
end

% The next step not only creates the dip_image object, but also sets the
% datatype correctly. That is, we expect no conversion is done anymore,
% but a binary image will be labelled as such.
out_phys = di_findphysdims(in1.physDims,in2.physDims);
out = dip_image('trust_me',out,out_dip_type,ndims,out_phys);


%
% Sub-function to convert a MATLAB array to a dip_image_array object.
%
function out = create_tensor(in)
out = dip_image('array',size(in));
for ii=1:prod(size(in))
   out(ii) = dip_image(in(ii));
end
