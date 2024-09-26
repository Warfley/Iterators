unit iterators.base;

{$mode ObjFPC}{$H+}
{$ModeSwitch advancedrecords}

interface

uses
  Classes, SysUtils, finalizers;

type
  // COM interface for reference counting
  generic IIterator<T> = interface
    function GetCurrent: T;
    function MoveNext: Boolean;

    function GetEnumerator: specialize IIterator<T>;
    property Current: T read GetCurrent;
  end;

  { TIterator }

  generic TIterator<T> = class(TInterfacedObject, specialize IIterator<T>)
  public
    function GetCurrent: T; virtual; abstract;
    function MoveNext: Boolean; virtual; abstract;

    function GetEnumerator: specialize IIterator<T>;
    property Current: T read GetCurrent;
  end;

  { TEnumeratorIterator }

  generic TEnumeratorIterator<T, TEnumerator, TFinalizer> = class(specialize TIterator<T>)
  private
    FEnumerator: TEnumerator; 
    FOwnsEnumerator: Boolean;
  public
    constructor Create(AEnumerator: TEnumerator; AOwnsEnumerator: Boolean = True);
    destructor Destroy; override;

    function GetCurrent: T; override;
    function MoveNext: Boolean; override;
  end;

  generic TClassEnumeratorIterator<T, TEnumerator> =
    class(specialize TEnumeratorIterator<T, TEnumerator, specialize TClassFinalizer<TEnumerator>>);
  generic TRecordEnumeratorIterator<T, TEnumerator> =
    class(specialize TEnumeratorIterator<T, TEnumerator, specialize TBaseFinalizer<TEnumerator>>);
  generic TInteraceEnumeratorIterator<T, TEnumerator> =
    class(specialize TEnumeratorIterator<T, TEnumerator, specialize TBaseFinalizer<TEnumerator>>);
  // To avoid confusion with TObject, and as Objects are probably rare anyway, this is ignored
  // Uncomment if needed
  //generic TObjectEnumeratorIterator<T, TEnumerator> =
  //  class(specialize TEnumeratorIterator<T, TEnumerator, specialize TObjectFinalizer<TEnumerator>>);

  { TIteratorIterator }

  generic TIteratorIterator<T, TSource> = class(specialize TIterator<T>)
  protected type
    IIteratorType = specialize IIterator<TSource>;
  private
    FIterator: IIteratorType;
  protected
    function IteratorMoveNext: Boolean; inline;
    function IteratorCurrent: TSource; inline;
  public
    constructor Create(AIterator: IIteratorType);

    function Source(AIterator: IIteratorType): specialize IIterator<T>;
  end;

  { TLookAheadIterator }

  generic TLookAheadIterator<T, TSource> = class(specialize TIteratorIterator<T, TSource>)
  private
    // Simple ring queue
    FBacklog: Array of TSource;
    FBacklogHead: SizeInt;
    FBacklogLen: SizeInt;

    procedure BacklogPush(const Element: TSource); {$IFDEF INLINING}inline;{$ENDIF}
    function BacklogPop: TSource; {$IFDEF INLINING}inline;{$ENDIF}
    function BacklogPeek(AIndex: Integer): TSource; {$IFDEF INLINING}inline;{$ENDIF}

  protected

    property BacklogLength: SizeInt read FBacklogLen;
    function GetNextElement(out NextElement: TSource): Boolean;
    function PeekNextElement(LookAhead: SizeInt; out NextElement: TSource): Boolean;
  public
    constructor Create(AIterator: IIteratorType; ALookAhead: SizeInt);
  end;

  { TArrayIterator }

  generic TArrayIterator<T> = class(specialize TIterator<T>)
  public type
    TArrayType = array of T;
  private
    FData: TArrayType;
    FHead: SizeInt;
  public
    constructor Create(const AArray: TArrayType);

    function GetCurrent: T; override;
    function MoveNext: Boolean; override;
  end;

{  Currently the operator overloading idea doesn't work (why tho?)
  { TIteratorCombinator }

  generic TIteratorCombinator<T, TSource> = record
  public type
    TSelfType = specialize TIteratorCombinator<T, TSource>;
    TIteratorType = specialize TIteratorIterator<T, TSource>;
    IIteratorType = specialize IIterator<T>;
    ICombineIterator = specialize IIterator<TSource>;
  private
    FIterator: IIteratorType;
  public
    function Source(AIterator: ICombineIterator): IIteratorType;

    class function Create(AIterator: TIteratorType): TSelfType; static;

    class operator :=(AIterator: TIteratorType): TSelfType; inline;
    class operator <(var ACombinator: TSelfType; AIterator: ICombineIterator): IIteratorType; inline;
    class operator >(AIterator: ICombineIterator; var ACombinator: TSelfType): IIteratorType; inline;
  end;
}

implementation

{ TIterator }

function TIterator.GetEnumerator: specialize IIterator<T>;
begin
  Result := Self;
