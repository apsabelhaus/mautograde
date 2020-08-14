%Transforms almost any variable into a string representation
%function str=mautogradeAny2Str(var)
%Inputs
%   var     The variable to transform
%Optional inputs
%   'appendTo',strPrev  append result to strPrev (default: strPrev='')
%   'minimal'           do not add delimiters/labels 
%Output
%   str     The string representation; uses Line Feed (char(10)) to
%           represent multiline strings
function str=mautogradeAny2Str(var,varargin)
strPrev='';
flagMinimal=false;

%optional parameters
ivarargin=1;
while ivarargin<=numel(varargin)
    switch lower(varargin{ivarargin})
        case 'appendto'
            ivarargin=ivarargin+1;
            strPrev=varargin{ivarargin};
        case 'minimal'
            flagMinimal=true;
        otherwise
            error(['Argument ' varargin{ivarargin} ' not valid!'])
    end
    ivarargin=ivarargin+1;
end

switch class(var)
    case 'char'
        str=var;
        nbStrings=size(str,1);
        if flagMinimal
            delimiter='';
        else
            delimiter=repmat('''', nbStrings,1);
        end
        str=[delimiter str delimiter];
    case 'double'
        str=num2str(var);
        if ~flagMinimal
            delimiterL='[';
            delimiterR=']';
            if numel(var)>1
                if size(var,1)==1
                    str=[delimiterL str delimiterR];
                else
                    str=char(delimiterL,str,delimiterR);
                end
            end
        end
        str=mautogradeChar2Multiline(str);
    case 'struct'
        str=strPrev;
        for iStruct=1:numel(var)
            thisStruct=var(iStruct);
            sNamesCells=[fieldnames(thisStruct) struct2cell(thisStruct)];
            str=mautogradeAny2Str(sNamesCells,'appendTo',str);
        end
        if ~flagMinimal
            str=mautogradeOutputAppend('struct',str);
            str=mautogradeOutputAppend(str,'endstruct');
        end
    case 'cell'
        cellStr=cellfun(@mautogradeAny2Str,var,'UniformOutput',false);
        str='';
        nbRows=size(cellStr,1);
        for iCol=1:size(cellStr,2)
            str=[str repmat(' ',nbRows,1)...
                char(cellStr(:,iCol))]; %#ok<AGROW>
        end
        str=mautogradeChar2Multiline(str);
    case 'logical'
        if flagMinimal
            str=mautogradeAny2Str(double(var),varargin{:});
        else
            sStrCell=arrayfun(@logical2str, var, 'UniformOutput',false);
            str=mautogradeAny2Str(sStrCell);
        end
    case 'function_handle'
        str=mautogradeOutputAppend(strPrev,func2str(var));
        if ~flagMinimal
            str=['@' str];
        end
    otherwise
        error('Unknown class')
end
str=mautogradeOutputAppend(strPrev,str);

function str=logical2str(v)
if v
    str='true ';
else
    str='false';
end