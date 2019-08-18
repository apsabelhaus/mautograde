%function outputMsg=mAutogradeAppendOutput(outputMsg,varargin)
function outputMsg=mautogradeAppendOutput(outputMsg,varargin)
if ~ischar(outputMsg)
    outputMsg=num2str(outputMsg);
end
if ~isempty(outputMsg)
    outputMsg=[outputMsg ' <br/> '];
end
outputMsg=sprintf([outputMsg varargin{1}],varargin{2:end});