end; 

{ TEnumeratorIterator }

constructor TEnumeratorIterator.Create(AEnumerator: TEnumerator;
  AOwnsEnumerator: Boolean);
begin
  inherited Create;
  FEnumerator := AEnumerator;
  FOwnsEnumerator := AOwnsEnumerator;
end;

destructor TEnumeratorIterator.Destroy;
begin
  if FOwnsEnumerator then
    TFinalizer.Finalize(FEnumerator);
  inherited Destroy;
end;

function TEnumeratorIterator.GetCurrent: T;
begin
  Result := FEnumerator.Current;
end;

function TEnumeratorIterator.MoveNext: Boolean;
begin
  Result := FEnumerator.MoveNext;
end;  

{ TIteratorIterator }

function TIteratorIterator.IteratorMoveNext: Boolean;
begin
  Result := FIterator.MoveNext;
end;

function TIteratorIterator.IteratorCurrent: TSource;
begin
  Result := FIterator.GetCurrent;
end;

constructor TIteratorIterator.Create(AIterator: IIteratorType);
begin
  inherited Create;
  FIterator := AIterator;
end;

function TIteratorIterator.Source(AIterator:IIteratorType):specialize IIterator<
  T>;
begin
  FIterator := AIterator;
  Result := Self;
end;

{ TLookAheadIterator }

procedure TLookAheadIterator.BacklogPush(const Element: TSource);
begin
  Assert(FBacklogLen < Length(FBacklog), 'Backlog full');
  FBacklog[(FBacklogHead + FBacklogLen) mod Length(FBacklog)] := Element;
  Inc(FBacklogLen);
end;

function TLookAheadIterator.BacklogPop: TSource;
begin
  Assert(FBacklogLen > 0, 'Backlog empty');
  Result := FBacklog[FBacklogHead];
  FBacklogHead := (FBacklogHead + 1) mod Length(FBacklog);
  Dec(FBacklogLen);
end;

function TLookAheadIterator.BacklogPeek(AIndex: Integer): TSource;
begin
  Assert((AIndex >= 0) and (AIndex < FBacklogLen), 'Index out of bounds');
  Result := FBacklog[(FBacklogHead + AIndex) mod Length(FBacklog)];
end;

function TLookAheadIterator.GetNextElement(out NextElement: TSource): Boolean;
begin
  Result := True;
  if FBacklogLen > 0 then
  begin
    NextElement := BacklogPop;
    Exit;
  end;
  if not IteratorMoveNext then
    Exit(False);
  NextElement := IteratorCurrent;
end;

function TLookAheadIterator.PeekNextElement(LookAhead: SizeInt; out
  NextElement: TSource): Boolean;
begin
  if (LookAhead < 0) or (LookAhead >= Length(FBacklog)) then
    raise ERangeError.Create('Lookahead not in 0..' + Length(FBacklog).ToString);
  Result := False;
  while LookAhead >= FBacklogLen do
  begin
    if not IteratorMoveNext then
      Exit;
    BacklogPush(IteratorCurrent);
  end;
  Result := True;
  NextElement := BacklogPeek(LookAhead);
end;

constructor TLookAheadIterator.Create(AIterator: IIteratorType;
  ALookAhead: SizeInt);
begin
  inherited Create(AIterator);
  SetLength(FBacklog, ALookAhead);
  FBacklogHead := 0;
  FBacklogLen := 0;
end;

{ TArrayIterator }

constructor TArrayIterator.Create(const AArray: TArrayType);
begin
  inherited Create;
  FData := AArray;
  FHead := -1;
end;

function TArrayIterator.GetCurrent: T;
begin
  Result := FData[FHead];
end;

function TArrayIterator.MoveNext: Boolean;
begin
  Inc(FHead);
  Result := FHead <= High(FData);
end;

{
{ TIteratorCombinator }

function TIteratorCombinator.Source(AIterator: ICombineIterator
  ): IIteratorType;
begin
  if not Assigned(FIterator) then
    raise EInvalidPointer.Create('Invalid Combinator');
  (FIterator as TIteratorType).FIterator:=AIterator;
  Result := FIterator;
  // Cannot combine multiple times
  FIterator := nil;
end;

class function TIteratorCombinator.Create(AIterator: TIteratorType): TSelfType;
begin
  AIterator.FIterator := nil;
  Result.FIterator := AIterator;
end;

class operator TIteratorCombinator.:=(AIterator: TIteratorType): TSelfType;
begin            
  AIterator.FIterator := nil;
  Result.FIterator := AIterator;
end;

class operator TIteratorCombinator.<(var ACombinator: TSelfType;
  AIterator: ICombineIterator): IIteratorType;
begin
  Result := ACombinator.Source(AIterator);
end;

class operator TIteratorCombinator.>(AIterator: ICombineIterator;
  var ACombinator: TSelfType): IIteratorType;
begin
  Result := ACombinator.Source(AIterator);
end;
}

end.

