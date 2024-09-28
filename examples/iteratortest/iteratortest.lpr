program iteratortest;

{$mode Delphi}{$H+}
{$ModeSwitch nestedprocvars}
{$Codepage UTF8}

uses
  heaptrc, Classes, Contnrs, SysUtils, iterators, iterators.base, Generics.Collections,
  TupleTypes, nullable

  {$IfDef WINDOWS} // Utf8 support
  , windows
  {$EndIf};

var
  Data: Array of Integer = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

procedure IterateArrayTest;
var
  i: Integer;
begin
  Write('Testing Iterate over Array:');
  for i in Iterate<Integer>(Data) do
    Write(' ', i);
  WriteLn;
end;

procedure IterateRangeTest;
var
  i: Integer;
begin
  Write('Testing Iterate over Range [0..10]:');
  for i in IterateRange<Integer>(0, 10) do
    Write(' ', i);
  WriteLn;
end; 

procedure IterateRangeStepTest;
var
  d: Double;
begin
  Write('Testing Iterate over Range [0..10] in steps of 0.5:');
  for d in IterateRange<Double>(0, 10, 0.5) do
    Write(' ', FloatToStr(d));
  WriteLn;
end;

procedure IterateCharsTest;
const
  TestString = 'Hello World';
var
  c: Char;
begin
  Write('Testing iterating chars of "' + TestString + '":');
  for c in Iterate(TestString) do
    Write(' ', c);
  WriteLn;
end;

procedure IterateStringListTest;
var
  i: Integer;
  sl: TStringList;
  s: String;
begin
  Write('Testing Iterate over StringList:');
  sl := TStringList.Create;
  try
    for i:=Low(Data) to High(Data) do
      sl.Add('Data[%d] = %d'.Format([i, Data[i]]));
    for s in Iterate(sl) do
      Write(' ', s);
  finally
    sl.Free;
  end;
  WriteLn;
end;

procedure IterateListTest;
var
  i: Integer;
  lst: Classes.TList;
  p: PInteger;
begin
  Write('Testing Iterate over List:');
  lst := Classes.TList.Create;
  try
    for i:=Low(Data) to High(Data) do
      lst.Add(@Data[i]);
    for p in Iterate(lst) do
      Write(' ', p^);
  finally
    lst.Free;
  end;
  WriteLn;
end;

procedure IterateGenericListTest;
var
  i: Integer;
  lst: TList<Integer>;
begin
  Write('Testing Iterate over Generics.Collections List:');
  lst := TList<Integer>.Create;
  try
    for i:=Low(Data) to High(Data) do
      lst.Add(Data[i]);
    for i in Iterate<Integer>(lst) do
      Write(' ', i);
  finally
    lst.Free;
  end;
  WriteLn;
end;

procedure IterateObjectListTest;
var
  i: Integer;
  lst: contnrs.TObjectList;
  sl: TStringList;
begin
  Write('Testing Iterate over Object List:');
  lst := contnrs.TObjectList.Create;
  try
    for i:=Low(Data) to High(Data) do
    begin
      sl := TStringList.Create;
      sl.Add('Data[%d] = %d'.Format([i, Data[i]]));
      lst.Add(sl);
    end;
    for sl in Iterate(lst) do
      Write(' ', sl.Text.Trim);
  finally
    lst.Free;
  end;
  WriteLn;
end;

procedure IterateStreamTest;
var
  ss: TStringStream;
  c: Char;
begin
  ss:=TStringStream.Create('Hello World!');
  ss.Seek(0, soBeginning);
  Write('Iterating chars of Hello World Stream:');
  for c in Iterate<Char>(ss) do
    Write(' ', c);
  WriteLn;
end; 

procedure IterateStreamLinesTest;
var
  ln: String;
begin
  Write('Iterating lines of FileReadTest.txt:');
  for ln in IterateLines(TFileStream.Create('FileReadTest.txt', fmOpenRead)) do
    Write(' ', ln);
  WriteLn;
end;

procedure IterateStreamUTF8Test;
const
  TestString: String = '€$£';
