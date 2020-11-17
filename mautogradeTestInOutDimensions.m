%function [score,outputMsg]=mautogradeTestInOutDimensions(fTested,dataInOut,cmpOptions)
%Similar to mautogradeTestInOut, but checks the output dimensions instead
%of the actual values. The field dataInOut.cmp is overwritten by
%@(x,y) mautogradeCmpDimensions(x,y,cmpOptions{:}), where cmpOptions, by default,
%is empty
function [score,outputMsg]=mautogradeTestInOutDimensions(fTested,dataInOut,cmpOptions)
if ~exist('cmpOptions','var')
    cmpOptions={};
end
if ~iscell(cmpOptions)
    cmpOptions={cmpOptions};
end
for iData=1:numel(dataInOut)
    %add placeholder if empty
    if isempty(dataInOut(iData).cmp)
        dataInOut(iData).cmp={{}};
    end
    %replace all comparison functions with equality with wildcards
    dataInOut(iData).cmp(:)=deal({@(x,y) mautogradeCmpDimensions(x,y,cmpOptions{:})});
end
[score,outputMsg]=mautogradeTestInOutCellFun(fTested,dataInOut,@size);

