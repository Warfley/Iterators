unit iterators.typing;

{$mode objfpc}{$H+}

interface

uses
  iterators.base;

type

  { TCastIterator }

  generic TCastIterator<TFrom, TTo> = class(specialize TIteratorIterator<TTo, TFrom>)
  public
    function GetCurrent: TTo; override;
    function MoveNext: Boolean; override;
  end;

  { TCastObjectIterator }

  generic TCastObjectIterator<TFrom, TTo: TObject> = class(specialize TIteratorIterator<TTo, TFrom>)
  public
    function GetCurrent: TTo; override;
    function MoveNext: Boolean; override;
  end;

  { TCastPointerObjectIterator }

  generic TCastPointerObjectIterator<TTo: TObject> = class(specialize TIteratorIterator<TTo, Pointer>)
  public
    function GetCurrent: TTo; override;
    function MoveNext: Boolean; override;
  end;

  { TFilterTypeIterator }

  generic TFilterTypeIterator<TBaseType, TFilterType: TObject> = class(specialize TIteratorIterator<TFilterType, TBaseType>)
  private
    FCurrent: TFilterType;

    function ChecktypeAndUpdateCurrent: Boolean;
  public
    function GetCurrent: TFilterType; override;
    function MoveNext: Boolean; override;
  end;

  { TClassTypesIterator }

  generic TClassTypesIterator<T: TObject> = class(specialize TIteratorIterator<TClass, T>)
  public
    function GetCurrent: TClass; override;
    function MoveNext: Boolean; override;
  end;

implementation

{ TCastPointerObjectIterator }

function TCastPointerObjectIterator.GetCurrent: TTo;
begin
  Result := TObject(IteratorCurrent) as TTo;
end;

function TCastPointerObjectIterator.MoveNext: Boolean;
begin
  Result := IteratorMoveNext;
end;

{ TClassTypesIterator }

function TClassTypesIterator.GetCurrent: TClass;
begin
  Result := IteratorCurrent.ClassType;
end;

function TClassTypesIterator.MoveNext: Boolean;
begin
  Result := IteratorMoveNext;
end;

{ TFilterTypeIterator }

function TFilterTypeIterator.ChecktypeAndUpdateCurrent: Boolean;
var
  NewCurrent: TBaseType;
begin
  NewCurrent := IteratorCurrent;
  Result := NewCurrent is TFilterType;
  if Result then // will only be touched if Result is True, but to make typecast checks happy
    FCurrent := TFilterType(NewCurrent);
end;

function TFilterTypeIterator.GetCurrent: TFilterType;
begin
  Result := FCurrent;
end;

function TFilterTypeIterator.MoveNext: Boolean;
begin
  repeat
    Result := IteratorMoveNext;
  until not Result or ChecktypeAndUpdateCurrent;
end;

{ TAsIterator }

function TCastObjectIterator.GetCurrent: TTo;
begin
  Result := IteratorCurrent as TTo;
end;

function TCastObjectIterator.MoveNext: Boolean;
begin
  Result := IteratorMoveNext;
end;

{ TCastIterator }

function TCastIterator.GetCurrent: TTo;
begin
  Result := TTo(IteratorCurrent);
end;

function TCastIterator.MoveNext: Boolean;
begin
  Result := IteratorMoveNext;
end;

end.

