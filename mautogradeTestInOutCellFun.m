%Helper function to run mautogradeTestInOut but applying a cell fun to the actual outputs
%function [score,outputMsg,flagPassed]=mautogradeTestInOutCellFun(fTested,dataInOut,fOutputCell)
function [score,outputMsg,flagPassed]=mautogradeTestInOutCellFun(fTested,dataInOut,fOutputCell)
nbOutputsExpected=length(mautogradeEnsureCell(dataInOut(1).output));
%decoration of function to output sizes instead of real outputs
fTestedWrap=@(varargin) outputWrap(fTested,nbOutputsExpected,fOutputCell,varargin{:}); 
%setup comparison function
if ~isfield(dataInOut,'cmp')
    for iData=1:length(dataInOut)
        [dataInOut(iData).cmp{1:nbOutputsExpected}]=deal(@mautogradeCmpEq);
    end
end
%call the test input-output test function. We need to explicitly specify
%the number of outputs because it cannot be detected 
[score,outputMsg,flagPassed]=mautogradeTestInOut(fTestedWrap,dataInOut,...
    'fname',mautogradeAny2Str(fTested,'minimal'));

function varargout=outputWrap(fTested,nbOutputsExpected,fOutputCell,varargin)
%TODO: handle the case where the function does not return the right number
%of outputs
output=cell(1,nbOutputsExpected);
switch class(fTested)
    case 'function_handle'
        [output{:}]=fTested(varargin{:});
    case 'char'
        [output{:}]=eval([fTested '(varargin{:})']);
    otherwise
        error('Handling of class of fTested not implemented');
end
varargout=cellfun(fOutputCell,output,'UniformOutput',false);
        