var
  ms: TMemoryStream;
  c: String;
begin
  ms := TMemoryStream.Create;
  ms.Write(TestString[1], Length(TestString));
  ms.Seek(0, soBeginning);
  Write('Testing iterating over "', TestString, '" stream :');
  for c in IterateUTF8(ms) do
    Write(' ', c);
  WriteLn;
end;

procedure IndexTest;
var
  p: TPair<SizeInt, Integer>;
  idx: SizeInt;
  val: Integer;
begin
  Write('Testing Index:');
  for p in Index<Integer>(Iterate<Integer>(Data)) do
  begin
    p.unpack(idx, val);
    Write(' Data[%d]=%d'.Format([idx, val]));
  end;
  WriteLn;
end;

procedure StepTest;
var
  i: Integer;
begin
  Write('Testing Step 3:');
  for i in Step<Integer>(3, Iterate<Integer>(Data)) do
    Write(' ', i);
  WriteLn;
end;

procedure ReverseTest;
var
  i: Integer;
begin
  Write('Testing Reverse:');
  for i in Reverse<Integer>(Iterate<Integer>(Data)) do
    Write(' ', i);
  WriteLn;
end;

procedure SortedTest;
var
  s: String;
  arr: Array of String = ['Banana', 'Apple', 'Cherry'];
begin
  Write('Testing Sort Banana, Apple, Cherry:');
  for s in Sorted<String>(CompareStr, Iterate<String>(arr)) do
    Write(' ', s);
  WriteLn;
end;

function isEven(AValue: Integer): Boolean;
begin
  Result := AValue mod 2 = 0;
end;

procedure FilterTest;
var
  i: Integer;
begin
  Write('Testing Filter isEven:');
  for i in Filter<Integer>(isEven, Iterate<Integer>(Data)) do
    Write(' ', i);
  WriteLn;
end;

procedure MapTest;
var
  s: String;

// Implicit conversion doesn't work with overloaded functions
function Int2Hex(i: Integer): String;
begin
  Result := IntToHex(i);
end;
begin
  Write('Testing Map inttohex:');
  for s in Map<Integer, String>(Int2Hex, Iterate<Integer>(Data)) do
    Write(' ', s);
  WriteLn;
end;

procedure SkipTest;
var
  i: Integer;
begin
  Write('Testing Skip 4:');
  for i in Skip<Integer>(4, Iterate<Integer>(Data)) do
    Write(' ', i);
  WriteLn;
end;

procedure TakeTest;
var
  i: Integer;
begin
  Write('Testing Take 4:');
  for i in Take<Integer>(4, Iterate<Integer>(Data)) do
    Write(' ', i);
  WriteLn;
end;

procedure TakeUntilTest;
const
  TestString = 'aacbaaabaabbaca';
var
  c: Char;
begin
  Write('Testing TakeUntil (excluding) aabb in "' + TestString + '":');
  for c in TakeUntil('aabb', Iterate(TestString)) do
    Write(' ', c);
  WriteLn;
end;

procedure TakeUntilWithSequenceTest;
const
  TestString = 'aacbaaabaabbaca';
var
  c: Char;
begin
  Write('Testing TakeUntil (including) aabb in "' + TestString + '":');
  for c in TakeUntil('aabb', Iterate(TestString), True) do
    Write(' ', c);
  WriteLn;
end;

procedure TakeUntilNoOccurnaceTest;
const
  TestString = 'aabacdaa';
var
  c: Char;
begin
  Write('Testing TakeUntil abcd in "' + TestString + '":');
  for c in TakeUntil('abcd', Iterate(TestString)) do
    Write(' ', c);
  WriteLn;
end; 

procedure TakeUntilEmptySequence;
const
  TestString = 'Print None';
var
  c: Char;
begin
  Write('Testing TakeUntil [] in "' + TestString + '":');
  for c in TakeUntil('', Iterate(TestString)) do
    Write(' ', c);
  WriteLn;
end;

