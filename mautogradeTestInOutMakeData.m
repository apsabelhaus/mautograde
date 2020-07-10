%Run a reference implementation, and create data for testing
%function dataInOut=mautogradeTestInOutMakeData(fTesting,dataIn)
%Inputs
%   fTesting    Handle to reference implementation of the function
%   dataIn      Array of structs with fields
%       input   Cell array with the inputs for the function
%       cmp     (optional) Function for comparing input-output (see also
%           mautogradeTestInOut)
%Optional inputs
%   'fileSaveDir',dirName   Save the file to the specified directory.
%       Enables file saving.
%   'fileSaveFlag',flag     Enable or disable file saving
%Outputs
%   dataInOut   Struct derived from dataIn that can be used with
%       mautogradeTestInOut()
%If dataInOut is not assigned, the results are saved to a file.
%Saving files
%If enabled (either through the use of flags, specifying a directory, or
%not assigning any output variable), dataInOut is saved in the file
%<fTesting>_autoTestData.mat, where <fTesting> is substituted with the name
%of the function under test.
function varargout=mautogradeTestInOutMakeData(fTesting,dataIn,varargin)
fileSaveDir='.';
fileSaveFlag=false;
fileSaveName=mautogradeAny2Str(fTesting,'minimal');
flagFileSaveCustom=false;
flagNbOutputsProvided=false;

%optional parameters
ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case 'filesavedir'
            ivarargin=ivarargin+1;
            fileSaveDir=varargin{ivarargin};
        case 'filesavename'
            flagFileSaveCustom=true;
            ivarargin=ivarargin+1;
            fileSaveName=varargin{ivarargin};
        case 'filesaveflag'
            ivarargin=ivarargin+1;
            fileSaveFlag=varargin{ivarargin};
        case 'nboutputs'
            flagNbOutputsProvided=true;
            ivarargin=ivarargin+1;
            nbOutputs=varargin{ivarargin};
        otherwise
            error(['Argument ' varargin{ivarargin} ' not valid!'])
    end
    ivarargin=ivarargin+1;
end

%replace function handle inputs with actual results
dataInOut=mautogradeTestInOutProcessInputs(dataIn);

nbTests=length(dataInOut);
if ~flagNbOutputsProvided
    nbOutputs=nargout(fTesting);
end
if nbOutputs<=0
    error(['The function under test has no output or it is anonymous, '...
        'in which case the automatic detection of the number of outputs ' ...
        'with nargout does not work; '...
        'for the latter, use the ''nbOutputs'' option' ])
end
for iTest=1:nbTests
    dataInOut(iTest).output=cell(1,nbOutputs);
    [dataInOut(iTest).output{:}]=fTesting(dataInOut(iTest).input{:});
end

%prepare data for dimensions
dataInOutDimensions=mautogradeTestInOutMakeDataDimensions(dataInOut);
dataInOutTypes=mautogradeTestInOutMakeDataTypes(dataInOut);

if nargout==0 || fileSaveFlag
    fileName=fullfile(fileSaveDir, [fileSaveName '_autoTestData']);
    fprintf('Saving %d test items to %s\n', nbTests, fileName)
    save(fileName, 'dataInOut','dataInOutDimensions','dataInOutTypes')
    
    if ~flagFileSaveCustom
        %finish preparing autoTest file
        fileNameTest=fullfile(fileSaveDir,[mautogradeAny2Str(fTesting,'minimal') '_autoTest.m']);
        if exist(fileNameTest,'file')
            % update the normalization score
            optionList=mautogradeOptionList();
            expr=['(' mautogradeOptionBaseRegexp(optionList{2}{1}) ')(\d*)'];
            maxScoreBeforeNormalization=sum(cellfun(@length,{dataInOut.output}));
            repl=['$1' num2str(maxScoreBeforeNormalization)];
            nbMatches=mautogradeRegexpReplaceInFile(fileNameTest,expr,repl);
            if nbMatches==0
                warning([mfilename ':matchNotFound'],'No MAX_SCORE_BEFORE_NORMALIZATION found in the autoTest file.')
            else
                fprintf('Updated  MAX_SCORE_BEFORE_NORMALIZATION options in the autoTest file.')
            end
            cmdMatlab=['mautogradeSuiteRunTests(''' fileNameTest ''')'];
            fprintf('To run the autoTest, try\n\t%s\n', cmdMatlab)
            if ismac
                cmd=['echo "' cmdMatlab '" | pbcopy'];
                out=system(cmd);
                if out==0
                    disp('or paste the command from the clipboard')
                end
            end
        else
            warning([mfilename ':testNotFound'],['Test file ' fileNameTest ' not found'])
        end
    end
end
if nargout>0
    varargout{1}=dataInOut;
end
