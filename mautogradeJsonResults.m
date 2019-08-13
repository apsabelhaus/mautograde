function mautogradeJsonResults(testResults,testInfo,flagWriteFile)
if ~exist('testInfo','var')
    testInfo=[];
end
if ~exist('flagWriteFile','var')
    flagWriteFile=false;
end

nbResults=length(testResults);
testResultsStruct=struct('name',{testResults.Name});
for iResult=1:nbResults
    result=testResults(iResult);
    fName=result.Name;
    %max_score
    if isfield(testInfo,fName)
        max_score=testInfo.(fName);
    else
        max_score=1;
    end
    %score
    if ~isnan(result.Score)
        score=result.Score;
    else
        if result.Passed
            score=max_score;
        else
            score=0;
        end
    end
    if score>max_score
        warning(['Detected score>max_score for test ' fName])
    end
    
    %output
    details=result.Details;
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
    
    testResultsStruct(iResult).score=score;
    testResultsStruct(iResult).max_score=max_score;
    testResultsStruct(iResult).output=output;
end
suiteResult.execution_time=sum([testResults.Duration]);
suiteResult.tests=testResultsStruct;

if flagWriteFile
    fid=fopen('results.json','w');
    if fid<0
        error('Cannot open results.json file')
    end
else
    fid=1;
end
mautogradeJsonWriter(fid,suiteResult)
if flagWriteFile
    fclose(fid);
end

