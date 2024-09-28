unit iterators.streams;

{$mode objfpc}{$H+}
{$ZeroBasedStrings On}

interface

uses
  Classes, SysUtils, FuncTypes, nullable, iterators.base, iterators.strings;

type

  { TStreamIterator }

  generic TStreamIterator<T> = class(specialize TIterator<T>)
  private
    FCurrent: T;
    FStream: TStream;
    FOwnsStream: Boolean;
  protected
    function GetCurrent: T; override;
    function MoveNext: Boolean; override;
  public
    constructor Create(AStream: TStream; AOwnsStream: Boolean);

    destructor destroy; override;
  end;

  { TCustomStreamIterator }

  generic TCustomStreamIterator<T> = class(specialize TIterator<T>)
  type         
    TTOpt = specialize TNullable<T>;
    TReadValue = specialize TAnyUnaryFunction<TTOpt, TStream>;
  private
    FCurrent: T;
    FStream: TStream;
    FOwnsStream: Boolean;
    FCustomRead: specialize TNullable<TReadValue>;
  protected
    function GetCurrent: T; override;
    function MoveNext: Boolean; override;
  public
    constructor Create(AStream: TStream; AOwnsStream: Boolean);
    constructor Create(AStream: TStream; AOwnsStream: Boolean; ACustomRead: TReadValue);

    destructor destroy; override;
  end;

  { TLineStreamIterator }

  TLineStreamIterator = class(specialize TIterator<String>)
  private
    FCurrent: String;
    FStream: TStream;
    FOwnsStream: Boolean;
  protected
    function GetCurrent: String; override;
    function MoveNext: Boolean; override;
  public
    constructor Create(AStream: TStream; AOwnsStream: Boolean);

    destructor destroy; override;
  end;

  { TUTF8StreamIterator }

  TUTF8StreamIterator = class(specialize TIterator<String>)
  private
    FCurrent: String;
    FStream: TStream;
    FOwnsStream: Boolean;
  protected
    function GetCurrent: String; override;
    function MoveNext: Boolean; override;
  public
    constructor Create(AStream: TStream; AOwnsStream: Boolean);

    destructor destroy; override;
  end;

implementation

{ TStreamIterator }

function TStreamIterator.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TStreamIterator.MoveNext: Boolean;
begin
  Result := FStream.Read(FCurrent, SizeOf(FCurrent)) = SizeOf(FCurrent);
end;

constructor TStreamIterator.Create(AStream: TStream; AOwnsStream: Boolean);
begin
  inherited Create;
  FStream := AStream;
  FOwnsStream := AOwnsStream;
end;

destructor TStreamIterator.destroy;
begin
  if FOwnsStream then
    FStream.Free;;
  inherited destroy;
end;

{ TCustomStreamIterator }

function TCustomStreamIterator.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TCustomStreamIterator.MoveNext: Boolean;
var
  valueOpt: TTOpt;
begin
  if not FCustomRead.HasValue then
  begin
    Result := FStream.Read(FCurrent, SizeOf(FCurrent)) = SizeOf(FCurrent);
    Exit;
  end;
  valueOpt := FCustomRead.Value.apply(FStream);
  Result := valueOpt.HasValue;
  if Result then
    FCurrent:=valueOpt.Value;
end;

constructor TCustomStreamIterator.Create(AStream: TStream; AOwnsStream: Boolean);
begin
  inherited Create;
  FStream := AStream;
  FOwnsStream := AOwnsStream;
  FCustomRead.Clear;
end;

constructor TCustomStreamIterator.Create(AStream: TStream; AOwnsStream: Boolean;
  ACustomRead: TReadValue);
begin
  inherited Create;
  FStream := AStream;
  FOwnsStream := AOwnsStream;
  FCustomRead := ACustomRead;
end;

destructor TCustomStreamIterator.destroy;
begin
  if FOwnsStream then
    FStream.Free;
  inherited destroy;
end;

{ TLineStreamIterator }

function TLineStreamIterator.GetCurrent: String;
begin
  Result:=FCurrent;
end;

function TLineStreamIterator.MoveNext: Boolean;
var
  c: Char;
  readHead: SizeInt;
  readLen: LongInt;
begin
  Result := False;
  FCurrent := '';
  readHead := 0;
  while True do
  begin
    readLen := FStream.Read(c, SizeOf(c));
    // EOF and nothing read yet -> return null
    if readLen < SizeOf(c)then
      Break;
    Result := True;
    // Extend Buffer
    if readHead >= Length(FCurrent) then
      SetLength(FCurrent, Length(FCurrent) + 1024);
    FCurrent[readHead] := c;
    // Check for LF or CRLF
    if FCurrent[readHead] = #10 then
    begin
      if (readHead > 0) and (FCurrent[readHead-1]=#13) then
        Dec(readHead);
      break;
    end;
    Inc(readHead);
  end;
  SetLength(FCurrent, readHead);
end;

constructor TLineStreamIterator.Create(AStream: TStream; AOwnsStream: Boolean);
begin
  inherited Create;
  FStream := AStream;
  FOwnsStream := AOwnsStream;
end;

destructor TLineStreamIterator.destroy;
begin
  if FOwnsStream then
    FStream.Free;
  inherited destroy;
end;

{ TUTF8StreamIterator }

function TUTF8StreamIterator.GetCurrent: String;
begin
  Result:=FCurrent;
end;

function TUTF8StreamIterator.MoveNext: Boolean;
var
  FirstChar: Char;
  CodePointLen, i: Integer;
begin
  FCurrent := '';
  Result := FStream.Read(FirstChar, SizeOf(FirstChar)) = SizeOf(FirstChar);
  if not Result then
    Exit;

  if not ValidFirstUTF8Char(FirstChar) then
    raise EInvalidUTF8Char.CreateFmt('Invalid UTF8 first char: %d', [ord(FirstChar)]);

  CodePointLen := UTF8CodePointLen(FirstChar);
  SetLength(FCurrent, CodePointLen);
  FCurrent[0] := FirstChar;

  for i:=1 to CodePointLen - 1 do
    if FStream.Read(FCurrent[i], SizeOf(FCurrent[i])) < SizeOf(FCurrent[i]) then
      raise EIncompleteUTF8Char.Create(FCurrent.Substring(0, i))
    else
    begin
      if not ValidUTF8FollowChar(FCurrent[i]) then
        raise EInvalidUTF8Char.CreateFmt('Invalid UTF8 follow char: %d', [ord(FCurrent[i])]);
    end;
end;

constructor TUTF8StreamIterator.Create(AStream: TStream; AOwnsStream: Boolean);
begin
  inherited Create;
  FStream := AStream;
  FOwnsStream := AOwnsStream;
end;

destructor TUTF8StreamIterator.destroy;
begin
  if FOwnsStream then
    FStream.Free;
  inherited destroy;
end;

end.

