%Generate default description of test from its name
%function description=mautogradeFunctionDescriptionDefault(fName)
function description=mautogradeFunctionDescriptionDefault(fName)
description='';
if regexp(fName,'_dimensions$')
    description='Check that the dimensions of each output are as expected for typical inputs';
end
if regexp(fName,'_types$')
    description='Check that the types of each output are as expected for typical inputs';
end
if regexp(fName,'_inOut$')
    description='Check outputs for some fixed random inputs';
end

