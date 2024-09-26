program tupletest;

{$mode Delphi}{$H+}

uses
  TupleTypes;

procedure PairTest;
var
  p: TPair<String, Integer>;
begin
  Write('Uninitialized pair: ');
  WriteLn('First: ', p.First, ' Second: ', p.Second);
  Write('"Hello World", 42 pair: ');
  p := Tuple<String, Integer>('Hello World', 42);
  WriteLn('First: ', p.First, ' Second: ', p.Second);
end;

procedure TripleTest;
var
  t: TTriple<String, Integer, Double>;
begin
  Write('Uninitialized triple: ');
  WriteLn('First: ', t.First, ' Second: ', t.Second, ' Third: ', t.Third);
  Write('"Hello World", 42, 3.14 pair: ');
  t := Tuple<String, Integer, Double>('Hello World', 42, 3.14);
  WriteLn('First: ', t.First, ' Second: ', t.Second, ' Third: ', t.Third);
end;

procedure QuadrupleTest;
var
  q: TQuadruple<String, Integer, Double, Char>;
begin
  Write('Uninitialized triple: ');
  WriteLn('First: ', q.First, ' Second: ', q.Second, ' Third: ', q.Third, ' Fourth: ', q.Fourth);
  Write('"Hello World", 42, 3.14, "f" pair: ');
  q := Tuple<String, Integer, Double, Char>('Hello World', 42, 3.14, 'f');
  WriteLn('First: ', q.First, ' Second: ', q.Second, ' Third: ', q.Third, ' Fourth: ', q.Fourth);
end;

procedure QuintupleTest;
var
  q: TQuintuple<String, Integer, Double, Char, TTypeKind>;
begin
  Write('Uninitialized triple: ');
  WriteLn('First: ', q.First, ' Second: ', q.Second, ' Third: ', q.Third, ' Fourth: ', q.Fourth, ' Fifth: ', q.Fifth);
  Write('"Hello World", 42, 3.14, "f", tkInteger pair: ');
  q := Tuple<String, Integer, Double, Char, TTypeKind>('Hello World', 42, 3.14, 'f', tkInteger);
  WriteLn('First: ', q.First, ' Second: ', q.Second, ' Third: ', q.Third, ' Fourth: ', q.Fourth, ' Fifth: ', q.Fifth);
end;

procedure UnpackTest;
var
  t: TTriple<String, Integer, Double>;
  first: String;
  last: Double;
begin
  t := Tuple<String, Integer, Double>('Hello World', 42, 3.14);
  Write('Testing unpack first and last value: ');
  t.Unpack(first, _, last);
  WriteLn('First: ', first, ' Last: ', last);
end;

begin
  PairTest;
  TripleTest;
  QuadrupleTest;
  QuintupleTest;
  UnpackTest;
  ReadLn;
end.

