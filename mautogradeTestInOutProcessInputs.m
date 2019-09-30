%Change function handles in input data to actual input values
function dataInOut=mautogradeTestInOutProcessInputs(dataInOut)
nbTests=length(dataInOut);
for iTest=1:nbTests
    inputActual=mautogradeEnsureCell(dataInOut(iTest).input);
    for iInput=1:length(inputActual)
        if isa(inputActual{iInput},'function_handle')
            inputActual{iInput}=inputActual{iInput}();
        end
    end
    dataInOut(iTest).input=inputActual;
end
