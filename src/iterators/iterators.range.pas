unit Iterators.Range;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, iterators.base;

type

  { TRangeIterator }

  generic TRangeIterator<T> = class(specialize TIterator<T>)
  private
    FFirstStep: Boolean;
    FStart: T;
    FStop: T;
    FCurrent: T;
  public
    constructor Create(const AStart, AStop: T);

    function GetCurrent: T; override;
    function MoveNext: Boolean; override;
  end;

  { TStepRangeIterator }

  generic TStepRangeIterator<T> = class(specialize TIterator<T>)
  private  
    FFirstStep: Boolean;
    FStart: T;
    FStop: T;
    FStep: T;
    FCurrent: T;
  public
    constructor Create(const AStart, AStop, AStep: T);

    function GetCurrent: T; override;
    function MoveNext: Boolean; override;
  end;

implementation

{ TRangeIterator }

constructor TRangeIterator.Create(const AStart, AStop: T);
begin
  FFirstStep := True;
  FStart := AStart;
  FStop := AStop;
  FCurrent := AStart;
end;

function TRangeIterator.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TRangeIterator.MoveNext: Boolean;
begin
  Result := FCurrent < FStop;
  if Result then
    if FFirstStep then
      FFirstStep := False
    else
      Inc(FCurrent);
end;

{ TStepRangeIterator }

constructor TStepRangeIterator.Create(const AStart, AStop, AStep: T);
begin
  FFirstStep := True;
  FStart := AStart;
  FStop := AStop;
  FStep := AStep;
  FCurrent := AStart;
end;

function TStepRangeIterator.GetCurrent: T;
begin
  Result := FCurrent;
end;

function TStepRangeIterator.MoveNext: Boolean;
begin
  Result := FCurrent < FStop;
  if Result then
    if FFirstStep then
      FFirstStep := False
    else
      FCurrent += FStep;
end;

end.

