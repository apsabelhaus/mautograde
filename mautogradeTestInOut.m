%function [score,outputMsg]=mautogradeTestInOut(fhandle,data)
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
%               are equivalent.
%Optional inputs
%   'nbOutputs',nbOutputs     Number of outputs of fhandle (necessary if 
function [score,outputMsg]=mautogradeTestInOut(fTested,dataInOut,varargin)
nbTests=length(dataInOut);
score=0;
outputMsg='';

for iTest=1:nbTests
    %replace function handle inputs with actual results
    inputActual=mautogradeEnsureCell(dataInOut(iTest).input);
    for iInput=1:length(inputActual)
        if isa(inputActual{iInput},'function_handle')
            inputActual{iInput}=inputActual{iInput}();
        end
    end
    %prepare expected outputs
    outputExpected=mautogradeEnsureCell(dataInOut(iTest).output);
    nbOutputs=length(outputExpected);
    %get actual outputs by running the function under test
    outputActual=cell(1,nbOutputs);
    [outputActual{:}]=fTested(inputActual{:});
    %compare actual and expected outputs
    cmp=mautogradeEnsureCell(dataInOut(iTest).cmp);
    if length(cmp)~=nbOutputs
        cmp(1:nbOutputs)=cmp;
    end
    for iOutput=1:nbOutputs
        fEqual=cmp{iOutput};
        flagOutputEquivalent=fEqual(outputActual{iOutput},outputExpected{iOutput});
        if flagOutputEquivalent
           score=score+1;
        else
           outputMsg=mautogradeAppendOutput(outputMsg,...
               'Failed equality test %d/%d at output %d/%d',...
               iTest,nbTests,iOutput,nbOutputs);
           outputMsg=mautogradeAppendOutput(outputMsg,...
               'Tested function: %s', func2str(fTested));
           outputMsg=mautogradeAppendOutput(outputMsg,...
                'Comparison function: %s', func2str(fEqual));
           outputMsg=mautogradeAppendOutput(outputMsg,...
                'Output from tested function: %s',...
                mautogradeAny2Str(outputActual{iOutput}));
           outputMsg=mautogradeAppendOutput(outputMsg,...
                'Expected output: %s',...
                mautogradeAny2Str(outputExpected{iOutput}));
         end
    end
end

