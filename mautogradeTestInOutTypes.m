%function [score,outputMsg]=mautogradeTestInOutDimensions(fTested,dataInOut)
%Similar to mautogradeTestInOut, but checks the output dimensions instead
%of the actual values. The field dataInOut.cmp is not necessary.
function [score,outputMsg]=mautogradeTestInOutTypes(fTested,dataInOut)
if ~isempty(dataInOut) && ~isfield(dataInOut,'cmp')
    dataInOut(1).cmp={{}};
end
for iData=1:numel(dataInOut)
    %replace all comparison functions with standard equality
    cmp=cell(size(dataInOut(iData).cmp));
    cmp(:)=deal({@mautogradeCmpEq});
    dataInOut(iData).cmp=cmp;
end
[score,outputMsg]=mautogradeTestInOutCellFun(fTested,dataInOut,@class);
