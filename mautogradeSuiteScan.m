%Scan a test suite for options
%function functionInfo=mautogradeSuiteScan(fileName,varargin)
%Inputs
%   fileName    name of the test suite to scan
%Optional inputs
%   'verbose'   display additional information from the parser
%Run 
%   mautogradeOptionList -help
%To see a list of recognized options

%The function processes each line of a file in sequence, and implements a
%parser with two states (lineParserState):
%   'searchingFunction' looks for the start of a function, transitions to
%       the 'searchingMetadata' state
%   'searchingMetadata' looks for recognized options. If none are found,
%       transistion to the 'searchingFunction' state
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
            optionList=mautogradeOptionList();
            
            nbOptionList=length(optionList);
            for iOption=1:nbOptionList
                option=optionList{iOption};
                optionName=option{1};
                optionVarName=option{2};
                optionType=option{3};
                
                %check for the presence of the option and capture it
                expr=[mautogradeOptionBaseRegexp(optionName) '(?<' optionVarName '>.+)'];
                tokens=regexp(line,expr,'names');
                if ~isempty(tokens) && ~isempty(tokens.(optionVarName))
                    switch optionType
                        case 'char'
                            var=tokens.(optionVarName);
                        case 'double'
                            var=str2double(tokens.(optionVarName));
                        otherwise
                            error(['Conversion of option of type ' optionType ' not implemented']);
                    end
                    name=mautogradeFunctionNameJoin(fileName,currentFunctionName);
                    functionInfo.(name).(optionVarName)=var;
                    lineParserState='searchingMetadata';
                    if flagVerbose
                        fprintf('Found option %s = %s\n', optionName, num2str(var));
                    end
                    
                end
            end
            
            if flagVerbose && strcmp(lineParserState,'searchingFunction')
                fprintf('Found non-option line, transitioning to %s\n', lineParserState);
            end
    end
end

fclose(fid);
        