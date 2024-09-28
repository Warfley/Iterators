unit iterators.strings;

{$mode objfpc}{$H+}
{$ZeroBasedStrings On}
{$Assertions on}
{$RangeChecks Off} // Don't work with 0 based strings

interface

uses
  SysUtils, iterators.base, iterators.take, iterators.skip;

type
  EInvalidUTF8Char = class(Exception);
  EIncompleteUTF8Char = class(Exception);

  { TCharIterator }

  TCharIterator = class(specialize TIterator<Char>)
  private
    FDataString: String;
    FPosition: SizeInt;
  public
    constructor Create(const AData: String);

    function GetCurrent: Char; override;
    function MoveNext: Boolean; override;
  end;

  { TUTF8Iterator }

  TUTF8Iterator = class(specialize TIterator<String>)
  private
    FDataString: String;
    FPosition: SizeInt;
    FCurrent: String;
  public
    constructor Create(const AData: String);

    function GetCurrent: String; override;
    function MoveNext: Boolean; override;
  end;

  { TUTF8AggregateIterator }

  TUTF8AggregateIterator = class(specialize TIteratorIterator<String, Char>)
  private
    FCurrent: String;
  public
    constructor Create(AIterator: IIteratorType);

    function GetCurrent: String; override;
    function MoveNext: Boolean; override;
  end;

  { TStringSplitIterator }

  TStringSplitIterator = class(specialize TIterator<String>)
  private
    FDataString: String;
    FPosition: SizeInt;
    FSplitSequence: String;
    FCurrent: String;
  public
    constructor Create(const AData: String; const ADelimiter: String);

    function GetCurrent: String; override;
    function MoveNext: Boolean; override;
  end;

  { TCharSplitIterator }

  TCharSplitIterator = class(specialize TIteratorIterator<String, Char>)
  private
    FCharIterator: IIteratorType;
    FCurrent: String;
    FDelimiter: String;
  public
    constructor Create(AIterator: IIteratorType; const ADelimiter: String);

    function GetCurrent: String; override;
    function MoveNext: Boolean; override;
  end;

  { TInBetweenIterator }

  TInBetweenIterator = class(specialize TIteratorIterator<String, Char>)
  private
    FCharIterator: IIteratorType;
    FCurrent: String;
    FStartDelimiter: String;
    FEndDelimiter: String;
  public
    constructor Create(AIterator: IIteratorType; const AStart: String; const AEnd: String);

    function GetCurrent: String; override;
    function MoveNext: Boolean; override;
  end;

function JoinCollectLinear(AIterator: specialize IIterator<String>; const Delimiter: String): String;
function JoinCollectGeometric(AIterator: specialize IIterator<String>; const Delimiter: String): String;

function CollectStringGeometric(AIterator: specialize IIterator<Char>): String; overload;
function CollectStringLinear(AIterator: specialize IIterator<Char>): String; overload;
function CollectStringGeometric(AIterator: specialize IIterator<String>): String; overload;
function CollectStringLinear(AIterator: specialize IIterator<String>): String; overload;

function ValidFirstUTF8Char(FirstChar: Char): Boolean; inline;

function ValidUTF8FollowChar(FollowChar: Char): Boolean; inline;
function UTF8CodePointLen(FirstChar: Char): Integer; inline;
implementation

function JoinCollectLinear(AIterator: specialize IIterator<String>;
  const Delimiter: String): String;
var
  str: String;
begin
  if not AIterator.MoveNext then
    Exit('');
  Result := AIterator.Current;

  for str in AIterator do
    Result += Delimiter + str;
end;

function JoinCollectGeometric(AIterator: specialize IIterator<String>;
  const Delimiter: String): String;
var
  CurrentPos: SizeInt;
  str: String;
begin
  if not AIterator.MoveNext then
    Exit('');
  Result := AIterator.Current;
  CurrentPos := Length(Result);
                            
  while AIterator.MoveNext do
  begin
    str := AIterator.Current;
    while Length(Result) < CurrentPos + Length(Delimiter) + Length(str) do
      SetLength(Result, Length(Result) * 2);
    Move(Delimiter[0], Result[CurrentPos], Length(Delimiter) * SizeOf(Char));
    CurrentPos += Length(Delimiter);  
    Move(str[0], Result[CurrentPos], Length(str) * SizeOf(Char));
    CurrentPos += Length(str);
  end;
  SetLength(Result, CurrentPos);
end;

function CollectStringGeometric(AIterator: specialize IIterator<Char>): String;
var
  CurrentPos, Len: SizeInt;
