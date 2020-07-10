%Compare two arrays or cell arrays regardless of ordering
%function [fractionCorrect,totalItems]=mautogradeCmpEq(expected, actual, varargin)
%Returns the IoU (Intersection over Union) metric for the two input
%collections. This function works directly only on the collections supported by the
%functions union and intersection; otherwise, each element of the
%collection will be attempted to be converted to a string (using
%mautogradeAny2Str) before comparison.
%Inputs
%   expected, actual: arrays or cell arrays to compare
%Optional inputs
%   'rawCounts'         fractionCorrect returns the actual number of
%                       coinciding elements instead of a fraction between 0
%                       and 1 
%Outputs
%   fractionCorrect     fraction (between 0 and 1) or actual count (with
%                       'rawCounts' option) of how many element coincide 
%   totalItems          total numbe of items in the expected collection
function [fractionCorrect,totalItems]=mautogradeCmpSetIoU(expected, actual, varargin)
flagRawCounts=false;

%optional parameters
ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case 'rawcounts'
            flagRawCounts=true;
        otherwise
            error(['Argument ' varargin{ivarargin} ' not valid!'])
    end
    ivarargin=ivarargin+1;
end

if ~isCellTypeCompatible(expected) || ~isCellTypeCompatible(actual)
    if isa(expected,'cell') || isa(actual,'cell')
        expected=cellfun(@mautogradeAny2Str,mautogradeEnsureCell(expected),'UniformOutput',false);
        actual=cellfun(@mautogradeAny2Str,mautogradeEnsureCell(actual),'UniformOutput',false);
    elseif isa(expected,'struct') && isa(actual,'struct')
        %two struct arrays, compare by string representations
        expected=arrayfun(@mautogradeAny2Str,expected,'UniformOutput',false);
        actual=arrayfun(@mautogradeAny2Str,actual,'UniformOutput',false);
    else
        error('Types not supported')
    end
end

if isempty(expected) && isempty(actual)
    totalItems=1;
    fractionCorrect=1;
else
    totalItems=length(expected);
    fractionCorrect=length(intersect(expected,actual))/length(union(expected,actual));
end

if flagRawCounts
    fractionCorrect=fractionCorrect*totalItems;
end

function flag=isCellTypeCompatible(c)
flag=isnumeric(c) || all(cellfun(@isnumeric,c)) || all(cellfun(@ischar,c));
