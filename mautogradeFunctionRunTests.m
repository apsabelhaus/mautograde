%function tests=mautogradeFunctionTests(functions)
%Run the elements of the array functions as function handles, recording if
%they fail (raise an error or exception) or pass, their names, and
%execution time
function tests=mautogradeFunctionRunTests(functions)
flagRethrowNonAssertionErrors=false;

nbFunctions=length(functions);
tests=repmat(struct('Name','','Passed',0,'Failed',0,'Duration',0,'Details',''),nbFunctions,1);
for iFunction=1:nbFunctions
    f=functions{iFunction};
    %get name of function under test from file name, if possible
    s=dbstack();
    fAutoTestFileName=s(2).name;
    idxSuffix=regexp(fAutoTestFileName,'_autoTest$');
    testCase=struct();
    if ~isempty(idxSuffix)
        fTestedName=fAutoTestFileName(1:idxSuffix-1);
        try
            testCase.functionTested=eval(['@' fTestedName]); %
        catch
            %Octave: we cannot define handle to function that does not
            %exist, or that had nested functions inside. In this case, we
            %keep it as a string.
            testCase.functionTested=fTestedName;
        end
        testCase.functionTestedStr=fTestedName; %#ok<STRNU>: we use testCase in evals
    end
    %get name of calling functions
    fAutoTestName=f;
    if isa(fAutoTestName,'function_handle')
        fAutoTestName=func2str(f);
    end
    fName=mautogradeFunctionNameJoin(fAutoTestFileName,fAutoTestName);
    tests(iFunction).Name=fName;
    tests(iFunction).Passed=1;
    tic
    output='';
    try
        switch nargout(f)
            case 0
                terminalOutput=evalc('f(testCase)');
                score=NaN;
            case 1
                [terminalOutput,score]=evalc('f(testCase)');
            case 2
                [terminalOutput,score,output]=evalc('f(testCase)');
        end
    catch ME
        if ~flagRethrowNonAssertionErrors || strcmp(ME.identifier,'MATLAB:assertion:failed')
            score=0;
            tests(iFunction).Passed=0;
            tests(iFunction).Failed=1;
            tests(iFunction).Details=struct('identifier',ME.identifier,'message',ME.message);
            output=mautogradeAny2Str(ME.stack);
            terminalOutput='';
        else
            rethrow(ME)
        end
    end
    %Ensure that output is a string (Octave compatibility)
    tests(iFunction).TerminalOutput=terminalOutput;
    tests(iFunction).TextOutput=char(output);
    tests(iFunction).Duration=toc;
    tests(iFunction).Score=score;
end
