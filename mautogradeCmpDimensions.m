%Compare array dimensions
%function [fractionCorrect,totalItems]=mautogradeCmpDimensions(expected,actual)
%Works as CmpEq with 'NaNWildcard', but with a special check for empty
%dimensions: if the product of expected dimensions is zero, matches any
%actual dimensions whose product is also equal to zero.
%Optional inputs
%   'AllowWildcardEmptyExpansion'   If there is a NaN wildcard in the
%       expected value, allow the wildcard to be zero (hence matching any
%       empty actual dimensions)

function [fractionCorrect,totalItems]=mautogradeCmpDimensions(expected,actual,varargin)
flagAllowWildcardEmptyExpansion=false;
%optional parameters
ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case 'allowwildcardemptyexpansion'
            flagAllowWildcardEmptyExpansion=true;
        otherwise
            disp(varargin{ivarargin})
            error('Argument not valid!')
    end
    ivarargin=ivarargin+1;
end
if ~all(size(expected)==[1 2]) || ~all(size(expected)==[1 2])
    error('Expected comparoson of dimensions ([1x2] vectors)')
end
if prod(expected)==0
    fractionCorrect=double(prod(actual)==0);
    totalItems=2;
elseif prod(actual)==0 && any(isnan(expected)) && flagAllowWildcardEmptyExpansion
    fractionCorrect=1;
    totalItems=2;
else
    [fractionCorrect,totalItems]=mautogradeCmpEq(expected,actual,'NaNWildcard');
end