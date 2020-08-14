%function [score,outputMsg]=mautogradeTestInOut(fhandle,data,varargin)
%Inputs
%   fhandle handle to function to test
%   data    [nbTests x 1] array of structures with fields
%       input   [1 x nbInputs] cell array with test inputs. An input can be
%       a function handle; in this case the actual input passed to the
%       function under test is obtained by running the function handle
%       (without arguments). If your input should be an actual function
%       handle, wrap it in an anonymous function (e.g., @() @sin).
%       output  [1 x nbOutputs] cell array with expected outputs
%       cmp     [1 x nbOutputs] (non-cell) array with functions to compare actual
%               and expected outputs. Each function returns true if they
%               are equivalent. Defaults to mautogradeCmpEq.
%Optional inputs
%   'fname',fname     Name of the function fTested to be used in messages.
%Outputs
%   score       Total number of outputs, across all tests, that passed
%   outputMsg   Message with what tests failed (none if all pass)
%   
function [score,outputMsg,flagPassed]=mautogradeTestInOut(fTested,dataInOut,varargin)
nbTests=length(dataInOut);
score=0;
outputMsg='';
flagPassed=true;
fTestedName=mautogradeAny2Str(fTested,'minimal');

%optional parameters
ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case 'fname'
            ivarargin=ivarargin+1;
            fTestedName=varargin{ivarargin};
        otherwise
            error(['Argument ' varargin{ivarargin} ' not valid!'])
    end
    ivarargin=ivarargin+1;
end

%replace function handle inputs with actual results
dataInOut=mautogradeTestInOutProcessInputs(dataInOut);

for iTest=1:nbTests
    inputActual=dataInOut(iTest).input;
    %prepare expected outputs
    outputExpected=mautogradeEnsureCell(dataInOut(iTest).output);
    nbOutputs=length(outputExpected);
    if nbOutputs==0
        error('The expected number of outputs is zero, there is nothing to compare')
    end
    %get actual outputs by running the function under test
    outputActual=cell(1,nbOutputs);
    switch class(fTested)
        case 'function_handle'
            [outputActual{:}]=fTested(inputActual{:});
        case 'char'
            [outputActual{:}]=eval([fTested '(inputActual{:})']);
        otherwise
            error('Handling of class of fTested not implemented');
    end
    %compare actual and expected outputs
    if isfield(dataInOut(iTest),'cmp') && ~isempty(dataInOut(iTest).cmp)
        cmp=mautogradeEnsureCell(dataInOut(iTest).cmp);
        if length(cmp)~=nbOutputs
            cmp(1:nbOutputs)=cmp;
        end
    else
        cmp=cell(1,nbOutputs);
        cmp(:)={@mautogradeCmpEq};
    end
    for iOutput=1:nbOutputs
        fEqual=cmp{iOutput};
        fractionEquivalent=double(fEqual(outputExpected{iOutput},outputActual{iOutput}));
        score=score+fractionEquivalent;
        if fractionEquivalent<1
            flagPassed=false;
            if nbTests>1
                outputMsg=mautogradeOutputAppend(outputMsg,...
                    'Failed test %d/%d at output %d/%d',...
                    iTest,nbTests,iOutput,nbOutputs);
            else
                outputMsg=mautogradeOutputAppend(outputMsg,...
                    'Failed at output %d/%d',...
                    iOutput,nbOutputs);
            end                
            outputMsg=mautogradeOutputAppend(outputMsg,...
                '> Expected output: %s',...
                mautogradeAny2Str(outputExpected{iOutput}));
            outputMsg=mautogradeOutputAppend(outputMsg,...
                '> Actual output: %s',...
                mautogradeAny2Str(outputActual{iOutput}));
            outputMsg=mautogradeOutputAppend(outputMsg,...
                '> Comparison function: %s', func2str(fEqual));
        end
    end
end
if ~flagPassed
    outputMsg=mautogradeOutputAppend(...
        ['Tested function: ' fTestedName],outputMsg);
end

