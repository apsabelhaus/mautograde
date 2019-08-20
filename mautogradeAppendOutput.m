%function outputMsg=mAutogradeAppendOutput(outputMsg,varargin)
function outputMsg=mautogradeAppendOutput(outputMsg,varargin)
newLineStr=char(10); %#ok<CHARTEN>
if ~ischar(outputMsg)
    outputMsg=num2str(outputMsg);
end
if ~isempty(outputMsg)
    outputMsg=[outputMsg newLineStr];
end
outputMsg=[outputMsg sprintf(varargin{1},varargin{2:end})];
