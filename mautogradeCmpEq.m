function [fractionCorrect,totalItems]=mautogradeCmpEq(expected, actual, varargin)
flagUseTol=false;       %use tolerance
flagRawCounts=false;    %recursive call, return raw counts

%optional parameters
ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case 'tol'
            flagUseTol=true;
            ivarargin=ivarargin+1;
            tol=varargin{ivarargin};
        case 'rawcounts'
            flagRawCounts=true;
        otherwise
            error(['Argument ' varargin{ivarargin} ' not valid!'])
    end
    ivarargin=ivarargin+1;
end
    
switch class(expected)
    case 'double'
        if ~flagUseTol
            tol=0;
        end
        fractionCorrect=cmpSize(expected,actual)*sum(abs(expected(:)-actual(:))<=tol);
        totalItems=length(expected(:));
    case {'char','logical'}
        fractionCorrect=cmpSize(expected,actual)*sum(expected(:)==actual(:));
        totalItems=length(expected(:));
    case 'struct'
        [fractionCorrect,totalItems]=cmpStruct(expected,actual);
    case 'cell'
        [fractionCorrect,totalItems]=cmpCell(expected,actual);
    otherwise
        error('Type not supported')
end

if ~flagRawCounts
    fractionCorrect=fractionCorrect/totalItems;
end

function flagDouble=cmpSize(expected,actual)
flagDouble=double(all(size(expected)==size(actual)));

function [fractionCorrect,totalItems]=cmpCell(expected,actual)
flag=cmpSize(expected,actual);
fractionCorrect=0;
if flag>0
    totalItems=0;
    for iCell=1:numel(expected)
        [fractionCorrectCell,totalItemsCell]=...
            mautogradeCmpEq(expected{iCell},actual{iCell},'rawCounts');
        fractionCorrect=fractionCorrect+fractionCorrectCell;
        totalItems=totalItems+totalItemsCell;
    end
else
    totalItems=numel(expected);
end

function [fractionCorrect,totalItems]=cmpStruct(expected, actual)
flag=cmpSize(expected,actual);
fractionCorrect=0;
if flag>0
    totalItems=0;
    nbElements=numel(expected);
    if numel(expected)>1
        %handle arrays by doing recursive call on each (struct) element
        for iElement=1:nbElements
            [fractionCorrectCell,totalItemsCell]=...
                mautogradeCmpEq(expected(iElement),actual(iElement),'rawCounts');
            fractionCorrect=fractionCorrect+fractionCorrectCell;
            totalItems=totalItems+totalItemsCell;
        end
    else
        fieldsExpected=fieldnames(expected);
        fieldsActual=fieldnames(actual);
        flagFields=cmpCell(fieldsExpected,fieldsActual);
        fractionCorrect=0;
        if flagFields>0
            for iField=1:numel(fieldsExpected)
                fieldName=fieldsExpected{iField};
                [fractionCorrectCell,totalItemsCell]=...
                    mautogradeCmpEq(expected.(fieldName),actual.(fieldName),'rawCounts');
                fractionCorrect=fractionCorrect+fractionCorrectCell;
                totalItems=totalItems+totalItemsCell;
            end
        else
            totalItems=numel(fieldsExpected);
        end
    end
else
    totalItems=numel(expected);
end
