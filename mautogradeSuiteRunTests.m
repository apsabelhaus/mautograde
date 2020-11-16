%function mautogradeRunTests(fileName)
%Run the mAutograde test suite in fileName.m, then write the results to
%standard output. 
%Inputs
%   fileName    name of the test suite file. If fileName is not the name of
%       a file but it is the name of a directory, look for all the files
%       starting/ending with "test" in that directory, and run tem as
%       mAutograde suites. If fileName is empty, use the current directory.
%Optional inputs
%   'quickReport' output a quick summary of the results instead of the full
%       JSON report

% TODO: extract a "runSuite" function

function mautogradeSuiteRunTests(fileName,varargin)
flagVerbose=false;
optsSuiteWriter={};
%optional parameters
ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case 'quickreport'
            optsSuiteWriter=[optsSuiteWriter 'type' 'quick'];
        case 'verbose'
            flagVerbose=true;
        otherwise
            error(['Argument ' varargin{ivarargin} ' not valid!'])
    end
    ivarargin=ivarargin+1;
end

switch exist(fileName,'file')
    case 2
        %fileName is an actual .m file
        [filePath,suiteName]=fileparts(fileName);
        if ~isempty(filePath) && ~strcmp(filePath,'.')
            addpathWithCommon(filePath)
        end
        fileName=[suiteName,'.m'];
        if flagVerbose
            disp(['** Test suite: ' suiteName])
        end
        eval(['testResults= ' suiteName '();'])
        testInfo=mautogradeSuiteScan(fileName);
        mautogradeSuiteWriter(testResults,testInfo,optsSuiteWriter{:})
    case 7
        %fileName is a directory
        testFileNames=getTestFileList(fileName);
        addpathWithCommon(fileName)
        testResults=[];
        testInfo=[];
        nbTestFiles=length(testFileNames);
        if nbTestFiles==0
            warning('No test files found in %s',fileName)
        end
        for iFile=1:nbTestFiles
            suiteNameWithExt=testFileNames{iFile};
            suiteName=strrep(suiteNameWithExt,'.m','');
            if flagVerbose
                disp(['** Test suite: ' suiteName])
            end
            cmd=['testResults=[testResults; ' suiteName '()];'];
            eval(cmd)
            suiteFullName=fullfile(fileName,suiteNameWithExt);
            testInfo=structMerge(testInfo,mautogradeSuiteScan(suiteFullName));
        end
        mautogradeSuiteWriter(testResults,testInfo,optsSuiteWriter{:})
    otherwise
        error(['Could not find file ' fileName '.m or directory ' fileName])
end

%Add "filePath" and "filePath/../common" to MATLAB's path
function addpathWithCommon(filePath)
addpath(filePath)
filePathCommon=fullfile(filePath,'..','common');
if exist(filePathCommon,'file')==7
    addpath(filePathCommon)
end

function testFileList=getTestFileList(dirName)
d=dir(dirName);
fileList={d(~[d.isdir]).name};
%recognize test files
flagTestFile=~cellfun(@isempty,regexpi(fileList,'(.*test\.m$|^test.*\.m$)'));
testFileList=fileList(flagTestFile);

function s=structMerge(s1,s2)
if isempty(s1)
    s=s2;
elseif isempty(s2)
    s=s1;
else
    fields=fieldnames(s2);
    s=s1;
    for iField=1:length(fields)
        s.(fields{iField})=s2.(fields{iField});
    end
end
