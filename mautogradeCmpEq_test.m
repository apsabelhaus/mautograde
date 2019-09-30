function tests = mautogradeCmpEq_test
global matrix1 matrix2 cell1 cell2 struct1 struct2 struct3
global arrayStruct1 arrayStruct2
matrix1=ones(2,3);
matrix2=[1 1 1; randn() randn() 1];
cell1={matrix1 matrix2};
cell2={matrix1 matrix1};
struct1=struct('matrix',matrix1,'cell',{cell1});
struct2=struct('matrix',matrix2,'cell',{cell2});
struct3=struct('matrix',matrix1);
arrayStruct1=[struct1;struct2];
arrayStruct2=[struct2;struct2];

tests = functiontests(localfunctions);

function testDouble(~)
global matrix1
fractionCorrect=mautogradeCmpEq(matrix1,matrix1);
assert(fractionCorrect==1)

function testDoubleFail(~)
global matrix1 matrix2
fractionCorrect=mautogradeCmpEq(matrix1,matrix2);
assert(fractionCorrect==2/3)

function testDoubleRawCounts(~)
global matrix1 matrix2
[fractionCorrect,totalItems]=...
    mautogradeCmpEq(matrix1,matrix2,'rawCounts');
assert(fractionCorrect==4)
assert(totalItems==6)

function testCell(~)
global cell1
fractionCorrect=mautogradeCmpEq(cell1,cell1);
assert(fractionCorrect==1)

function testCellFail(~)
global cell1 cell2
fractionCorrect=mautogradeCmpEq(cell1,cell2);
assert(fractionCorrect==5/6)

function testCellRawCounts(~)
global cell1 cell2
[fractionCorrect,totalItems]=...
    mautogradeCmpEq(cell1,cell2,'rawCounts');
assert(fractionCorrect==10)
assert(totalItems==12)

function testStruct(~)
global struct1
fractionCorrect=mautogradeCmpEq(struct1,struct1);
assert(fractionCorrect==1)

function testStructFail(~)
global struct1 struct2
fractionCorrect=mautogradeCmpEq(struct1,struct2);
assert(fractionCorrect==14/18)

function testStructRawCounts(~)
global struct1 struct2
[fractionCorrect,totalItems]=...
    mautogradeCmpEq(struct1,struct2,'rawCounts');
assert(fractionCorrect==14)
assert(totalItems==18)

function testStructFailFields(~)
global struct1 struct3
fractionCorrect=mautogradeCmpEq(struct1,struct3);
assert(fractionCorrect<1)

function testArrayStruct(~)
global arrayStruct1
fractionCorrect=mautogradeCmpEq(arrayStruct1,arrayStruct1);
assert(fractionCorrect==1)

function testArrayStructFail(~)
global arrayStruct1 arrayStruct2
fractionCorrect=mautogradeCmpEq(arrayStruct1,arrayStruct2);
assert(fractionCorrect==32/36)

function testArrayStructRawCounts(~)
global arrayStruct1 arrayStruct2
[fractionCorrect,totalItems]=...
    mautogradeCmpEq(arrayStruct1,arrayStruct2,'rawCounts');
assert(fractionCorrect==32)
assert(totalItems==36)