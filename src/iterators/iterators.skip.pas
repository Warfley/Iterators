unit iterators.skip;

{$mode objfpc}{$H+}

interface

uses
  iterators.base, functypes;

type

  { TSkipIterator }

  generic TSkipIterator<T> = class(specialize TIteratorIterator<T, T>)
  private
    FCount: SizeInt;
  public
    constructor Create(AIterator: IIteratorType; ACount: SizeInt);

    function GetCurrent: T; override;
    function MoveNext: Boolean; override;
  end;

  { TSkipWhileIterator }

  generic TSkipWhileIterator<T> = class(specialize TIteratorIterator<T, T>)
  public type
    TWhileConditionFunction = specialize TAnyUnaryFunction<Boolean, T>;
  private
    FFunction: TWhileConditionFunction;
    FirstMove: Boolean;

  public
    constructor Create(AEnumerator: IIteratorType; AWhileConditionFunction: TWhileConditionFunction);

    function GetCurrent: T; override;
    function MoveNext: Boolean; override;
  end;

  { TSkipUntilIterator }

  generic TSkipUntilIterator<T> = class(specialize TLookAheadIterator<T, T>)
  public type
    TTArray = array of T;
  private
    FSequence: Array of T;
    FSkipSequence: Boolean;

    FCurrent: T;    
    FFirstMove: Boolean;

    function ReadUntilSequenceInBacklog: Boolean;
  public
    constructor Create(AEnumerator: IIteratorType; const ASequence: TTArray; ASkipSequence: Boolean);
    constructor Create(AEnumerator: IIteratorType; const ASequence: array of T; ASkipSequence: Boolean);

    function GetCurrent: T; override;
    function MoveNext: Boolean; override;
  end;

  { TSkipUntilStringIterator }

  TSkipUntilStringIterator = class(specialize TSkipUntilIterator<Char>)
  public
    constructor Create(AEnumerator: IIteratorType; const ASequence: String;
      ASkipSequence: Boolean);
  end;

implementation

{ TSkipIterator }

constructor TSkipIterator.Create(AIterator: IIteratorType; ACount: SizeInt);
begin
  inherited Create(AIterator);
  FCount := ACount;
end;

function TSkipIterator.GetCurrent: T;
begin
  Result := IteratorCurrent;
end;

function TSkipIterator.MoveNext: Boolean;
begin
  Result := True;
  // Increase FCount so this is executed at least once
  Inc(FCount);
  While Result and (FCount > 0) do
  begin
    Result := IteratorMoveNext;
    Dec(FCount);
  end;
end;

{ TSkipWhileIterator }

constructor TSkipWhileIterator.Create(AEnumerator: IIteratorType;
  AWhileConditionFunction: TWhileConditionFunction);
begin
  inherited Create(AEnumerator);
  FFunction := AWhileConditionFunction;
  FirstMove := True;
end;

function TSkipWhileIterator.GetCurrent: T;
begin
  Result := IteratorCurrent;
end;

function TSkipWhileIterator.MoveNext: Boolean;
begin
  Result := IteratorMoveNext;
  if FirstMove then
  begin
    while Result and FFunction.apply(IteratorCurrent) do
      Result := IteratorMoveNext;
    FirstMove := False;
  end;
end; 

{ TSkipUntilIterator }

function TSkipUntilIterator.ReadUntilSequenceInBacklog: Boolean;
var
  i: Integer;
  NextElement: T;
  Found: Boolean;
begin
  Result := True;
  repeat
    Found := True;
    for i:=0 to Length(FSequence) - 1 do
    begin
      if not PeekNextElement(i, NextElement) then
        Exit(False);
      if NextElement <> FSequence[i] then
      begin
        // Not in sequence, discard first and then try again
        Result := GetNextElement(NextElement);
        Found := False;
        Break;
      end;
    end;
  until Found or not Result;
end;

constructor TSkipUntilIterator.Create(AEnumerator: IIteratorType;
  const ASequence: TTArray; ASkipSequence: Boolean);
begin
  inherited Create(AEnumerator, Length(ASequence));

  FSequence := ASequence;
  FSkipSequence := ASkipSequence;

  FCurrent := Default(T);
  FFirstMove := True;
end;

constructor TSkipUntilIterator.Create(AEnumerator: IIteratorType;
  const ASequence: array of T; ASkipSequence: Boolean);
var
  Seq: TTArray;
  i: Integer;
begin
  Seq := [];
  SetLength(Seq, Length(ASequence));
  for i:=0 to Length(ASequence) - 1 do
    Seq[i] := ASequence[i];
  Create(AEnumerator, Seq, ASkipSequence);
end;

function TSkipUntilIterator.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TSkipUntilIterator.MoveNext: Boolean;
begin
  if FFirstMove then
  begin
    FFirstMove := False;
    if not ReadUntilSequenceInBacklog then
      Exit(False);
    if FSkipSequence then
      while BacklogLength > 0 do
        GetNextElement(FCurrent);
  end;
  Result := GetNextElement(FCurrent);
end;  

{ TSkipUntilStringIterator }

constructor TSkipUntilStringIterator.Create(AEnumerator: IIteratorType;
  const ASequence: String; ASkipSequence: Boolean);
var
  Seq: Array of Char = nil;
begin
  SetLength(Seq, Length(ASequence));
  {$Push}
  {$RangeChecks OFF} // Don't work with 0 based strings
  Move(ASequence[Low(ASequence)], Seq[0], Length(ASequence) * SizeOf(Char));
  {$pop}

  inherited Create(AEnumerator, Seq, ASkipSequence);
end;

end.

