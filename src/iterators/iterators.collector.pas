unit iterators.collector;

{$mode objfpc}{$H+}
{$modeswitch advancedrecords}

interface

uses
  Classes, SysUtils, iterators.base, functypes;

generic function FoldLCollect<TResult, TData>(AIterator: specialize IIterator<TData>;
                                              const FoldFunction: specialize TAnyBinaryFunction<TResult, TResult, TData>;
                                              const InitialValue: TResult): TResult; inline;
generic function FoldRCollect<TResult, TData>(AIterator: specialize IIterator<TData>;
                                              const FoldFunction: specialize TAnyBinaryFunction<TResult, TData, TResult>;
                                              const InitialValue: TResult): TResult; inline;
generic function CollectArrayGeometric<T>(AIterator: specialize IIterator<T>): specialize TArray<T>;
generic function CollectArrayLinear<T>(AIterator: specialize IIterator<T>): specialize TArray<T>;
generic function CollectContainerAdd<T, TContainer>(AIterator: specialize IIterator<T>; AContainer: TContainer): TContainer; overload;
generic function CollectContainerAdd<T, TContainer>(AIterator: specialize IIterator<T>): TContainer; overload; inline;

implementation

generic function CollectArrayGeometric<T>(AIterator: specialize IIterator<T>): specialize TArray<T>;
var
  Head, len: SizeInt;
begin
  Result := nil;
  Head := 0;
  len := 2048 div SizeOf(T); // half a page
  SetLength(Result, len);
  while AIterator.MoveNext do
  begin
    if head >= len then
    begin
      len *= 2;
      SetLength(Result, len);
    end;
    Result[Head] := AIterator.Current;
    Inc(Head);
  end;
  SetLength(Result, Head);
end;

generic function CollectArrayLinear<T>(AIterator: specialize IIterator<T>): specialize TArray<T>;
begin
  Result := nil;
  while AIterator.MoveNext do
    Insert(AIterator.Current, Result, Length(Result));
end;
                                                                                              
generic function CollectContainerAdd<T, TContainer>(AIterator: specialize IIterator<T>; AContainer: TContainer): TContainer;
begin
  Result := AContainer;
  while AIterator.MoveNext do
    Result.Add(AIterator.Current);
end;

generic function CollectContainerAdd<T, TContainer>(AIterator: specialize IIterator<T>): TContainer;
begin
  Result := specialize CollectContainerAdd<T, TContainer>(AIterator, TContainer.Create);
end;

generic function FoldLCollect<TResult, TData>(AIterator: specialize IIterator<TData>;
                                              const FoldFunction: specialize TAnyBinaryFunction<TResult, TResult, TData>;
                                              const InitialValue: TResult): TResult;
begin
  Result := InitialValue;
  while AIterator.MoveNext do
    Result := FoldFunction.apply(Result, AIterator.Current);
end;

generic function FoldRCollect<TResult, TData>(AIterator: specialize IIterator<TData>;
                                              const FoldFunction: specialize TAnyBinaryFunction<TResult, TData, TResult>;
                                              const InitialValue: TResult): TResult;
var
  arr: Array of TData;
  i: SizeInt;
begin
  Result := InitialValue;
  Arr := specialize CollectArrayGeometric<TData>(AIterator);
  for i := High(arr) downto Low(arr) do
    Result := FoldFunction.apply(arr[i], Result);
end;

end.

