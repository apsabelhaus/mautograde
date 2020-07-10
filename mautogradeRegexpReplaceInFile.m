%Run regexprep on a file instead of a string
%function nbMatches=mautogradeRegexpReplaceInFile(fileName, varargin)
%Useful for functions that build test suites from templates, e.g., see
%mautogradeTestInOutMakeData. 
%Inputs
%   fileName    name of the file on which to perform the search and replace
%   varargin    these arguments are passed to regexprep
%Outputs
%   nbMatches   total number of matches in the file for the given expression
function nbMatches=mautogradeRegexpReplaceInFile(fileName, varargin)
flagCountMatches=nargout>0;
if ~exist(fileName, 'file')
    error('mautogradeRegexpReplaceInFile:no_file', 'File not found');
end

% Read the entire file with lines in a cell array
fid=fopen(fileName); 
text=textscan(fid,'%s','Delimiter','','Whitespace','');
text=text{1};
fclose(fid);

% Count number of matches (substitutions that will be done), if necessary
if flagCountMatches
    nbMatches=sum(cellfun(@length,regexp(text,varargin{1})));
end

% Find and replace.
text = regexprep(text, varargin{:});

% Write out the new file.
fid = fopen(fileName, 'w');
fprintf(fid,['%s' newline()],text{:});
fclose(fid);
