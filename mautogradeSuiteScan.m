function functionInfo=mautogradeSuiteScan(fileName)
fid=fopen(fileName);
if fid<0
    error(['File ' fileName ' not found'])
end

functionInfo=[];
lineParserState='searchingFunction';

while ~feof(fid)
    line=fgetl(fid);
    switch lineParserState
        case 'searchingFunction'
            %Check if line defines a function, and capture name if so
            tokens=regexp(line,'^\s*function\s*(?<argoutWithEqual>[\[\],\s\w_]*=\s*)*(?<fname>\w*)','names');
            if ~isempty(tokens) && ~isempty(tokens.fname)
                currentFunctionName=tokens.fname;
                lineParserState='searchingMetadata';
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
            end
            %VISIBILITY
            tokens=regexp(line,'^\s*%\s*VISIBILITY\s*=*\s*(?<visibility>[\w_]+)','names');
            if ~isempty(tokens)
                name=mautogradeFunctionNameJoin(fileName,currentFunctionName);
                functionInfo.(name).visibility=tokens.visibility;
                lineParserState='searchingMetadata';
            end
    end
end

fclose(fid);
        