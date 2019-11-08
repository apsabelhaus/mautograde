%Returns the base regexp used to match options in a test file
%function optionBaseExpr=mautogradeOptionBaseRegexp()
%See mautogradeSuiteScan for an example.
function optionBaseExpr=mautogradeOptionBaseRegexp(optionName)
optionBaseExpr=['^\s*%\s*\<' optionName '\>\s*=*\s*'];
