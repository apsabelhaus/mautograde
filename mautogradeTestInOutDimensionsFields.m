%function [score,outputMsg]=mautogradeTestInOutDimensionsFields(fTested,dataInOut,cmpOptions)
%Similar to mautogradeTestInOut, but checks the output's dimensions of fields instead
%of the actual values. The field dataInOut.cmp is overwritten by
%@(x,y) mautogradeCmpDimensions(x,y,cmpOptions{:}), where cmpOptions, by default,
%is empty.
function [score,outputMsg]=mautogradeTestInOutDimensionsFields(fTested,dataInOut)
for iData=1:numel(dataInOut)
    %add placeholder if empty
    if ~isfield(dataInOut(iData),'cmp') || isempty(dataInOut(iData).cmp)
        dataInOut(iData).cmp={{}};
    end
    %replace all comparison functions with equality with wildcards
    dataInOut(iData).cmp(:)=deal({@(x,y) mautogradeCmpEq(x,y,'NaNWildcard')});
end
[score,outputMsg]=mautogradeTestInOutCellFun(fTested,dataInOut,@sizeFieldsAvg);

function sDim=sizeFieldsAvg(s)
%compute average size of fields
fNames=fieldnames(s);
nbFields=numel(fNames);
nbElements=numel(s);
for iField=1:nbFields
    thisField=fNames{iField};
    sDim.(thisField)=zeros(1,2);
    for iElement=1:nbElements
        sDim.(thisField)=sDim.(thisField)+size(s(iElement).(thisField));
    end
    sDim.(thisField)=sDim.(thisField)/nbElements;
end
