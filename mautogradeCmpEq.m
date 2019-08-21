function flag=mautogradeCmpEq(expected, actual)
switch class(expected)
    case {'double', 'char'}
        flag=cmpSize(expected,actual) && all(expected(:)==actual(:));
    case 'struct'
        flag=cmpStruct(expected,actual);
    case 'cell'
        flag=cmpCell(expected,actual);
    case 'logical'
        flag=all(expected(:)==actual(:));
    otherwise
        error('Type not supported')
end

function flag=cmpSize(expected,actual)
flag=all(size(expected)==size(actual));
        
function flag=cmpCell(expected,actual)
flag=cmpSize(expected,actual);
if flag
    for iCell=1:numel(expected)
        flag=and(flag,mautogradeTestCmpEq(expected{iCell},actual{iCell}));
        if ~flag
            %break early if one of the cells does not match
            break
        end
    end
end

function flag=cmpStruct(expected, actual)
fieldsExpected=fieldnames(expected);
fieldsActual=fieldnames(actual);
flag=cmpCell(fieldsExpected,fieldsActual);
if flag
    for iField=1:numel(fieldsExpected)
        fieldName=fieldsExpected{iField};
        flag=and(flag,mautogradeTestCmpEq(expected.(fieldName),actual.(fieldName)));
        if ~flag
            %break early if one of the cells does not match
            break
        end
    end
end
