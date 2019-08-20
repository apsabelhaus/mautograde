function [score,outputMsg,flagPassed]=mautogradeTestInOutCellFun(fTested,dataInOut,fOutputCell)
nbOutputsExpected=length(dataInOut(1).output);
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
varargout=cellfun(fOutputCell,output,'UniformOutput',false);
