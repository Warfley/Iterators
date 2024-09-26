unit iterators.map;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, iterators.base, functypes;

type

  { TMapIterator }

  generic TMapIterator<TFrom, TTo> = class(specialize TIteratorIterator<TTo, TFrom>)
  public type
    TMapFunction = specialize TAnyUnaryFunction<TTo, TFrom>;
  private
    FFunction: TMapFunction;
  public
    constructor Create(AEnumerator: IIteratorType; AMapFunction: TMapFunction);

    function GetCurrent: TTo; override;
    function MoveNext: Boolean; override;
  end;

implementation

{ TMapIterator }

constructor TMapIterator.Create(AEnumerator: IIteratorType;
  AMapFunction: TMapFunction);
begin
  inherited Create(AEnumerator);
  FFunction := AMapFunction;
end;

function TMapIterator.GetCurrent: TTo;
begin
  Result := FFunction.apply(IteratorCurrent);
end;

function TMapIterator.MoveNext: Boolean;
begin
  Result := IteratorMoveNext;
end;

end.

