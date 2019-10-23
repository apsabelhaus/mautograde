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
%       mautogradeTestInOut)
%If dataInOut is not assigned, the results are saved to a file.
%Saving files
%If enabled (either through the use of flags, specifying a directory, or
%not assigning any output variable), dataInOut is saved in the file
%<fTesting>_autoTestData.mat, where <fTesting> is substituted with the name
%of the function under test.
function varargout=mautogradeTestInOutMakeData(fTesting,dataIn,varargin)
fileSaveDir='.';
fileSaveFlag=false;

%optional parameters
ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case 'filesavedir'
            ivarargin=ivarargin+1;
            fileSaveDir=varargin{ivarargin};
        case 'filesaveflag'
            ivarargin=ivarargin+1;
            fileSaveFlag=varargin{ivarargin};
        otherwise
            error(['Argument ' varargin{ivarargin} ' not valid!'])
    end
    ivarargin=ivarargin+1;
end

%replace function handle inputs with actual results
dataInOut=mautogradeTestInOutProcessInputs(dataIn);

nbTests=length(dataInOut);
nbOutputs=nargout(fTesting);
for iTest=1:nbTests
    dataInOut(iTest).output=cell(1,nbOutputs);
    [dataInOut(iTest).output{:}]=fTesting(dataInOut(iTest).input{:});
end
if nargout==0 || fileSaveFlag
    fileName=fullfile(fileSaveDir,[mautogradeEnsureChar(fTesting) '_autoTestData']);
    disp(['Saving to ' fileName])
    save(fileName, 'dataInOut')
    fileNameTest=fullfile(fileSaveDir,[mautogradeEnsureChar(fTesting) '_autoTest']);
    cmdMatlab=['mautogradeSuiteRunTests(''' fileNameTest ''')'];
    fprintf('To run the test, try\n\t%s\n', cmdMatlab)
    if ismac
        cmd=['echo "' cmdMatlab '" | pbcopy'];
        out=system(cmd);
        if out==0
            disp('or paste the command from the clipboard')
        end
    end
end
if nargout>0
    varargout{1}=dataInOut;
end
