unit iterators.expand;

{$mode objfpc}{$H+}

interface

uses
  iterators.base, FuncTypes;

type

  { TExpandIterator }

  generic TExpandIterator<TSource, TTarget> = class(specialize TIteratorIterator<TTarget, TSource>)
  public type
    TExansionIterator = specialize IIterator<TTarget>;
    TExpandFunction = specialize TAnyUnaryFunction<TExansionIterator, TSource>;
  private
    FExpandFunction: TExpandFunction;
    FCurrentExpansion: TExansionIterator;
  public
    constructor Create(AIterator: IIteratorType; AExpandFunction: TExpandFunction);

    function MoveNext: Boolean; override;
    function GetCurrent: TTarget; override;
  end;

  { TArrayExpandIterator }

  generic TArrayExpandIterator<T> = class(specialize TExpandIterator<specialize TArray<T>, T>)
  private
    function ExpandArray(Arr: specialize TArray<T>): specialize IIterator<T>;
  public
    constructor Create(AIterator: IIteratorType);
  end;

  { TExpandStringIterator }

  TExpandStringIterator = class(specialize TExpandIterator<String, Char>)
  private
    function ExpandString(const AString: String): specialize IIterator<Char>;
  public
    constructor Create(AIterator: IIteratorType);
  end;

implementation

uses
  Iterators.strings;

{ TExpandIterator }

constructor TExpandIterator.Create(AIterator: IIteratorType;
  AExpandFunction: TExpandFunction);
begin
  inherited Create(AIterator);
  FExpandFunction := AExpandFunction;
  FCurrentExpansion := nil;
end;

function TExpandIterator.MoveNext: Boolean;
begin
  Result := Assigned(FCurrentExpansion) and FCurrentExpansion.MoveNext;

  while not Result and IteratorMoveNext do
  begin
    FCurrentExpansion := FExpandFunction.apply(IteratorCurrent);
    Result := FCurrentExpansion.MoveNext;
  end;
end;

function TExpandIterator.GetCurrent: TTarget;
begin
  Result := FCurrentExpansion.Current;
end; 

{ TArrayExpandIterator }

function TArrayExpandIterator.ExpandArray(Arr: specialize TArray<T>
  ): specialize IIterator<T>;
begin
  Result := specialize TArrayIterator<T>.Create(Arr);
end;

constructor TArrayExpandIterator.Create(AIterator: IIteratorType);
begin
  inherited Create(AIterator, @ExpandArray);
end; 

{ TExpandStringIterator }

function TExpandStringIterator.ExpandString(const AString: String): specialize
  IIterator<Char>;
begin
  Result := TCharIterator.Create(AString);
end;

constructor TExpandStringIterator.Create(AIterator: IIteratorType);
begin
  inherited Create(AIterator, @ExpandString);
end;

end.

