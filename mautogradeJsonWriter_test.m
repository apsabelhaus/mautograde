%Simple test for mautogradeJsonWriter_test, using terminal output
function mautogradeJsonWriter_test
sl=struct('name','Accuracy','value',2);
s=struct('score',44,'output','Info','leaderboard',[sl sl],'extra_data',[]);
s.('tags')={'tag1','tag2'};
mautogradeJsonWriter(1,s)
