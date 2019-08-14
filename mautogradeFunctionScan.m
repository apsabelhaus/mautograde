function functionInfo=mautogradeFunctionScan(fileName)
fid=fopen(fileName);
if fid<0
    error(['File ' fileName ' not found'])
end

scriptName=strrep(fileName,'.m','');

functionInfo=[];
while ~feof(fid)
    line1=fgetl(fid);
    %Check if line defines a function, and capture name if so
    tokens1=regexp(line1,'^\s*function\s*(?<argoutWithEqual>\w*\s*=\s*)*(?<fname>\w*)','names');
    if ~isempty(tokens1) && ~isempty(tokens1.fname)
        line2=fgetl(fid);
        %Check if the next line is metadata, and capture it if so
        tokens2=regexp(line2,'^\s*%\s*MAX_SCORE\s*=*\s*(?<maxScore>[\d\.]+)','names');
        if ~isempty(tokens2)
            name=mautogradeFunctionNameJoin(scriptName,tokens1.fname);
            functionInfo.(name)=str2double(tokens2.maxScore);
        end
    end
end

fclose(fid);
        