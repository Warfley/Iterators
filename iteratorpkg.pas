{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit IteratorPkg;

{$warn 5023 off : no warning about unused units}
interface

uses
  TupleTypes, DynamicTypes, finalizers, FuncTypes, iterators, iterators.base,
  iterators.map, iterators.filter, iterators.take, iterators.skip,
  iterators.typing, iterators.helper, nonetype, iterators.collector,
  iterators.ordering, iterators.strings, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('Iterators', @Register);
end.