function isPrime(ANumber: Integer): Boolean;
var i: Integer;
begin
  Result := False;
  for i := 2 to ANumber - 1 do
    if ANumber mod i = 0 then
      Exit;
  Result := True;
end;

procedure TakeWhileTest;
var
  i: Integer;
begin
  Write('Testing TakeWhile isPrime:');
  for i in TakeWhile<Integer>(isPrime, Iterate<Integer>(Data)) do
    Write(' ', i);
  WriteLn;
end;

procedure SkipWhileTest;
var
  i: Integer;
begin
  Write('Testing SkipWhile isPrime:');
  for i in SkipWhile<Integer>(isPrime, Iterate<Integer>(Data)) do
    Write(' ', i);
  WriteLn;
end;

procedure SkipUntilTest;
const
  TestString = 'aacbaaabaabbaca';
var
  c: Char;
begin
  Write('Testing SkipUntil (excluding) aabb in "' + TestString + '":');
  for c in SkipUntil<Char>('aabb', Iterate(TestString)) do
    Write(' ', c);
  WriteLn;
end;

procedure SkipUntilWithSequenceTest;
const
  TestString = 'aacbaaabaabbaca';
var
  c: Char;
begin
  Write('Testing SkipUntil (including) aabb in "' + TestString + '":');
  for c in SkipUntil('aabb', Iterate(TestString), True) do
    Write(' ', c);
  WriteLn;
end;

procedure SkipUntilNoOccurnaceTest;
const
  TestString = 'aabacdaa';
var
  c: Char;
begin
  Write('Testing SkipUntil abcd in "' + TestString + '":');
  for c in SkipUntil('abcd', Iterate(TestString)) do
    Write(' ', c);
  WriteLn;
end;

procedure SkipUntilEmptySequence;
const
  TestString = 'Print All';
var
  c: Char;
begin
  Write('Testing SkipUntil [] in "' + TestString + '":');
  for c in SkipUntil('', Iterate(TestString)) do
    Write(' ', c);
  WriteLn;
end;

procedure TestExpand;

function DoubleExpand(AValue: Integer): IIterator<Integer>;
begin
  Result := Iterate<Integer>([AValue, AValue]);
end;

var
  i: Integer;
begin
  Write('Testing double expand:');
  for i in Expand<Integer, Integer>(DoubleExpand, Iterate<Integer>(Data)) do
    Write(' ', i);
  WriteLn;
end;

procedure TestExpandArray;
type
  TIntArray = array of Integer;
const
  Arrays: Array of TIntArray = [[1, 2], [3], [4, 5]];
var
  i: Integer;
begin
  Write('Testing array expand [[1, 2], [3], [4, 5]]:');
  for i in ExpandArrays<Integer>(Iterate<TIntArray>(Arrays)) do
    Write(' ', i);
  WriteLn;
end; 

procedure TestExpandStrings;
const
  Strings: Array of String = ['Foo', 'Bar', 'Baz'];
var
  str: String;
begin
  Write('Testing array expand ["Foo", "Bar", "Baz"]:');
  for str in ExpandStrings(Iterate<String>(Strings)) do
    Write(' ', str);
  WriteLn;
end;

procedure ReduceTest;
var
  sum: Integer;

function Add(A, B: Integer): Integer;
begin
  Result := A + B;
end;

begin
  Write('Testing Reduce Add: ');
  sum := Reduce<Integer>(Add, Iterate<Integer>(Data));
  WriteLn(sum);
end; 

procedure SumTest;
var
  s: Integer;
begin
  Write('Testing Sum: ');
  s := Sum<Integer>(Iterate<Integer>(Data));
  WriteLn(s);
end;  

procedure ProductTest;
var
  Prod: Integer;
begin
  Write('Testing Product: ');
  Prod := Product<Integer>(Iterate<Integer>(Data));
  WriteLn(Prod);
end;

procedure StringSumTest;
var
  s: String;
begin
  Write('Testing String Sum "a" "b" "c": ');
  s := Sum<String>(IterateUTF8('abc'));
  WriteLn(s);
end;

