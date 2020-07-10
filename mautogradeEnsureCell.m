%Ensure that a variable is a cell array
%function a=mautogradeEnsureCell(a)
%If the input a is not a cell array, wrap the variable into a cell
function a=mautogradeEnsureCell(a)
if ~iscell(a)
    a={a};
end