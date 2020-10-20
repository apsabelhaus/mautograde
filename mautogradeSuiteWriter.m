%Write the results of a test suite to a Gradescope-compatible JSON file
%function mautogradeSuiteJsonWriter(testResults,testInfo,varargin)
%Inputs
%   testResults     Results from mautogradeSuiteRunTests()
%   testInfo        Results from mautogradeSuiteScan()
%Optional inputs
%   'writeFile'     Write to a 'results.json' file, otherwise, output to terminal
function mautogradeSuiteWriter(testResults,testInfo,varargin)
if ~exist('testInfo','var')
    testInfo=[];
end
flagWriteFile=false;
writerType='json';

%optional parameters
ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case 'writefile'
            flagWriteFile=true;
        case 'type'
            ivarargin=ivarargin+1;
            writerType=varargin{ivarargin};
        otherwise
            error(['Argument ' varargin{ivarargin} ' not valid!'])
    end
    ivarargin=ivarargin+1;
end

suiteResult=mautogradeSuiteMergeResultsInfo(testResults,testInfo);

if flagWriteFile
    fid=fopen('results.json','w');
    if fid<0
        error('Cannot open results.json file')
    end
else
    fid=1;
end
switch writerType
    case 'json'
        mautogradeJsonWriter(fid,suiteResult)
    case 'quick'
        quickWriter(fid,suiteResult)
end        
if flagWriteFile
    fclose(fid);
end

function quickWriter(fid,suiteResults)
%Writer providing
nbTests=length(suiteResults.tests);
for iTest=1:nbTests
    test=suiteResults.tests(iTest);
    fprintf(fid,'* %s: %.2f/%.2f\n', test.name, test.score, test.max_score);
    if ~isempty(regexp(test.output,'Failed', 'once'))
        fprintf(regexprep(test.output,'.*Failed','Failed'))
        fprintf('\n')
    elseif test.score~=test.max_score
        fprintf('Failed: score does not match max_score\n')
        fprintf(test.output)
        fprintf('\n')
    end
        
end

