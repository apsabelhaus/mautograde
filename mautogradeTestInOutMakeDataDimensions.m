function dataInOut=mautogradeTestInOutMakeDataDimensions(dataInOut)
for iData=1:length(dataInOut)
    dimensions=cellfun(@size,...
        mautogradeEnsureCell(dataInOut(iData).output),...
        'UniformOutput',false);
    dataInOut(iData).output=dimensions;
end
