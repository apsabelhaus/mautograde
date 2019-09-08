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
    %get name of calling functions
    s=dbstack();
    fName=func2str(f);
    tests(iFunction).Name=mautogradeFunctionNameJoin(s(2).name,fName);
    tests(iFunction).Passed=1;
    tic
    output='';
    try
        switch nargout(f)
            case 0
                f()
                score=NaN;
            case 1
                score=f();
            case 2
                [score,output]=f();
        end
    catch ME
        if ~flagRethrowNonAssertionErrors || strcmp(ME.identifier,'MATLAB:assertion:failed')
            score=0;
            tests(iFunction).Passed=0;
            tests(iFunction).Failed=1;
            tests(iFunction).Details=struct('identifier',ME.identifier,'message',ME.message);
            output=mautogradeAny2Str(ME.stack);
        else
            rethrow(ME)
        end
    end
    tests(iFunction).TextOutput=output;
    tests(iFunction).Duration=toc;
    tests(iFunction).Score=score;
end
