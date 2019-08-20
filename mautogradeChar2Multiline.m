function str=mautogradeChar2Multiline(charArray)
nbStrings=size(charArray,1);
if nbStrings==1
    str=charArray;
else
    str=reshape([charArray repmat(char(10),nbStrings,1)]',1,[]); %#ok<CHARTEN>
    %remove trailing newline
    str(end)=[];
end
