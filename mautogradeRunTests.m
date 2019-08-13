%function mautogradeRunTests(fileName)
%Run the mAutograde test script in fileName.m, then write the results to
%standard output. If fileName is not the name of a file but it is the name
%of a directory, look for all the files starting/ending with "test" in that
%directory, and run tem as mAutograde scripts. If fileName is empty, use
%the current directory
function mautogradeRunTests(fileName)
switch exist(fileName,'file')
    case 2
        eval(['testResults= ' fileName '();'])
        testInfo=mAutogradeFunctionScan(fileName);
        mautogradeJsonResults(testResults,testInfo)
    case 7
        testFileNames=getTestFileList(fileName);
        addpath(fileName)
        testResults=[];
        testInfo=[];
        for iFile=1:length(testFileNames)
            scriptFullName=testFileNames{iFile};
            scriptName=strrep(scriptFullName,'.m','');
            cmd=['testResults=[testResults; ' scriptName '()];'];
            eval(cmd)
            testInfo=structMerge(testInfo,mautogradeFunctionScan(scriptFullName));
        end
        mautogradeJsonResults(testResults,testInfo)
    otherwise
        error(['Could not find file ' fileName '.m or directory ' fileName])
end

function testFileList=getTestFileList(dirName)
d=dir(dirName);
fileList={d(~[d.isdir]).name};
%recognize test files
flagTestFile=~cellfun(@isempty,regexpi(fileList,'(.*test\.m$|test.*\.m$)'));
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
