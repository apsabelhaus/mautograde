%Translate a cell array of strings to a single string with EOL separators
%function outputMsg=mautogradeOutputFromCell(cellStr)
function outputMsg=mautogradeOutputFromCell(cellStr)
outputMsg=[];
for message=cellStr(:)'
    outputMsg=mautogradeOutputAppend(outputMsg,message{1});
end
