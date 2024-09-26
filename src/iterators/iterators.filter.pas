unit iterators.filter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, iterators.base, functypes;

type

  { TFilterIterator }

  generic TFilterIterator<T> = class(specialize TIteratorIterator<T, T>)
  public type
    TFilterFunction = specialize TAnyUnaryFunction<Boolean, T>;
  private
    FFunction: TFilterFunction;
    FCurrent: T;

    function UpdateCurrentAndCheck: Boolean; inline;
  public
    constructor Create(AEnumerator: IIteratorType; AFilterFunction: TFilterFunction);

    function GetCurrent: T; override;
    function MoveNext: Boolean; override;
  end;

implementation

{ TFilterIterator }

function TFilterIterator.UpdateCurrentAndCheck: Boolean;
begin
  FCurrent := IteratorCurrent;
  Result := FFunction.apply(FCurrent);
end;

constructor TFilterIterator.Create(AEnumerator: IIteratorType;
  AFilterFunction: TFilterFunction);
begin
  inherited Create(AEnumerator);
  FFunction := AFilterFunction;
end;

function TFilterIterator.GetCurrent: T;
begin 
  Result := FCurrent;
end;

function TFilterIterator.MoveNext: Boolean;
begin
  repeat
    Result := IteratorMoveNext;
  until Not Result or UpdateCurrentAndCheck;
end;

end.

