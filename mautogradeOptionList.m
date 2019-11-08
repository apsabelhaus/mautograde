%Returns the list of options that can be matched in a test file
%function optionList=mautogradeOptionList()
%See mautogradeSuiteScan for an example.
function optionList=mautogradeOptionList()
optionList={
    {'MAX_SCORE','scoreMax','double'}
    {'MAX_SCORE_BEFORE_NORMALIZATION','scoreNormalization','double'}
    {'VISIBILITY','visibility','char'}
    {'DESCRIPTION','description','char'}
    };
