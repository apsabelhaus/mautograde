%Transform a 2-D char array into a multiline string
%function str=mautogradeChar2Multiline(charArray)
%Uses Line Feed (char(10)) for separating lines
function str=mautogradeChar2Multiline(charArray)
nbStrings=size(charArray,1);
switch nbStrings
    case 0
        str='';
    case 1
        str=charArray;
    otherwise
        str=reshape([charArray repmat(char(10),nbStrings,1)]',1,[]); %#ok<CHARTEN>
        %remove trailing newline
        str(end)=[];
end
