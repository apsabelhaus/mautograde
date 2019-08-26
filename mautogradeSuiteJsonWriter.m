function mautogradeSuiteJsonWriter(testResults,testInfo,flagWriteFile)
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
    %max_score and visibility
    scoreNormalization=getFieldOrDefault(testInfo, {fName 'scoreNormalization'},1);
    scoreMax=max(getFieldOrDefault(testInfo, {fName 'scoreMax'}, 1),1);
    visibility=getFieldOrDefault(testInfo, {fName 'visibility'}, 'visible');
    %score
    if ~isnan(result.Score)
        score=result.Score/scoreNormalization;
    else
        if result.Passed
            score=scoreMax;
        else
            score=0;
        end
    end
    if score>scoreMax
        warning(['Detected score>max_score for test ' fName])
    end
    %output
    details=result.Details;
    if isempty(details)
        output='';
    else
        if isfield(details,'identifier')
            if isempty(details.identifier)
                id='Error';
            else
                id=details.identifier;
            end
            output=mautogradeAppendOutput(id, '%s', details.message);
        elseif isfield(details,'DiagnosticRecord') && ~isempty(details.DiagonsticRecord.Exception)
            ME=DiagonsticRecord.Exception;
            output=[ME.identifier ' -- ' ME.message];
        end
    end
    
    output=strrep([output result.TextOutput],char(10),'\n'); %#ok<CHARTEN>
    
    testResultsStruct(iResult).score=score;
    testResultsStruct(iResult).max_score=scoreMax;
    testResultsStruct(iResult).output=output;
    testResultsStruct(iResult).visibility=visibility;
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


%function val=getFieldOrDefault(data,fields,valDefault)
%Get (possibly nested) fields, or a default value if does not exist or
%if the field empty
function val=getFieldOrDefault(data,fields,valDefault)
fields=mautogradeEnsureCell(fields);
flagAssigned=false;
for iField=1:length(fields)
    fieldName=fields{iField};
    if isfield(data,fieldName)
        data=data.(fieldName);
    else
        val=valDefault;
        flagAssigned=true;
        break
    end
end
if ~flagAssigned
    if ~isempty(data)
        val=data;
    else
        val=valDefault;
    end
end
