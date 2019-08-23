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
        flag=and(flag,mautogradeCmpEq(expected{iCell},actual{iCell}));
        if ~flag
            %break early if one of the cells does not match
            break
        end
    end
end

function flag=cmpStruct(expected, actual)
flag=cmpSize(expected,actual);
if flag
    nbElements=numel(expected);
    if numel(expected)>1
        for iElement=1:nbElements
            flag=and(flag,mautogradeCmpEq(expected(iElement),actual(iElement)));
        end
    else
        fieldsExpected=fieldnames(expected);
        fieldsActual=fieldnames(actual);
        flag=cmpCell(fieldsExpected,fieldsActual);
        if flag
            for iField=1:numel(fieldsExpected)
                fieldName=fieldsExpected{iField};
                flag=and(flag,mautogradeCmpEq(expected.(fieldName),actual.(fieldName)));
                if ~flag
                    %break early if one of the fields does not match
                    break
                end
            end
        end
    end
end