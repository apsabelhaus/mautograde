%Similar to sprintf, but appends output to new lines of a string
%function outputMsg=mAutogradeOutputAppend(outputMsg,varargin)
%Inputs
%   outputMsg   Message/variable to append to. 
%   varargin    Same argument as sprintf.
%Note: if varargin has only one variable (string), all the % characters
%will be escaped.
%Outputs
%   outputMsg   If outputMsg was not empty, add a Line Feed (char(10)), and
%       then append new output
function outputMsg=mautogradeOutputAppend(outputMsg,varargin)
newLineStr=char(10); %#ok<CHARTEN>
if ~ischar(outputMsg)
    outputMsg=num2str(outputMsg);
end
if ~isempty(outputMsg)
    outputMsg=[outputMsg newLineStr];
end
strFormat=varargin{1};
if numel(varargin)==1
    %escape any % sign (we do not have parameters to fill them in)
    strFormat=strrep(strFormat,'%','%%');
end
outputMsg=[outputMsg sprintf(strFormat,varargin{2:end})];

