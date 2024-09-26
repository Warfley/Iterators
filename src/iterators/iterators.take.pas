unit iterators.take;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, iterators.base, functypes, Generics.Collections;

type
  { TTakeIterator }

  generic TTakeIterator<T> = class(specialize TIteratorIterator<T, T>)
  private
    FCount: SizeInt;
  public
    constructor Create(AIterator: IIteratorType; ACount: SizeInt);

    function GetCurrent: T; override;
    function MoveNext: Boolean; override;
  end;

  generic TTakeWhileIterator<T> = class(specialize TIteratorIterator<T, T>)
  public type
    TWhileConditionFunction = specialize TAnyUnaryFunction<Boolean, T>;
  private
    FFunction: TWhileConditionFunction;
    FCurrent: T;

    function UpdateCurrentAndCheck: Boolean; inline;
  public
    constructor Create(AEnumerator: IIteratorType; AWhileConditionFunction: TWhileConditionFunction);

    function GetCurrent: T; override;
    function MoveNext: Boolean; override;
  end;

  { TTakeUntilIterator }

  generic TTakeUntilIterator<T> = class(specialize TLookAheadIterator<T, T>)
  public type
    TTArray = array of T;
  private
    FSequence: Array of T;    
    FIncludeSequence: Boolean;

    FCurrent: T;
    // When this flag is set, the remaining backlog will be dumped
    // no further analysis is needed
    FOnlyOutputRemainingBacklog: Boolean;
  public
    constructor Create(AEnumerator: IIteratorType; const ASequence: TTArray; AIncludeSequence: Boolean);
    constructor Create(AEnumerator: IIteratorType; const ASequence: array of T; AIncludeSequence: Boolean);

    function GetCurrent: T; override;
    function MoveNext: Boolean; override;
  end;

  { TTakeUntilStringIterator }

  TTakeUntilStringIterator = class(specialize TTakeUntilIterator<Char>)
  public
    constructor Create(AEnumerator: IIteratorType; const ASequence: String;
      AIncludeSequence: Boolean);
  end;


implementation

{ TTakeIterator }

constructor TTakeIterator.Create(AIterator: IIteratorType; ACount: SizeInt);
begin
  inherited Create(AIterator);
  // + 1 because MoveNext will be called before the first element
  // So the counting starts after the first decrement
  FCount := ACount + 1;
end;

function TTakeIterator.GetCurrent: T;
begin
  Result := IteratorCurrent;
end;

function TTakeIterator.MoveNext: Boolean;
begin
  Dec(FCount);
  result := FCount > 0;
  if Result then
    Result := IteratorMoveNext;
end;

{ TTakeWhileIterator }

function TTakeWhileIterator.UpdateCurrentAndCheck: Boolean;
begin
  FCurrent := IteratorCurrent;
  Result := FFunction.apply(FCurrent);
end;

constructor TTakeWhileIterator.Create(AEnumerator: IIteratorType;
  AWhileConditionFunction: TWhileConditionFunction);
begin
  inherited Create(AEnumerator);
  FFunction := AWhileConditionFunction;
end;

function TTakeWhileIterator.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TTakeWhileIterator.MoveNext: Boolean;
begin
  Result := IteratorMoveNext And UpdateCurrentAndCheck;
end; 

{ TTakeUntilIterator }

constructor TTakeUntilIterator.Create(AEnumerator: IIteratorType;
  const ASequence: TTArray; AIncludeSequence: Boolean);
begin
  inherited Create(AEnumerator, Length(ASequence));

  FSequence := ASequence;
  FIncludeSequence := AIncludeSequence;

  FCurrent := Default(T);
  FOnlyOutputRemainingBacklog := False;
end;

constructor TTakeUntilIterator.Create(AEnumerator: IIteratorType;
  const ASequence: array of T; AIncludeSequence: Boolean);
var
  Seq: TTArray;
  i: Integer;
begin
  Seq := [];
  SetLength(Seq, Length(ASequence));
  for i:=0 to Length(ASequence) - 1 do
    Seq[i] := ASequence[i];
  Create(AEnumerator, Seq, AIncludeSequence);
end;

function TTakeUntilIterator.GetCurrent: T;
begin
  Result := FCurrent;
end;      

function TTakeUntilIterator.MoveNext: Boolean;
var
  NextElement: T;
  LookAheadPosition: Integer;
begin
  if FOnlyOutputRemainingBacklog and (BacklogLength <= 0)
  or (Length(FSequence) <= 0) then
    Exit(False);

  Result := GetNextElement(FCurrent);
  if not Result or FOnlyOutputRemainingBacklog or (FCurrent <> FSequence[0]) then
    Exit;

  LookAheadPosition := 1; // References the current index of Sequence
  // Read the rest of the sequence
  while LookAheadPosition < Length(FSequence) do
  begin
    if not PeekNextElement(LookAheadPosition - 1, NextElement) then // -1 because first element is FCurrent
    begin
      // There are now not enough left in the iterator to finish the sequence
      // So we just dump our backlog and are done
      FOnlyOutputRemainingBacklog := True;
      Exit;
    end;
    if NextElement <> FSequence[LookAheadPosition] then
      Break; // If we have a sequence break, no reason to continue
    Inc(LookAheadPosition);
  end;

  if LookAheadPosition >= Length(FSequence) then // the sequence was found
  begin      
    FOnlyOutputRemainingBacklog := True;
    if not FIncludeSequence then
    begin
      // Because we don't include the pattern, we dump the remaining backlog
      while BacklogLength > 0 do
        GetNextElement(NextElement);
      Exit(False);
    end;
  end;
end;  

{ TTakeUntilStringIterator }

constructor TTakeUntilStringIterator.Create(AEnumerator: IIteratorType;
  const ASequence: String; AIncludeSequence: Boolean);
var
  Seq: Array of Char = nil;
begin
  SetLength(Seq, Length(ASequence));
  {$Push}
  {$RangeChecks OFF} // Don't work with 0 based strings
  Move(ASequence[Low(ASequence)], Seq[0], Length(ASequence) * SizeOf(Char));
  {$pop}

  inherited Create(AEnumerator, Seq, AIncludeSequence);
end;

end.

