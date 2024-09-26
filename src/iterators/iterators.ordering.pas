unit iterators.ordering;

{$mode objfpc}{$H+}

interface

uses
  iterators.base, iterators.collector,  functypes;

type

  { TReverseIterator }

  generic TReverseIterator<T> = class(specialize TIterator<T>)
  private
    FIndex: SizeInt;
    FData: specialize TArray<T>;
  public
    constructor Create(AIterator: specialize IIterator<T>);

    function MoveNext: Boolean; override;
    function GetCurrent: T; override;
  end;

  { TSortingIterator }

  generic TSortingIterator<T> = class(specialize TIterator<T>)
  public type
    IIteratorType = specialize IIterator<T>;
    TCompareFunction = specialize TAnyBinaryFunction<Integer, T, T>;
    TLessFunction = specialize TAnyBinaryFunction<Boolean, T, T>;

  private type
    TSortingFunctionData = record
      case isLess: Boolean of
      True: (LessFunction: TLessFunction);
      False: (CompareFunction: TCompareFunction);
    end;
  private
    // Heap functions
    function hasLChild(AIndex: SizeInt): Boolean; inline;
    function hasRChild(AIndex: SizeInt): Boolean; inline;
    class function isRoot(AIndex: SizeInt): Boolean; static; inline;
    class function getParent(AIndex: SizeInt): SizeInt; static inline;  
    class function getLChild(AIndex: SizeInt): SizeInt; static inline;
    class function getRChild(AIndex: SizeInt): SizeInt; static inline;
  private
    // Using a heap structure based on an array
    FData: Array of T;
    FHeapSize: SizeInt;
    FSortingFunctionData: TSortingFunctionData;
    FFirstMove: Boolean;

    function Compare(LIndex, RIndex: SizeInt): Boolean; inline;

    procedure Swap(AIndex, BIndex: SizeInt);
    procedure Heapify(AIndex: SizeInt);
    function InsertData(constref AElem: T): SizeInt;
    procedure FillData(AIterator: IIteratorType);
  public
    constructor Create(AIterator: IIteratorType; ASortingFunction: TSortingFunctionData); overload;
    constructor Create(AIterator: IIteratorType; ACompareFunction: TCompareFunction); overload;
    constructor Create(AIterator: IIteratorType; ALessFunction: TLessFunction); overload;

    function GetCurrent: T; override;
    function MoveNext: Boolean; override;
  end;

implementation

{ TSortingIterator }

// Heap functions: See https://github.com/Warfley/STAX/blob/master/src/stax.helpertypes.pas#L272

function TSortingIterator.hasLChild(AIndex: SizeInt): Boolean;
begin
  Result := AIndex * 2 + 1 < FHeapSize;
end;

function TSortingIterator.hasRChild(AIndex: SizeInt): Boolean;
begin
  Result := AIndex * 2 + 2 < FHeapSize;
end;

class function TSortingIterator.isRoot(AIndex: SizeInt): Boolean;
begin
  Result := AIndex = 0;
end;

class function TSortingIterator.getParent(AIndex: SizeInt): SizeInt;
begin
  Result := (AIndex - 1) div 2;
end;

class function TSortingIterator.getLChild(AIndex: SizeInt): SizeInt;
begin
  Result := AIndex * 2 + 1;
end;

class function TSortingIterator.getRChild(AIndex: SizeInt): SizeInt;
begin
  Result := AIndex * 2 + 2;
end;

function TSortingIterator.Compare(LIndex, RIndex: SizeInt): Boolean;
begin
  if FSortingFunctionData.isLess then
    Result := FSortingFunctionData.LessFunction.apply(FData[LIndex], FData[RIndex])
  else
    Result := FSortingFunctionData.CompareFunction.apply(FData[LIndex], FData[RIndex]) < 0;
end;

procedure TSortingIterator.Swap(AIndex, BIndex: SizeInt);
var
  tmp: T;
begin
  // Use move to avoid overhead of managed types
  Move(FData[AIndex], tmp, SizeOf(T));
  Move(FData[BIndex], FData[AIndex], SizeOf(T));
  Move(tmp, FData[BIndex], SizeOf(T));
end;

procedure TSortingIterator.Heapify(AIndex: SizeInt);
var
  SwapChild: SizeInt;
begin
  while hasLChild(AIndex) do
  begin
    if not HasRChild(AIndex) or Compare(getLChild(AIndex), getRChild(AIndex)) then
      SwapChild := getLChild(AIndex)
    else
      SwapChild := getRChild(AIndex);
    // If current is smaller than the smalles child, it is in the right place
    if Compare(AIndex, SwapChild) then
      Break;
    // Otherwise swap with child
    Swap(AIndex, SwapChild);
    // and continue checking that new place
    AIndex := SwapChild;
  end;
end;

function TSortingIterator.InsertData(constref AElem: T): SizeInt;
begin
  if FHeapSize >= Length(FData) then
    SetLength(FData, Length(FData) * 2);
  Result := FHeapSize;
  inc(FHeapSize);
  FData[Result] := AElem;
  While not isRoot(Result) and Compare(Result, getParent(Result)) do
  begin
    Swap(Result, getParent(Result));
    Result := getParent(Result);
  end;
end;

procedure TSortingIterator.FillData(AIterator: IIteratorType);
var
  Elem: T;
begin
  SetLength(FData, 2048 div SizeOf(T)); // Half a page
  FHeapSize := 0; // Empty heap
  for elem in AIterator do
    InsertData(Elem);
  // Shrink to fit
  SetLength(FData, FHeapSize);
end;

constructor TSortingIterator.Create(AIterator: IIteratorType;
  ASortingFunction: TSortingFunctionData);
begin
  inherited Create;
  FSortingFunctionData := ASortingFunction;
  FillData(AIterator);
  FFirstMove := True;
end;

constructor TSortingIterator.Create(AIterator: IIteratorType;
  ACompareFunction: TCompareFunction);
var
  SortingData: TSortingFunctionData;
begin
  SortingData.isLess := False;
  SortingData.CompareFunction := ACompareFunction;
  Create(AIterator, SortingData);
end;

constructor TSortingIterator.Create(AIterator: IIteratorType;
  ALessFunction: TLessFunction);
var
  SortingData: TSortingFunctionData;
begin
  SortingData.isLess := True;
  SortingData.LessFunction := ALessFunction;
  Create(AIterator, SortingData);
end;

function TSortingIterator.GetCurrent: T;
begin
  Result := FData[0];
end;

function TSortingIterator.MoveNext: Boolean;
begin
  if FFirstMove then
  begin
    FFirstMove := False;
    Exit(FHeapSize > 0);
  end;
  Dec(FHeapSize);
  Result := FHeapSize > 0;
  if not Result then
  begin
    FData := nil;
    Exit;
  end;
  Swap(0, FHeapSize);
  Heapify(0);
end;

{ TReverseIterator }

constructor TReverseIterator.Create(AIterator: specialize IIterator<T>);
begin
  inherited Create;
  FData := specialize CollectArrayGeometric<T>(AIterator);
  FIndex := Length(FData);
end;

function TReverseIterator.MoveNext: Boolean;
begin
  Dec(FIndex);
  Result := FIndex >= 0;
end;

function TReverseIterator.GetCurrent: T;
begin
  Result := FData[FIndex]
end;

end.

