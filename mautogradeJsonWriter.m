%A limited function to write a variable as JSON into a file
%function mautogradeJsonWriter(fid,s)
%Recursively writes the contents of the variable s to the given file id
%using JSON syntax
%Notes: 
%   1. only some types of variables are supported (structs, arrays, double,
%       strings). 
%   2. arrays are flattened to linear arrays
%Inputs
%   fid     file id for writing (use 1 for terminal)
%   s       MATLAB variable to be written to JSON
function mautogradeJsonWriter(fid,s,indentation)
if ~exist('indentation','var')
    indentation='';
end
%check number of elements in s
switch numel(s)
    case 0 %(empty)
        switch class(s)
            case 'char'
                fprintf(fid,'""');
            otherwise
                fprintf(fid,'{}');
        end
    case 1
        switch class(s)
            case 'struct'
                writeStruct(fid,s,indentation)
            case 'char'
                writeChar(fid,s)
            case 'double'
                fprintf(fid,num2str(s));
            otherwise
                error(['Type ' class(s) 'not supported'])
        end
    otherwise
        switch class(s)
            case 'char'
                writeChar(fid,s)
            case 'cell'
                writeCellArray(fid,s,indentation)
            otherwise
                writeArray(fid,s,indentation)
        end
end
if isempty(indentation)
    fprintf(fid,'\n');
end

function writeChar(fid,s)
% Remove invalid control characters
s(s<=31)=[];
fprintf(fid,'"%s"%s"',s);

function writeStruct(fid,s,indentation)
fields=fieldnames(s);
nbFields=length(fields);
indentationNew=['  ' indentation];
fprintf(fid,[indentation '{ \n']);

for iField=1:nbFields
    name=fields{iField};
    data=s.(name);
    
    fprintf(fid,'%s"%s" : ',indentationNew,name);
    mautogradeJsonWriter(fid,data,indentationNew)
    if iField~=nbFields
        fprintf(fid,',');
    end
    fprintf(fid,'\n');
end

fprintf(fid,[indentation '}']);

function writeArray(fid,s,indentation)
fprintf(fid,['\n' indentation ' [\n']);
indentationNew=['    ' indentation];
nbElements=numel(s);
for iElement=1:nbElements
    mautogradeJsonWriter(fid,s(iElement),indentationNew)
    if iElement~=nbElements
        fprintf(fid,',');
    end
    fprintf(fid,'\n');
end
fprintf(fid,[indentation ' ]']);

function writeCellArray(fid,s,indentation)
fprintf(fid,['\n' indentation ' [\n']);
indentationNew=['    ' indentation];
nbElements=numel(s);
for iElement=1:nbElements
    fprintf(fid,indentationNew);
    mautogradeJsonWriter(fid,s{iElement},indentationNew)
    if iElement~=nbElements
        fprintf(fid,',');
    end
    fprintf(fid,'\n');
end
fprintf(fid,[indentation ' ]']);
