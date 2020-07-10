%Returns the list of options that can be matched in a test file
%function optionList=mautogradeOptionList()
%See mautogradeSuiteScan for an example.
%Inputs
%   flagHelp    If equal to '-help', show all recognized options
function optionList=mautogradeOptionList(flagHelp)
optionList={
    {'MAX_SCORE','scoreMax','double','Maximum score shown in Gradescope'}
    {'MAX_SCORE_BEFORE_NORMALIZATION','scoreNormalization','double', 'Normalization constant for the score before reporting in Gradescope'}
    {'VISIBILITY','visibility','char', 'Control visibility (see Gradescope help for possible settings'}
    {'DESCRIPTION','description','char', 'Description to be added to the Gradscope output for the test. See also mautogradeFunctionDescriptionDefault()'}
    };
if exist('flagHelp','var') && strcmpi(flagHelp,'-help')
    disp(mautogradeAny2Str(optionList))
end