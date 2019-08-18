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
    case {'char','double'}
        str=mautogradeAppendOutput(strPrev,num2str(s));
    case 'struct'
        sNamesCells=['struct' ...
            reshape([fieldnames(s) struct2cell(s)]',1,[])...
            'endstruct'];
        str=mautogradeAny2Str(sNamesCells,'appendTo',strPrev);
    case 'cell'
        str=strPrev;
        s=reshape(s,1,[]);
        for iCell=1:length(s)
            str=mautogradeAny2Str(s{iCell},'appendTo',str);
        end
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