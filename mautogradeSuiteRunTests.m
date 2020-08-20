%function mautogradeRunTests(fileName)
%Run the mAutograde test suite in fileName.m, then write the results to
%standard output. 
%Inputs
%   fileName    name of the test suite file. If fileName is not the name of
%       a file but it is the name of a directory, look for all the files
%       starting/ending with "test" in that directory, and run tem as
%       mAutograde suites. If fileName is empty, use the current directory.

% TODO: extract a "runSuite" function

function mautogradeSuiteRunTests(fileName)
flagVerbose=false;

switch exist(fileName,'file')
    case 2
        %fileName is an actual .m file
        [filePath,suiteName]=fileparts(fileName);
        if ~isempty(filePath) && ~strcmp(filePath,'.')
            addpath(filePath)
        end
        fileName=[suiteName,'.m'];
        if flagVerbose
            disp(['** Test suite: ' suiteName])
        end
        eval(['testResults= ' suiteName '();'])
        testInfo=mautogradeSuiteScan(fileName);
        mautogradeSuiteJsonWriter(testResults,testInfo)
    case 7
        %fileName is a directory
        testFileNames=getTestFileList(fileName);
        addpath(fileName)
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
        mautogradeSuiteJsonWriter(testResults,testInfo)
    otherwise
        error(['Could not find file ' fileName '.m or directory ' fileName])
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