procedure CollectStringListTest;
var
  sl: TStringList;

// Implicit conversion doesn't work with overloaded functions
function Int2Hex(i: Integer): String;
begin
  Result := IntToHex(i);
end;
begin
  WriteLn('Teesting Collect as TStringList: ');
  sl := Collect<String, TStringList>(
        Map<Integer, String>(Int2Hex,
        Iterate<Integer>(Data)));
  try
    WriteLn(sl.Text);
  finally
    sl.Free;
  end;
end;

procedure CastIteratorTest;
var
  arr: Array of Boolean = [True, True, False, False, True];
  i: Integer;
begin
  Write('Testing Cast Boolean->Integer:');
  for i in Cast<Boolean, Integer>(Iterate<Boolean>(arr)) do
    Write(' ', i);
  WriteLn;
end;

procedure ClassCastIteratorTest;
var
  lst: contnrs.TObjectList;
  i: Integer;
  sl: TStringList;
begin
  Write('Testing Class Cast TObject->TStringList:');
  lst := contnrs.TObjectList.Create;
  try
    for i:=Low(Data) to High(Data) do
    begin
      sl := TStringList.Create;
      sl.Add('Data[%d] = %d'.Format([i, Data[i]]));
      lst.Add(sl);
    end;
    // Different to IterateObjectListTest, as this uses "as" for casting, resulting in exceptions if types don't match up
    for sl in CastObject<TStringList>(Iterate(lst)) do
      Write(' ', sl.Text.Trim);
  finally
    lst.Free;
  end;
  WriteLn;
end;

type
  TBaseClass = class
  end;

  TChildClass1 = class(TBaseClass)
  public
    A: Integer;
    constructor Create(AValue: Integer);
  end;

  TChildClass2 = class(TBaseClass)
  public
    B: Integer;
    constructor Create(BValue: Integer);
  end;

constructor TChildClass1.Create(AValue: Integer);
begin
  A := AValue;
end;

constructor TChildClass2.Create(BValue: Integer);
begin
  B := BValue;
end;

procedure FilterClassTest;
var
  lst: TObjectList<TBaseClass>;
  i: Integer;
  c: TChildClass1;
begin
  Write('Testing Filter Class TChildClass1:');
  lst := TObjectList<TBaseClass>.Create;
  try
    for i:=Low(Data) to High(Data) do
      if i mod 2 = 0 then
        lst.Add(TChildClass1.Create(i))
      else
        lst.Add(TChildClass2.Create(i));
    // Different to IterateObjectListTest, as this uses "as" for casting, resulting in exceptions if types don't match up
    for c in FilterClass<TBaseClass, TChildClass1>(Iterate<TBaseClass>(lst)) do
      Write(' ', c.A);
  finally
    lst.Free;
  end;
  WriteLn;
end;

procedure MapClassTest;
var
  lst: TObjectList<TBaseClass>;
  i: Integer;
  c: TClass;
begin
  Write('Testing Mapping Objects to Class Types:');
  lst := TObjectList<TBaseClass>.Create;
  try
    for i:=Low(Data) to High(Data) do
      if i mod 2 = 0 then
        lst.Add(TChildClass1.Create(i))
      else
        lst.Add(TChildClass2.Create(i));
    for c in ClassTypes<TBaseClass>(Iterate<TBaseClass>(lst)) do
      Write(' ', c.ClassName);
  finally
    lst.Free;
  end;
  WriteLn;
end;

procedure UTF8Test;
const
  TestString = '€$£';
var
  c: String;
begin
  Write('Testing iterating over "', TestString, '":');
  for c in IterateUTF8(TestString) do
    Write(' ', c);
  WriteLn;
end;

procedure UTF8FromIteratorTest;
const
  TestString = '€$£';
var
  c: String;
begin
  Write('Testing iterating over "', TestString, '" (iterator):');
  for c in IterateUTF8(Iterate(TestString)) do
    Write(' ', c); // Why won't you work on windows?
  WriteLn;
end;

