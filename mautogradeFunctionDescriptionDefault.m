%Generate default description of a test from its name via regexp match
%function description=mautogradeFunctionDescriptionDefault(fName)
%Run
%   mautogradeFunctionDescriptionDefault -help
%to get a list of regular expressions and the corresponding descriptions
function description=mautogradeFunctionDescriptionDefault(fName)
description='';
regexpPairs={
    {'_dimensions$','Check that the dimensions of each output are as expected for typical inputs'}
    {'_types$','Check that the types of each output are as expected for typical inputs'}
    {'_inOut$','Check outputs for some fixed random inputs'}
    {'_hinter$','Run matlabStyleHinter'}
    };

if strcmpi(fName,'-help')
    disp(mautogradeAny2Str(regexpPairs))
else
    for iRegexp=1:length(regexpPairs)
        if regexp(fName,regexpPairs{iRegexp}{1})
            description=regexpPairs{iRegexp}{2};
        end
    end
end

