%function tests=mautogradeFunctionTests(functions)
%Run the elements of the array functions as function handles, recording if
%they fail (raise an error or exception) or pass, their names, and
%execution time
function tests=mautogradeFunctionTests(functions)
nbFunctions=length(functions);
tests=repmat(struct('Name','','Passed',0,'Failed',0,'Duration',0,'Details',[]),nbFunctions,1);
for iFunction=1:nbFunctions
    f=functions{iFunction};
    %get name of calling functions
    s=dbstack();
    tests(iFunction).Name=[s(2).name ':' func2str(f)];
    tests(iFunction).Passed=1;
    tic
    try
        f()
    catch ME
        tests(iFunction).Passed=0;
        tests(iFunction).Failed=1;
        tests(iFunction).Details=struct('identifier',ME.identifier,'message',ME.message);
    end
    tests(iFunction).Duration=toc;
end
