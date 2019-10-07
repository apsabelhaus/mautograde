%Convert input to char array if it is not yet
function s=mautogradeEnsureChar(s)
switch class(s)
    case 'char'
        %nothing to do
    case 'function_handle'
        s=func2str(s);
    otherwise
        if isnumeric(s) || islogical(s)
            s=num2str(s);
        else
            error('Conversion to string not implemented for this type')
        end
end

