%function str=mautogradeAny2Str(s)
%Transforms almost any variable into a string representation
function str=mautogradeAny2Str(s,varargin)
strPrev='';

%optional parameters
ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case 'appendto'
            ivarargin=ivarargin+1;
            strPrev=varargin{ivarargin};
        otherwise
            error(['Argument ' varargin{ivarargin} ' not valid!'])
    end
    ivarargin=ivarargin+1;
end

switch class(s)
    case 'char'
        str=s;
        nbStrings=size(str,1);
        delimiter=repmat('''', nbStrings,1);
        str=[delimiter str delimiter];
    case 'double'
        str=num2str(s);
        if numel(s)>1
            if size(s,1)==1
                str=['[',str,']'];
            else
                str=char('[',str,']');
            end
        end
        str=mautogradeChar2Multiline(str);
        str=mautogradeAppendOutput(strPrev,str);
    case 'struct'
        str=strPrev;
        for iStruct=1:numel(s)
            thisStruct=s(iStruct);
            sNamesCells=[fieldnames(thisStruct) struct2cell(thisStruct)];
            str=mautogradeAny2Str(sNamesCells,'appendTo',str);
        end
        str=mautogradeAppendOutput('struct',str);
        str=mautogradeAppendOutput(str,'endstruct');
    case 'cell'
        cellStr=cellfun(@mautogradeAny2Str,s,'UniformOutput',false);
        strConcatenation=[];
        nbRows=size(cellStr,1);
        for iCol=1:size(cellStr,2)
            strConcatenation=[strConcatenation repmat(' ',nbRows,1)...
                char(cellStr(:,iCol))];
        end
        strConcatenation=mautogradeChar2Multiline(strConcatenation);
        str=mautogradeAppendOutput(strPrev,strConcatenation);        
    case 'logical'
        sStrCell=arrayfun(@logical2str, s, 'UniformOutput',false);
        str=mautogradeAny2Str(sStrCell,'appendTo',strPrev);
end

function str=logical2str(v)
if v
    str='true ';
else
    str='false';
end