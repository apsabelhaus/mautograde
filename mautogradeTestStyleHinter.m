%Run a test based on matlabStyleHinter
%function [score,outputMsg]=mautogradeTestStyleHinter(fileName,varargin)
%Inputs
%   fileName    name of the file with the function to analyze
%Optional inputs
%   'scoreMax',s    maximum score for no errors
%   'scoreMin',s    minimum possible score
%   'scoreItem',s   score to subtract from scoreMax for every item found by
%                   the hinter
%Outputs
%   As other test functions
function [score,outputMsg]=mautogradeTestStyleHinter(fileName,varargin)
scoreMax=0.3;
scoreMin=0.0;
scoreItem=0.1;
%optional parameters
ivarargin=1;
while ivarargin<=numel(varargin)
    switch lower(varargin{ivarargin})
        case 'scoremax'
            ivarargin=ivarargin+1;
            scoreMax=varargin{ivarargin};
        case 'scoremin'
            ivarargin=ivarargin+1;
            scoreMin=varargin{ivarargin};
        case 'scoreitem'
            ivarargin=ivarargin+1;
            scoreItem=varargin{ivarargin};
        otherwise
            error(['Argument ' varargin{ivarargin} ' not valid!'])
    end
    ivarargin=ivarargin+1;
end

[nbItems,output]=matlabStyleHinter(fileName);
outputMsg=mautogradeOutputFromCell(output);
score=max(scoreMax-nbItems*scoreItem,scoreMin);