procedure SingleCharSplitTest;
const
  DelimitedText = 'Slash/Delimited//Text';
var
  str: String;
begin
  Write('Testing splitting "' + DelimitedText + '":');
  for str in Split(DelimitedText, '/') do
    Write(' "', str, '"');
  WriteLn;
end;

procedure SequenceSplitTest;
const
  DelimitedText = 'aabaacbabba';
  Delimiter = 'ab';
var
  str: String;
begin
  Write('Testing splitting "' + DelimitedText + '" on "' + Delimiter + '":');
  for str in Split(DelimitedText, Delimiter) do
    Write(' "', str, '"');
  WriteLn;
end;

procedure SingleCharSplitCharTest;
const
  DelimitedText = 'Slash/Delimited//Text';
var
  str: String;
begin
  Write('Testing splitting (charwise) "' + DelimitedText + '":');
  for str in Split(Iterate(DelimitedText), '/') do
    Write(' "', str, '"');
  WriteLn;
end;

procedure SequenceSplitCharTest;
const
  DelimitedText = 'aabaacbabba';
  Delimiter = 'ab';
var
  str: String;
begin
  Write('Testing splitting (charwise) "' + DelimitedText + '" on "' + Delimiter + '":');
  for str in Split(Iterate(DelimitedText), Delimiter) do
    Write(' "', str, '"');
  WriteLn;
end;

procedure SplitAndJoinTestSimple;
const
  DelimitedText = 'Slash/Delimited/Text';
var
  str: String;
