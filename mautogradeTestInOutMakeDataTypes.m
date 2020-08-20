function dataInOut=mautogradeTestInOutMakeDataTypes(dataInOut)
for iData=1:length(dataInOut)
    types=cellfun(@class,...
        mautogradeEnsureCell(dataInOut(iData).output),...
        'UniformOutput',false);
    dataInOut(iData).output=types;
end
