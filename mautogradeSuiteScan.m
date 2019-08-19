function functionInfo=mautogradeSuiteScan(fileName,varargin)
flagVerbose=false;

%optional parameters
ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case 'verbose'
            flagVerbose=true;
        otherwise
            error(['Argument ' varargin{ivarargin} ' not valid!'])
    end
    ivarargin=ivarargin+1;
end

fid=fopen(fileName);
if fid<0
    error(['File ' fileName ' not found'])
end

functionInfo=[];
lineParserState='searchingFunction';

while ~feof(fid)
    line=fgetl(fid);
    if flagVerbose
        disp(['state: ' lineParserState '; line: ' line])
    end
    switch lineParserState
        case 'searchingFunction'
            %Check if line defines a function, and capture name if so
            tokens=regexp(line,'^\s*function\s*(?<argoutWithEqual>[\[\],\s\w_]*=\s*)*(?<fname>\w*)','names');
            if ~isempty(tokens) && ~isempty(tokens.fname)
                currentFunctionName=tokens.fname;
                lineParserState='searchingMetadata';
                if flagVerbose
                    fprintf('Entered function %s, transition to %s\n', currentFunctionName, lineParserState);
                end
            end
        case 'searchingMetadata'
            %Start by setting default: if no metadata is found, we go back
            %to searching functions
            lineParserState='searchingFunction';
            %Check for various types of metadata, and capture if so
            %MAX_SCORE
            tokens=regexp(line,'^\s*%\s*MAX_SCORE\s*=*\s*(?<maxScore>[\d\.]+)','names');
            if ~isempty(tokens)
                name=mautogradeFunctionNameJoin(fileName,currentFunctionName);
                functionInfo.(name).score=str2double(tokens.maxScore);
                lineParserState='searchingMetadata';
                if flagVerbose
                    fprintf('Found option MAX_SCORE = %d\n', functionInfo.(name).score);
                end
            end
            %VISIBILITY
            tokens=regexp(line,'^\s*%\s*VISIBILITY\s*=*\s*(?<visibility>[\w_]+)','names');
            if ~isempty(tokens)
                name=mautogradeFunctionNameJoin(fileName,currentFunctionName);
                functionInfo.(name).visibility=tokens.visibility;
                lineParserState='searchingMetadata';
                if flagVerbose
                    fprintf('Found option VISIBILITY = %s\n', functionInfo.(name).visibility);
                end
            end
            if flagVerbose && strcmp(lineParserState,'searchingFunction')
                fprintf('Found non-option line, transitioning to %s\n', lineParserState);
            end
    end
end

fclose(fid);
        