begin
  Write('Testing split and join "' + DelimitedText + '": ');
  str := Join('\', Split(DelimitedText, '/'), False);
  WriteLn(str);
end;

procedure SplitAndJoinTestGeom;
const
  DelimitedText = 'Slash/Delimited/Text';
var
  str: String;
begin
  Write('Testing split and join (geometric)"' + DelimitedText + '": ');
  str := Join('\',
         Split(DelimitedText, '/'));
  WriteLn(str);
end;

procedure JoinCharsTestSimple;
var
  s: String;
begin
  Write('Testing Char Join "a" "b" "c": ');
  s := Join(Iterate('abc'), False);
  WriteLn(s);
end; 

procedure JoinCharsTestGeometric;
var
  s: String;
begin
  Write('Testing Char Join (geometric) "a" "b" "c": ');
  s := Join(Iterate('abc'));
  WriteLn(s);
end;   

procedure JoinStringTestSimple;
var
  s: String;
begin
  Write('Testing String Join "Foo" "Bar" "Baz": ');
  s := Join(Iterate<String>(['Foo', 'Bar', 'Baz']), False);
  WriteLn(s);
end;

procedure JoinStringTestGeometric;
var
  s: String;
begin
  Write('Testing String Join (geometric) "Foo" "Bar" "Baz": ');
  s := Join(Iterate<String>(['Foo', 'Bar', 'Baz']));
  WriteLn(s);
end;

procedure InBetweenTest;
const
  TestText = 'It should find (this) and also (that) but (not this(';
var
  str: String;
begin
  Write('Testing in between brackets "this" and "that":');
  for str in InBetween(Iterate(TestText), '(', ')') do
    Write(' ', str);
  WriteLn;
end;

procedure EndlessGeneratorTest;
var
  l1, l2: Integer;

function Fib: Integer;
begin
  Result := l1 + l2;
  l1 := l2;
  l2 := Result;
end; 

var
  i: Integer;
begin
  l1 := 0;
  l2 := 1;
  Write('Generating first 10 fibbonacci numbers:');
  for i in Take<Integer>(10, GenerateInf<Integer>(Fib)) do
    Write(' ', i);
  WriteLn;
end;

procedure GeneratorTest;
var
  f: Text;

function NextLine: TNullable<String>;
var
  s: String;
begin
  if EOF(f) then
  begin
    Result.Clear;
    Exit;
  end;
  ReadLn(f, s);
  Result := s;
end;

var
  ln: String;
begin
  AssignFile(f, 'FileReadTest.txt');
  Reset(f);
  Write('Reading lines generator from FileReadTest.txt:');
  for ln in Generate<String>(NextLine) do
    Write(' ', ln);
  CloseFile(f);
  WriteLn;
end;

procedure IteratorCombinatorTest;

function sq(a: Integer): Integer;
begin
  Result := a*a;
end;

function isEven(a: Integer): Boolean;
begin
  Result := a mod 2 = 0;
end;

var
  i: Integer;
begin
  Write('Testing Iterator Combination Map < Filter < Range 0..10:');
  for i in Map<Integer, Integer>(sq,
           Filter<Integer>(isEven,
           IterateRange<Integer>(0, 10))) do
     Write(' ', i);
  WriteLn;
end;

procedure ComplexCombinationTest;

function CountMap(c: Char; m: TDictionary<Char, Integer>): TDictionary<Char, Integer>;
begin
  if m.ContainsKey(c) then
    m[c] := m[c] + 1
  else
    m.Add(c, 1);
  Result := m;
end;

type
  TDict = TDictionary<Char, Integer>;
  TDictPair = Generics.Collections.TPair<Char, Integer>;

function Greater(lhs, rhs: TDictPair): Boolean;
begin
  Result := lhs.Value > rhs.Value;
end;

var
  p: TDictPair;
  m: TDict;
begin
  m := TDict.Create;
  WriteLn('Reading iteratortest.lpr for the 5 most used chars: ');
  try
    for p in Take<TDictPair>(5,
             Sorted<TDictPair>(Greater,
             Iterate<Char, Integer>(
             FoldR<TDict, Char>(CountMap, m,
             Iterate<Char>(TFileStream.Create('iteratortest.lpr', fmOpenRead)))))) do
      WriteLn('  ''', p.Key,''': ', p.Value);
  finally
    m.Free;
  end;
end;

begin
  {$IfDef WINDOWS}
  SetConsoleOutputCP(DefaultSystemCodePage);
  {$EndIf}
  SetTextCodePage(Output, DefaultSystemCodePage);

  // Base iterators
  IterateArrayTest;
  IterateRangeTest;
  IterateRangeStepTest;
  IterateCharsTest;
  IterateStringListTest;
  IterateListTest;
  IterateGenericListTest;
  IterateObjectListTest;
  IterateStreamTest;
  IterateStreamLinesTest;
  IterateStreamUTF8Test;

  // Utility functions
  IndexTest;
  ReverseTest;
  SortedTest;
  StepTest;

  // Map & Filter
  FilterTest;
  MapTest;

  // Take & Skip
  TakeTest;
  TakeWhileTest;
  TakeUntilTest;
  TakeUntilWithSequenceTest;
  TakeUntilNoOccurnaceTest;
  TakeUntilEmptySequence;
  SkipTest;
  SkipWhileTest;
  SkipUntilTest;
  SkipUntilWithSequenceTest;
  SkipUntilNoOccurnaceTest;
  SkipUntilEmptySequence;

  // Expand
  TestExpand;
  TestExpandArray;
  TestExpandStrings;

  // Reduce & Collect
  ReduceTest;
  SumTest;
  ProductTest;
  StringSumTest;
  CollectStringListTest;

  // Typing
  CastIteratorTest;
  ClassCastIteratorTest;
  FilterClassTest;
  MapClassTest;

  // Strings
  UTF8Test;
  UTF8FromIteratorTest;
  // Splitting
  SingleCharSplitTest;
  SequenceSplitTest;  
  SingleCharSplitCharTest;
  SequenceSplitCharTest;
  InBetweenTest;
  // Joining
  SplitAndJoinTestSimple;
  SplitAndJoinTestGeom;
  JoinCharsTestSimple;
  JoinCharsTestGeometric;
  JoinStringTestSimple;
  JoinStringTestGeometric;

  // Generators
  EndlessGeneratorTest;
  GeneratorTest;

  // Iterator Combinators
  IteratorCombinatorTest;
  ComplexCombinationTest;

  {$IfDef Windows}ReadLn;{$EndIF}
end.

