unit iterators.helper;

{$mode objfpc}{$H+}

interface

uses
  iterators.base, TupleTypes;

type
  // Iterators that do not warrent their own unit

  { TIndexIterator }

  generic TIndexIterator<T> = class(specialize TIteratorIterator<specialize TPair<SizeInt, T>, T>)
  public type
    TResultPair = specialize TPair<SizeInt, T>;
  private
    FIndex: SizeInt;
  public
    constructor Create(AIterator: IIteratorType);

    function MoveNext: Boolean; override;
    function GetCurrent: TResultPair; override;
  end;

  { TStepIterator }

  generic TStepIterator<T> = class(specialize TIteratorIterator<T, T>)
  private
    FStepSize: SizeInt;
  public
    constructor Create(AIterator: IIteratorType; StepSize: SizeInt);

    function MoveNext: Boolean; override;
    function GetCurrent: T; override;
  end;


implementation

{ IndexIterator }

constructor TIndexIterator.Create(AIterator: IIteratorType);
begin
  inherited Create(AIterator);
  FIndex := -1;
end;

function TIndexIterator.MoveNext: Boolean;
begin
  inc(FIndex);
  Result := IteratorMoveNext;
end;

function TIndexIterator.GetCurrent: TResultPair;
begin
  Result := specialize Pair<SizeInt, T>(FIndex, IteratorCurrent);
end;

{ TStepIterator }

constructor TStepIterator.Create(AIterator: IIteratorType; StepSize: SizeInt);
begin
  inherited Create(AIterator);
  FStepSize := StepSize;
end;

function TStepIterator.MoveNext: Boolean;
var
  i: Integer;
begin
  Result := True;
  i := 0;
  while Result and (i < FStepSize) do
  begin
    Inc(i);
    Result := IteratorMoveNext;
  end;
end;

function TStepIterator.GetCurrent: T;
begin
  Result := IteratorCurrent;
end;

end.