begin
  Result := '';
  CurrentPos := 0;
  Len := 2048; // Half a page
  SetLength(Result, Len);

  while AIterator.MoveNext do
  begin
    if CurrentPos >= Len then
    begin
      Len *= 2;
      SetLength(Result, Len);
    end;
    Result[CurrentPos] := AIterator.Current;
    Inc(CurrentPos);
  end;
  SetLength(Result, CurrentPos);
end;

function CollectStringLinear(AIterator: specialize IIterator<Char>): String;
var
  c: Char;
begin
  Result := '';
  for c in AIterator do
    Result += c;
end;

function CollectStringGeometric(AIterator: specialize IIterator<String>
  ): String;
var
  CurrentPos: SizeInt;
  str: String;
begin
  if not AIterator.MoveNext then
    Exit('');
  Result := AIterator.Current;
  CurrentPos := Length(Result);

  while AIterator.MoveNext do
  begin
    str := AIterator.Current;
    while Length(Result) < CurrentPos + Length(str) do
      SetLength(Result, Length(Result) * 2);
    Move(str[0], Result[CurrentPos], Length(str) * SizeOf(Char));
    CurrentPos += Length(str);
  end;
  SetLength(Result, CurrentPos);
end;

function CollectStringLinear(AIterator: specialize IIterator<String>): String;
var
  str: String;
begin
  if not AIterator.MoveNext then
    Exit('');
  Result := AIterator.Current;

  for str in AIterator do
    Result += str;
end;

function ValidFirstUTF8Char(FirstChar: Char): Boolean; inline;
begin
  {$Push}
  {$B+} // Disable short circuit to avoid jump instructions
  Result := ((ord(FirstChar) And %10000000) = %00000000)  // One char sequence
         Or ((ord(FirstChar) And %11100000) = %11000000)  // Two char sequence
         Or ((ord(FirstChar) And %11110000) = %11100000)  // Three char sequence
         Or ((ord(FirstChar) And %11111000) = %11110000); // Four char sequence
  {$Pop}
end;

function ValidUTF8FollowChar(FollowChar: Char): Boolean; inline;
begin
  Result := (ord(FollowChar) And %11000000) = %10000000;
end;

function UTF8CodePointLen(FirstChar: Char): Integer; inline;
begin
  Result := 1 + ord((ord(FirstChar) And %11000000) = %11000000)
              + ord((ord(FirstChar) And %11100000) = %11100000)
              + ord((ord(FirstChar) And %11110000) = %11110000);
end;

{ TCharIterator }

constructor TCharIterator.Create(const AData: String);
begin
  inherited Create;
  FDataString := AData;
  FPosition := -1;
end;

function TCharIterator.GetCurrent: Char;
begin
  Result := FDataString[FPosition];
end;

function TCharIterator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < Length(FDataString);
end;

{ TUTF8Iterator }

constructor TUTF8Iterator.Create(const AData: String);
begin
  inherited Create;
  FDataString := AData;
  FPosition := 0;
  FCurrent := '';
end;

function TUTF8Iterator.GetCurrent: String;
begin
  Result := FCurrent;
end;

function TUTF8Iterator.MoveNext: Boolean;
var
  CodePointLen: Integer;
  FirstChar: Char;
  i: SizeInt;
begin
  if FPosition >= Length(FDataString) then
    Exit(False);

  FirstChar := FDataString[FPosition];
  if not ValidFirstUTF8Char(FirstChar) then
    raise EInvalidUTF8Char.CreateFmt('Invalid UTF8 char: %d', [ord(FirstChar)]);

  CodePointLen := UTF8CodePointLen(FirstChar);
  if FPosition + CodePointLen > Length(FDataString) then
    raise EIncompleteUTF8Char.CreateFmt('Incomplete UTF8 char at end of string [%d]', [FPosition]);

  for i := FPosition + 1 to FPosition + CodePointLen - 1 do
    if not ValidUTF8FollowChar(FDataString[i]) then
      raise EInvalidUTF8Char.CreateFmt('Invalid UTF8 char: %d', [ord(FDataString[i])]);

  Result := True;
  FCurrent := FDataString.Substring(FPosition, CodePointLen);
  Inc(FPosition, CodePointLen);
end; 

{ TUTF8AggregateIterator }

constructor TUTF8AggregateIterator.Create(AIterator: IIteratorType);
begin
  inherited Create(AIterator);
  FCurrent := '';
end;

function TUTF8AggregateIterator.GetCurrent: String;
begin
  Result := FCurrent;
end;

function TUTF8AggregateIterator.MoveNext: Boolean;
var
  FirstChar, NextChar: Char;
  CodePointLen, i: Integer;
