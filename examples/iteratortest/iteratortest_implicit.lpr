program iteratortest_implicit;

{$mode Delphi}{$H+}
{$ModeSwitch nestedprocvars}
{$ModeSwitch ImplicitFunctionSpecialization}

uses
  Classes, Contnrs, SysUtils, iterators, iterators.base, Generics.Collections, TupleTypes;

var
  Data: Array of Integer = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

procedure IterateArrayTest;
var
  i: Integer;
begin
  Write('Testing Iterate over Array:');
  for i in Iterate(Data) do
    Write(' ', i);
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
    for i in Iterate(lst) do
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

procedure IndexTest;
var
  p: TPair<SizeInt, Integer>;
  idx: SizeInt;
  val: Integer;
begin
  Write('Testing Index:');
  for p in Index(Iterate(Data)) do
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
  for i in Step(Iterate(Data), 3) do
    Write(' ', i);
  WriteLn;
end;

procedure ReverseTest;
var
  i: Integer;
begin
  Write('Testing Reverse:');
  for i in Reverse(Iterate(Data)) do
    Write(' ', i);
  WriteLn;
end;

procedure SortedTest;
var
  s: String;
  arr: Array of String = ['Banana', 'Apple', 'Cherry'];
begin
  Write('Testing Sort Banana, Apple, Cherry:');
  for s in Sorted(Iterate(arr), CompareStr) do
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
  for i in Filter(Iterate(Data), isEven) do
    Write(' ', i);
  WriteLn;
end;

procedure MapTest;
var
  s: String;
begin
  Write('Testing Map inttohex:');
  for s in Map(Iterate(Data), IntToHex) do
    Write(' ', s);
  WriteLn;
end;

procedure SkipTest;
var
  i: Integer;
begin
  Write('Testing Skip 4:');
  for i in Skip(Iterate(Data), 4) do
    Write(' ', i);
  WriteLn;
end;

procedure TakeTest;
var
  i: Integer;
begin
  Write('Testing Take 4:');
  for i in Take(Iterate(Data), 4) do
    Write(' ', i);
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
  for i in TakeWhile(Iterate(Data), isPrime) do
    Write(' ', i);
  WriteLn;
end;

procedure SkipWhileTest;
var
  i: Integer;
begin
  Write('Testing SkipWhile isPrime:');
  for i in SkipWhile(Iterate(Data), isPrime) do
    Write(' ', i);
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
  sum := Reduce(Iterate(Data), Add);
  WriteLn(sum);
end;

procedure CollectStringListTest;
var
  sl: TStringList;
begin
  WriteLn('Teesting Collect as TStringList: ');
  sl := Collect(Map(Iterate(Data), IntToHex), TStringList.Create);
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
  for i in Cast<Boolean, Integer>(Iterate(arr)) do
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
    for c in FilterClass<TBaseClass, TChildClass1>(Iterate(lst)) do
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

begin
  IterateArrayTest;
  IterateStringListTest;
  IterateListTest;
  IterateGenericListTest;
  IterateObjectListTest;
  IndexTest;
  ReverseTest;
  SortedTest;
  StepTest;
  FilterTest;
  MapTest;
  TakeTest;
  TakeWhileTest;
  SkipTest;
  SkipWhileTest;
  ReduceTest;
  CollectStringListTest;
  CastIteratorTest;
  ClassCastIteratorTest;
  FilterClassTest;
  MapClassTest;

  ReadLn;
end.

