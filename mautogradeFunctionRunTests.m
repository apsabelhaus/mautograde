%Run mAutograde tests and collect results in a tests structure
%function tests=mautogradeFunctionTests(functions)
%Run the elements of the array functions as function handles, recording if
%they fail (raise an error or exception) or pass, their names, and
%execution time. This function is expected to be called in a test suite file
%using the following syntax:
%   function testResults = exampleSubmissionFunction1_autoTest
%       testResults = mautogradeFunctionRunTests(localfunctions);
%   end
%See example test suites for details.
%Terminology
%   Function under test     A function of which we are evaluating the
%       output
%   Test function           A function that takes a testCase input, runs
%       the funtion under test, collectes the output and compute the score
%Input
%   functions   array of function handles with individual tests (usually
%               the output of localfunctions()) 
%Output
%   tests       struct array with fields
%       'Name'      name of the test. If the suite test ends with '_autoTest',
%                   prefix with the name of the function under test, extracted
%                   from the file name of the suite.
%       'Passed'    1 if that test passed, 0 otherwise
%       'Failed'    0 if that test passed, 1 otherwise
%       'Details'   If the test failed with an error, the details about the
%                   error
%       'TerminalOutput'
%                   Output that the function under test printed to the
%                   terminal under the test function.
%       'TextOutput'
%                   Output given by the test function with messages to be
%                   given to the user in gradescope (e.g., a description of
%                   the test)
%       'Duration'  How long the test run for
%       'Score'     The score to report for this test (NaN if the test
%                   function is malformed and does not give any output)
%       
function tests=mautogradeFunctionRunTests(functions)
flagRethrowNonAssertionErrors=false;

nbFunctions=length(functions);
tests=repmat(struct('Name','','Passed',0,'Failed',0,'Duration',0,'Details',''),nbFunctions,1);
for iFunction=1:nbFunctions
    f=functions{iFunction};
    %testCase will be the input to the test function, and the following
    %builds it incrementally
    testCase=struct();
    %get name of function under test from file name, if possible
    s=dbstack();
    if length(s)<2
        error([mfilename ' is expected to be called from a test suite'])
    end
    fAutoTestFileName=s(2).name;
    idxSuffix=regexp(fAutoTestFileName,'_autoTest$');
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
    fAutoTestName=mautogradeAny2Str(f,'minimal');
    tests(iFunction).Name=mautogradeFunctionNameJoin(fAutoTestFileName,fAutoTestName);
    %run the test, and collect results
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
