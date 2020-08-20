function testResults = ${function_name}_autoTest
testResults = mautogradeFunctionRunTests(localfunctions);
end

function [score,output]=hinter(testCase)
% MAX_SCORE = 0.3
% MAX_SCORE_BEFORE_NORMALIZATION = 1
[score,output]=mautogradeTestStyleHinter(testCase.functionTestedFileName);
end

function [score,output]=dimensionsAssigned(testCase)
% MAX_SCORE = 0.1
% MAX_SCORE_BEFORE_NORMALIZATION = 1
load([testCase.functionTestedStr '_autoTestData.mat'],'dataInOutDimensions')
for iData=1:numel(dataInOutDimensions)
    dataInOutDimensions(iData).output={${output_dimensions}};
    dataInOutDimensions(iData).cmp={@(x,y) mautogradeCmpEq(x,y,'NaNWildcard')};
end
[score,output]=mautogradeTestInOutDimensions(testCase.functionTested,dataInOutDimensions);
end

function [score,output]=dimensions(testCase)
% MAX_SCORE = 0.1
% MAX_SCORE_BEFORE_NORMALIZATION = 1
load([testCase.functionTestedStr '_autoTestData.mat'],'dataInOutDimensions')
[score,output]=mautogradeTestInOutDimensions(testCase.functionTested,dataInOutDimensions);
end

function [score,output]=type(testCase)
% MAX_SCORE = 0.1
% MAX_SCORE_BEFORE_NORMALIZATION = 1
load([testCase.functionTestedStr '_autoTestData.mat'],'dataInOutTypes')
[score,output]=mautogradeTestInOutTypes(testCase.functionTested,dataInOutTypes);
end

function [score,output]=inOut(testCase)
% MAX_SCORE_BEFORE_NORMALIZATION = 1
load([testCase.functionTestedStr '_autoTestData.mat'],'dataInOut')
[score,output]=mautogradeTestInOut(testCase.functionTested,dataInOut);
end