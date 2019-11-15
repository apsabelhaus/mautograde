function mautogradeSuiteJsonWriter(testResults,testInfo,flagWriteFile)
flagIncludeTerminalOutput=false;
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
    scoreMax=getFieldOrDefault(testInfo, {fName 'scoreMax'}, 1);
    scoreNormalization=getFieldOrDefault(testInfo, {fName 'scoreNormalization'},scoreMax);
    visibility=getFieldOrDefault(testInfo, {fName 'visibility'}, 'visible');
    %score
    if ~isnan(result.Score)
        score=result.Score/scoreNormalization*scoreMax;
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
    output='';
    description=getFieldOrDefault(testInfo, {fName 'description'}, '');
    if isempty(description)
        %try to get default description from the name
        description=mautogradeFunctionDescriptionDefault(fName);
    end
    if ~isempty(description)
        output=mautogradeAppendOutput(output,'Description: %s',description);
    end
    if score==scoreMax
        output=mautogradeAppendOutput(output,'Result: Passed');
    elseif score==0
        output=mautogradeAppendOutput(output,'Result: Failed');
    else
        output=mautogradeAppendOutput(output,'Result: Partially failed');
    end        
    
    details=result.Details;
    if ~isempty(details)
        if isfield(details,'identifier')
            if isempty(details.identifier)
                id='Error';
            else
                id=details.identifier;
            end
            output=mautogradeAppendOutput(output, '%s %s', id, details.message);
        elseif isfield(details,'DiagnosticRecord') && ~isempty(details.DiagonsticRecord.Exception)
            ME=DiagonsticRecord.Exception;
            output=[ME.identifier ' -- ' ME.message];
        end
    end
    
    output=mautogradeAppendOutput(output, result.TextOutput);
    
    if ~isempty(result.TerminalOutput) && flagIncludeTerminalOutput
        output=mautogradeAppendOutput(output,...
            'Terminal output from your function: %s',result.TerminalOutput);
    end
    
    %escape newlines and other special characters
    output=strrep(output,char(10),'\n'); %#ok<CHARTEN>
    output=strrep(output,'"','``');
    
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
