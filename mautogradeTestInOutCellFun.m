%Helper function to run mautogradeTestInOut but applying a cell fun to the actual outputs
%function [score,outputMsg,flagPassed]=mautogradeTestInOutCellFun(fTested,dataInOut,fOutputCell)
function [score,outputMsg,flagPassed]=mautogradeTestInOutCellFun(fTested,dataInOut,fOutputCell)
nbOutputsExpected=length(mautogradeEnsureCell(dataInOut(1).output));
%decoration of function to output sizes instead of real outputs
fTestedWrap=@(varargin) outputWrap(fTested,nbOutputsExpected,fOutputCell,varargin{:}); 
%setup comparison function
for iData=1:length(dataInOut)
    [dataInOut(iData).cmp{1:nbOutputsExpected}]=deal(@mautogradeCmpEq);
end
%call the test input-output test function. We need to explicitly specify
%the number of outputs because it cannot be detected 
[score,outputMsg,flagPassed]=mautogradeTestInOut(fTestedWrap,dataInOut,...
    'fname',func2str(fTested));

function varargout=outputWrap(fTested,nbOutputsExpected,fOutputCell,varargin)
output=cell(1,nbOutputsExpected);
[output{:}]=fTested(varargin{:});
switch class(fTested)
    case 'function_handle'
        varargout=cellfun(fOutputCell,output,'UniformOutput',false);
    case 'char'
        varargout=eval(['cellfun(' fOutputCell ',output,''UniformOutput'',false)']);
    otherwise
        error('Handling of class of fTested not implemented');
end
        