begin
  Result := IteratorMoveNext;
  if not Result then
    Exit;
  FirstChar := IteratorCurrent;

  if not ValidFirstUTF8Char(FirstChar) then
    raise EInvalidUTF8Char.CreateFmt('Invalid UTF8 char: %d', [ord(FirstChar)]);

  CodePointLen := UTF8CodePointLen(FirstChar);
  SetLength(FCurrent, CodePointLen);
  FCurrent[0] := FirstChar;

  for i:=1 to CodePointLen - 1 do
    if not IteratorMoveNext then
      raise EIncompleteUTF8Char.Create(FCurrent.Substring(0, i))
    else
    begin
      NextChar := IteratorCurrent;
      if not ValidUTF8FollowChar(NextChar) then
        raise EInvalidUTF8Char.CreateFmt('Invalid UTF8 char: %d', [ord(NextChar)]);
      FCurrent[i] := NextChar;
    end;
end;    

{ TStringSplitIterator }

constructor TStringSplitIterator.Create(const AData: String; const ADelimiter: String);
begin
  inherited Create;
  FDataString := AData;
  FPosition := 0;
  FSplitSequence := ADelimiter;
  FCurrent := '';
end;

function TStringSplitIterator.GetCurrent: String;
begin
  Result := FCurrent;
end;

function TStringSplitIterator.MoveNext: Boolean;
var
  Len, PatternIndex: SizeInt;
begin
  if FPosition >= Length(FDataString) then
    Exit(False);
  Result := True;

  Len := 0;
  PatternIndex := 0;

  // Search first occurance
  while FPosition + Len < Length(FDataString) do
  begin
    if FDataString[FPosition + Len] = FSplitSequence[PatternIndex] then
    begin
      Inc(PatternIndex);
      if PatternIndex >= Length(FSplitSequence) then
      begin
        Inc(Len); // As we skip the Inc down below, we must take it here
        Break;  // End of pattern reached, split here
      end;
    end
    else if PatternIndex > 0 then // Pattern mismatch, backtrack to 2nd char of pattern match
    begin
      Len -= PatternIndex;
      PatternIndex := 0;
    end;

    Inc(Len);
  end;

  FCurrent := FDataString.Substring(FPosition, Len);
  // Strip Pattern from result
  if PatternIndex >= Length(FSplitSequence) then
    SetLength(FCurrent, Length(FCurrent) - PatternIndex);
  // Move Position
  FPosition += Len;
end;

{ TCharSplitIterator }

constructor TCharSplitIterator.Create(AIterator: IIteratorType;
  const ADelimiter: String);
begin
  inherited Create(AIterator);
  FCharIterator := AIterator;
  FDelimiter := ADelimiter;
  FCurrent := '';
end;

function TCharSplitIterator.GetCurrent: String;
begin
  Result := FCurrent;
end;

function TCharSplitIterator.MoveNext: Boolean;
var
  Iter: specialize IIterator<Char>;
begin
  Result := False;
  Iter := TTakeUntilStringIterator.Create(FCharIterator, FDelimiter, True);
  FCurrent := CollectStringGeometric(Iter);
  Result := Length(FCurrent) > 0;
  if Result and FCurrent.EndsWith(FDelimiter) then
    FCurrent := FCurrent.Remove(FCurrent.Length - FDelimiter.Length);
end;

{ TInBetweenIterator }

constructor TInBetweenIterator.Create(AIterator: IIteratorType;
  const AStart: String; const AEnd: String);
begin
  inherited Create(AIterator);
  FCharIterator := AIterator;
  FStartDelimiter := AStart;
  FEndDelimiter := AEnd;
  FCurrent := '';
end;

function TInBetweenIterator.GetCurrent: String;
begin
  Result := FCurrent;
end;

function TInBetweenIterator.MoveNext: Boolean;
var
  TakeIter, SkipIter: specialize IIterator<Char>;
  i: SizeInt;
begin
  Result := False;
  // First we skip until the start delimiter
  SkipIter := TSkipUntilStringIterator.Create(FCharIterator, FStartDelimiter, False);
  // Ensure we are not at the end
  for i:=0 to Length(FStartDelimiter) - 1 do
  begin
    if not SkipIter.MoveNext then
      Exit;
    Assert(SkipIter.Current = FStartDelimiter[i]);
  end;
  // Similar to split above, but we don't except anything that is not terminated with EndDelimiter
  SkipIter := TTakeUntilStringIterator.Create(FCharIterator, FEndDelimiter, True);
  FCurrent := CollectStringGeometric(SkipIter);
  if not FCurrent.IsEmpty and FCurrent.EndsWith(FEndDelimiter) then
  begin
    Result := True;
    FCurrent := FCurrent.Remove(FCurrent.Length - FEndDelimiter.Length);
  end;
end;

end.

