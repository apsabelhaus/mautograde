%Count how many elments in actual are the same as expected
%function [fractionCorrect,totalItems]=mautogradeCmpEq(expected, actual, varargin)
%Note: For composite types (e.g., arrays, cell arrays, structs), equality is tested on
%individual elements or fields, counting each one of them as a separate
%element, with this rule applied recursively until a fundamental type is
%encountered.
%Known limitation: Handling of Inf and NaN's might be incorrect
%Inputs
%   expected, actual: arrays or cell arrays to compare
%Outputs
%   fractionCorrect     fraction (between 0 and 1) of how many element coincide
%   totalItems          total numbe of items compared
%Optional inputs
%   'tol',tol           for elements of type double, check equality with
%                       tolerance tol
%   'shiftdim'          for elements of type double, apply shiftdim before
%                       comparing
%   'NaNWildcard'       for doubles, expected entries marked with NaN will
%                       match any actual value
function [fractionCorrect,totalItems]=mautogradeCmpEq(expected, actual, varargin)
flagUseTol=false;       %use tolerance
flagRawCounts=false;    %return raw counts (useful for recursive calls)
flagShiftDim=false;
flagNaNWildcard=false;

%optional parameters
ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case 'tol'
            flagUseTol=true;
            ivarargin=ivarargin+1;
            tol=varargin{ivarargin};
        case 'shiftdim'
            flagShiftDim=true;
        case 'rawcounts'
            flagRawCounts=true;
        case 'nanwildcard'
            flagNaNWildcard=true;
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
        if flagNaNWildcard
            flagExpectedIsNaN=isnan(expected);
            expected=expected(~flagExpectedIsNaN);
            actual=actual(~flagExpectedIsNaN);
        end
        if flagShiftDim
            expected=shiftdim(expected);
            actual=shiftdim(actual);
        end
        if cmpSize(expected,actual)
            if isempty(expected)
                fractionCorrect=1;
            else
                flagExpectedIsNaN=isnan(expected);
                fractionCorrect=sum(isnan(actual(flagExpectedIsNaN)));
                fractionCorrect=fractionCorrect+sum(abs(expected(~flagExpectedIsNaN)-actual(~flagExpectedIsNaN))<=tol);
            end
        else
            fractionCorrect=0;
        end
        %we count empty arrays still as one item to compare
        if isempty(expected)
            totalItems=1;
        else
            totalItems=numel(expected(:));
        end
    case {'char','logical'}
        if cmpSize(expected,actual)
            fractionCorrect=sum(expected(:)==actual(:));
        else
            fractionCorrect=0;
        end
        totalItems=length(expected(:));
    case 'struct'
        [fractionCorrect,totalItems]=cmpStruct(expected,actual,varargin{:});
    case 'cell'
        [fractionCorrect,totalItems]=cmpCell(expected,actual,varargin{:});
    otherwise
        error('Type not supported')
end

if ~flagRawCounts
    if totalItems~=0
        fractionCorrect=fractionCorrect/totalItems;
    end
end

function flag=cmpSize(expected,actual)
flag=all(size(expected)==size(actual));

function [fractionCorrect,totalItems]=cmpCell(expected,actual,varargin)
flag=cmpSize(expected,actual);
fractionCorrect=0;
if flag
    totalItems=0;
    for iCell=1:numel(expected)
        [fractionCorrectCell,totalItemsCell]=...
            mautogradeCmpEq(expected{iCell},actual{iCell},'rawCounts',varargin{:});
        fractionCorrect=fractionCorrect+fractionCorrectCell;
        totalItems=totalItems+totalItemsCell;
    end
else
    totalItems=numel(expected);
end

function [fractionCorrect,totalItems]=cmpStruct(expected, actual,varargin)
flag=cmpSize(expected,actual);
fractionCorrect=0;
if flag
    totalItems=0;
    nbElements=numel(expected);
    if numel(expected)>1
        %handle arrays by doing recursive call on each (struct) element
        for iElement=1:nbElements
            [fractionCorrectCell,totalItemsCell]=...
                mautogradeCmpEq(expected(iElement),actual(iElement),'rawCounts',varargin{:});
            fractionCorrect=fractionCorrect+fractionCorrectCell;
            totalItems=totalItems+totalItemsCell;
        end
    else
        fieldsExpected=fieldnames(expected);
        fieldsActual=fieldnames(actual);
        %check if fieldsActual has all the expected field
        %Note: this ignores any extra field in fieldsActual
        flagFields=isempty(setdiff(fieldsExpected,fieldsActual));
        fractionCorrect=0;
        if flagFields>0
            for iField=1:numel(fieldsExpected)
                fieldName=fieldsExpected{iField};
                [fractionCorrectCell,totalItemsCell]=...
                    mautogradeCmpEq(expected.(fieldName),actual.(fieldName),'rawCounts',varargin{:});
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
