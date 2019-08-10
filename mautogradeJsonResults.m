function mautogradeJsonResults(testResults,flagWriteFile)
if ~exist('flagWriteFile','var')
    flagWriteFile=false;
end

nbResults=length(testResults);
testResultsStruct=struct('score',{testResults.Passed},'max_score',num2cell(ones(1,nbResults)),'name',{testResults.Name});
for iResult=1:nbResults
    details=testResults(iResult).Details;
    if isempty(details)
        output='';
    else
        if isfield(details,'identifier')
            output=[details.identifier '\n' details.message];
        elseif isfield(details,'DiagnosticRecord') && ~isempty(details.DiagonsticRecord.Exception)
            ME=DiagonsticRecord.Exception;
            output=[ME.identifier '\n' ME.message];
        end
    end
    testResultsStruct(iResult).output=output;
end
result.execution_time=sum([testResults.Duration]);
result.tests=testResultsStruct;

if flagWriteFile
    fid=fopen('results.json','w');
    if fid<0
        error('Cannot open results.json file')
    end
else
    fid=1;
end
mautogradeJsonWriter(fid,result)
if flagWriteFile
    fclose(fid);
end

