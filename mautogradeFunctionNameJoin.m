%function fullName=mautogradeFunctionNameJoin(scriptName,functionName)
%Create the name of the test by concatenating the name of the file (without
%extension) and the name of the function.
function fullName=mautogradeFunctionNameJoin(scriptName,functionName)
fullName=[scriptName '_' functionName];

