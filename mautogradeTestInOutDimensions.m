%function [score,outputMsg]=mautogradeTestInOutDimensions(fTested,dataInOut)
%Similar to mautogradeTestInOut, but checks the output dimensions instead
%of the actual values. The field dataInOut.cmp is not necessary.
function [score,outputMsg]=mautogradeTestInOutDimensions(fTested,dataInOut)
[score,outputMsg]=mautogradeTestInOutCellFun(fTested,dataInOut,@size);

