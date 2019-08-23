%function [score,outputMsg]=mautogradeTestInOutDimensions(fTested,dataInOut)
%Similar to mautogradeTestInOut, but checks the output dimensions instead
%of the actual values. The field dataInOut.cmp is not necessary.
function [score,outputMsg]=mautogradeTestInOutDimensions(fTested,dataInOut)
[score,outputMsg,flagPassed]=mautogradeTestInOutCellFun(fTested,dataInOut,@size);
if ~flagPassed
    outputMsg=mautogradeAppendOutput('Test failed',outputMsg);
end
outputMsg=mautogradeAppendOutput('Check that dimensions of each output are as expected for typical inputs',outputMsg);
