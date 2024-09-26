unit iterators;

{$mode objfpc}{$H+}
{$ModeSwitch nestedprocvars}

interface

uses
  Classes, SysUtils, functypes,

  iterators.base, iterators.map, iterators.filter, iterators.take,
  iterators.skip, iterators.typing, iterators.ordering, iterators.helper,
  iterators.collector, iterators.strings, iterators.expand,

  Generics.Collections, TupleTypes, Nullable;

type
  EEndOfIterator = class(Exception);

// Create Iterators from base type
generic function Iterate<T>(const AArray: specialize TArray<T>): specialize IIterator<T>; overload; inline;
generic function Iterate(const AString: String): specialize IIterator<Char>; overload; inline;
generic function Iterate<T>(const AEnumarble: specialize IEnumerable<T>): specialize IIterator<T>; overload; inline;
// Generics.collections support
generic function Iterate<T>(const AEnumarble: specialize TEnumerable<T>): specialize IIterator<T>; overload; inline;
generic function Iterate<T, U>(const ADictionairy: specialize TDictionary<T, U>): specialize IIterator<Generics.Collections.specialize TPair<T, U>>;
// Classic pascal containers
function Iterate(const AStrings: TStrings): specialize IIterator<String>; overload; inline;
function Iterate(const AList: Classes.TList): specialize IIterator<Pointer>; overload; inline;
// String interators
function Split(const AString: String; const ADelimiter: String): specialize IIterator<String>; overload; inline;
function Split(AIterator: specialize IIterator<Char>; const ADelimiter: String): specialize IIterator<String>; overload; inline;
function InBetween(AIterator: specialize IIterator<Char>; const AStart, AEnd: String): specialize IIterator<String>; overload; inline;
function IterateUTF8(const AString: String): specialize IIterator<String>; inline; overload;
function IterateUTF8(const AIterator: specialize IIterator<Char>): specialize IIterator<String>; inline; overload;

// Map functions
generic function Map<TFrom, TTo>(AIterator: specialize IIterator<TFrom>;
  AFunction: specialize TUnaryFunction<TTo, TFrom>): specialize IIterator<TTo>; overload; inline;
generic function Map<TFrom, TTo>(AIterator: specialize IIterator<TFrom>;
  AFunction: specialize TConstUnaryFunction<TTo, TFrom>): specialize IIterator<TTo>; overload; inline;
generic function Map<TFrom, TTo>(AIterator: specialize IIterator<TFrom>;
  AFunction: specialize TUnaryFunctionMethod<TTo, TFrom>): specialize IIterator<TTo>; overload; inline;
generic function Map<TFrom, TTo>(AIterator: specialize IIterator<TFrom>;
  AFunction: specialize TConstUnaryFunctionMethod<TTo, TFrom>): specialize IIterator<TTo>; overload; inline;
generic function Map<TFrom, TTo>(AIterator: specialize IIterator<TFrom>;
  AFunction: specialize TUnaryFunctionNested<TTo, TFrom>): specialize IIterator<TTo>; overload; inline;
generic function Map<TFrom, TTo>(AIterator: specialize IIterator<TFrom>;
  AFunction: specialize TConstUnaryFunctionNested<TTo, TFrom>): specialize IIterator<TTo>; overload; inline;

// Filter functions
generic function Filter<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunction<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function Filter<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunction<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function Filter<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunctionMethod<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function Filter<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function Filter<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunctionNested<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function Filter<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunctionNested<Boolean, T>): specialize IIterator<T>; overload; inline;


// Take and Takewhile
generic function Take<T>(AIterator: specialize IIterator<T>; ACount: SizeInt):
  specialize IIterator<T>; overload;
generic function TakeWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunction<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function TakeWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunction<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function TakeWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunctionMethod<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function TakeWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function TakeWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunctionNested<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function TakeWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunctionNested<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function TakeUntil<T>(AIterator: specialize IIterator<T>;
  const ASequence: specialize TArray<T>; AIncludeSequence: Boolean = False):
  specialize IIterator<T>; overload; inline;   
generic function TakeUntil<T>(AIterator: specialize IIterator<T>;
  const ASequence: array of T; AIncludeSequence: Boolean = False): specialize IIterator<T>; overload; inline; 
function TakeUntil(AIterator: specialize IIterator<Char>; const ASequence: String;
  AIncludeSequence: Boolean = False): specialize IIterator<Char>; overload; inline;

// Skip and SkipWhile
generic function Skip<T>(AIterator: specialize IIterator<T>; ACount: SizeInt):
  specialize IIterator<T>; overload;
generic function SkipWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunction<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function SkipWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunction<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function SkipWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunctionMethod<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function SkipWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function SkipWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunctionNested<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function SkipWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunctionNested<Boolean, T>): specialize IIterator<T>; overload; inline;
generic function SkipUntil<T>(AIterator: specialize IIterator<T>;
  const ASequence: specialize TArray<T>; ASkipSequence: Boolean = False):
  specialize IIterator<T>; overload; inline;
generic function SkipUntil<T>(AIterator: specialize IIterator<T>;
  const ASequence: array of T; ASkipSequence: Boolean = False): specialize IIterator<T>; overload; inline;
function SkipUntil(AIterator: specialize IIterator<Char>; const ASequence: String;
  ASkipSequence: Boolean = False): specialize IIterator<Char>; overload; inline;

// Expanding functions
generic function Expand<TSource, TTarget>(
    AIterator: specialize IIterator<TSource>;
    AExpandFunction: specialize TUnaryFunction<specialize IIterator<TSource>, TSource>
  ): specialize IIterator<TTarget>; overload; inline;
generic function Expand<TSource, TTarget>(
    AIterator: specialize IIterator<TSource>;
    AExpandFunction: specialize TConstUnaryFunction<specialize IIterator<TSource>, TSource>
  ): specialize IIterator<TTarget>; overload; inline;
generic function Expand<TSource, TTarget>(
    AIterator: specialize IIterator<TSource>;
    AExpandFunction: specialize TUnaryFunctionMethod<specialize IIterator<TSource>, TSource>
  ): specialize IIterator<TTarget>; overload; inline;
generic function Expand<TSource, TTarget>(
    AIterator: specialize IIterator<TSource>;
    AExpandFunction: specialize TConstUnaryFunctionMethod<specialize IIterator<TSource>, TSource>
  ): specialize IIterator<TTarget>; overload; inline;
generic function Expand<TSource, TTarget>(
    AIterator: specialize IIterator<TSource>;
    AExpandFunction: specialize TUnaryFunctionNested<specialize IIterator<TSource>, TSource>
  ): specialize IIterator<TTarget>; overload; inline;
generic function Expand<TSource, TTarget>(
    AIterator: specialize IIterator<TSource>;
    AExpandFunction: specialize TConstUnaryFunctionNested<specialize IIterator<TTarget>, TSource>
  ): specialize IIterator<TTarget>; overload; inline;

// TODO: Add one type expand functions for implicit specialization?

generic function ExpandArrays<T>(AIterator: specialize IIterator<specialize TArray<T>>): specialize IIterator<T>; inline;
function ExpandStrings(AIterator: specialize IIterator<String>): specialize IIterator<Char>; inline;

// Typing functions
generic function Cast<TFrom, TTo>(AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>; overload; inline;
generic function CastObject<TFrom, TTo: TObject>(AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>; overload; inline;
generic function CastObject<TTo: TObject>(AIterator: specialize IIterator<TObject>): specialize IIterator<TTo>; overload; inline;
generic function CastObject<TTo: TObject>(AIterator: specialize IIterator<Pointer>): specialize IIterator<TTo>; overload; inline;
generic function FilterClass<TBaseClass, TFilterClass: TObject>(AIterator: specialize IIterator<TBaseClass>): specialize IIterator<TFilterClass>; overload; inline;
generic function FilterClass<TFilterClass: TObject>(AIterator: specialize IIterator<TObject>): specialize IIterator<TFilterClass>; overload; inline;
generic function ClassTypes<TBaseClass: TObject>(AIterator: specialize IIterator<TBaseClass>): specialize IIterator<TClass>; overload; inline;
function ClassTypes(AIterator: specialize IIterator<TObject>): specialize IIterator<TClass>; overload; inline;

// Fold/Reduce
generic function FoldL<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TBinaryFunction<TResult, TResult, TData>; const InitialData: TResult): TResult; overload; inline;
generic function FoldL<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TConstBinaryFunction<TResult, TResult, TData>; const InitialData: TResult): TResult; overload; inline;
generic function FoldL<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TBinaryFunctionMethod<TResult, TResult, TData>; const InitialData: TResult): TResult; overload; inline;
generic function FoldL<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TConstBinaryFunctionMethod<TResult, TResult, TData>; const InitialData: TResult): TResult; overload; inline;
generic function FoldL<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TBinaryFunctionNested<TResult, TResult, TData>; const InitialData: TResult): TResult; overload; inline;
generic function FoldL<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TConstBinaryFunctionNested<TResult, TResult, TData>; const InitialData: TResult): TResult; overload; inline;

generic function FoldR<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TBinaryFunction<TResult, TData, TResult>; const InitialData: TResult): TResult; overload; inline;
generic function FoldR<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TConstBinaryFunction<TResult, TData, TResult>; const InitialData: TResult): TResult; overload; inline;
generic function FoldR<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TBinaryFunctionMethod<TResult, TData, TResult>; const InitialData: TResult): TResult; overload; inline;
generic function FoldR<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TConstBinaryFunctionMethod<TResult, TData, TResult>; const InitialData: TResult): TResult; overload; inline;
generic function FoldR<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TBinaryFunctionNested<TResult, TData, TResult>; const InitialData: TResult): TResult; overload; inline;
generic function FoldR<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TConstBinaryFunctionNested<TResult, TData, TResult>; const InitialData: TResult): TResult; overload; inline;

generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunction<T, T, T>; const InitialData: T): T; overload; inline;
generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunction<T, T, T>; const InitialData: T): T; overload; inline;
generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionMethod<T, T, T>; const InitialData: T): T; overload; inline;
generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionMethod<T, T, T>; const InitialData: T): T; overload; inline;
generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionNested<T, T, T>; const InitialData: T): T; overload; inline;
generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionNested<T, T, T>; const InitialData: T): T; overload; inline;

generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunction<T, T, T>): T; overload; inline;
generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunction<T, T, T>): T; overload; inline;
generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionMethod<T, T, T>): T; overload; inline;
generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionMethod<T, T, T>): T; overload; inline;
generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionNested<T, T, T>): T; overload; inline;
generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionNested<T, T, T>): T; overload; inline;

// special Reduce
generic function Sum<T>(AIterator: specialize IIterator<T>): T; overload; inline;
generic function Product<T>(AIterator: specialize IIterator<T>): T; overload; inline;
function Join(AIterator: specialize IIterator<String>; const Delimiter: String; GeometricGrowth: Boolean = True): String; overload; inline;
function Join(AIterator: specialize IIterator<Char>; GeometricGrowth: Boolean = True): String; overload; inline;
function Join(AIterator: specialize IIterator<String>; GeometricGrowth: Boolean = True): String; overload; inline;

// Collect
generic function CollectArray<T>(AIterator: specialize IIterator<T>; GeometricGrowth: Boolean = True): specialize TArray<T>; inline;
generic function Collect<T, TContainer>(AIterator: specialize IIterator<T>): TContainer; overload; inline;
generic function Collect<T, TContainer>(AIterator: specialize IIterator<T>; AContainer: TContainer): TContainer; overload; inline;

// Index
generic function Index<T>(AIterator: specialize IIterator<T>): specialize IIterator<specialize TPair<SizeInt, T>>; inline;

// Step
generic function Step<T>(AIterator: specialize IIterator<T>; StepSize: SizeInt): specialize IIterator<T>; inline;

// Ordering
generic function Reverse<T>(AIterator: specialize IIterator<T>): specialize IIterator<T>; inline;
// Sorting: Compare function
generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunction<Integer, T, T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunction<Integer, T, T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionMethod<Integer, T, T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionMethod<Integer, T, T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionNested<Integer, T, T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionNested<Integer, T, T>): specialize IIterator<T>; overload; inline;
// Sorting: Less function
generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunction<Boolean, T, T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunction<Boolean, T, T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionMethod<Boolean, T, T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionMethod<Boolean, T, T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionNested<Boolean, T, T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionNested<Boolean, T, T>): specialize IIterator<T>; overload; inline;

// Get Next element from iterator
generic function Next<T>(AIterator: specialize IIterator<T>; out AValue: T): Boolean; overload; inline;
generic function Next<T>(AIterator: specialize IIterator<T>): T; overload; inline;
generic function NextOpt<T>(AIterator: specialize IIterator<T>): specialize TNullable<T>; overload; inline;
// Get the Last element from iterator
generic function Last<T>(AIterator: specialize IIterator<T>; out AValue: T): Boolean; overload; inline;
generic function Last<T>(AIterator: specialize IIterator<T>): T; overload; inline;
generic function LastOpt<T>(AIterator: specialize IIterator<T>): specialize TNullable<T>; overload; inline;

implementation

{ Iterate Functions }

generic function Iterate<T>(const AArray: specialize TArray<T>): specialize IIterator<T>;
begin
  Result := specialize TArrayIterator<T>.Create(AArray);
end;

generic function Iterate(const AString: String): specialize IIterator<Char>;
begin
  Result := TCharIterator.Create(AString);
end;

generic function Iterate<T>(const AEnumarble: specialize IEnumerable<T>): specialize IIterator<T>;
begin
  Result := specialize TInteraceEnumeratorIterator<T, specialize IEnumerator<T>>.Create(AEnumarble.GetEnumerator);
end; 

generic function Iterate<T>(const AEnumarble: specialize TEnumerable<T>): specialize IIterator<T>;
begin
  Result := specialize TClassEnumeratorIterator<T, specialize TEnumerator<T>>.Create(AEnumarble.GetEnumerator);
end;

generic function Iterate<T, U>(const ADictionairy: specialize TDictionary<T, U>): specialize IIterator<Generics.Collections.specialize TPair<T, U>>;
begin
  Result := specialize TClassEnumeratorIterator<Generics.Collections.specialize TPair<T, U>, specialize TDictionary<T, U>.TPairEnumerator>.Create(ADictionairy.GetEnumerator);
end;

function Iterate(const AStrings: TStrings): specialize IIterator<String>;
begin
  Result := specialize TClassEnumeratorIterator<String, Classes.TStringsEnumerator>.Create(AStrings.GetEnumerator);
end;

function Iterate(const AList: Classes.TList): specialize IIterator<Pointer>;
begin
  Result := specialize TClassEnumeratorIterator<Pointer, Classes.TListEnumerator>.Create(AList.GetEnumerator);
end;

{ Other Iterators }

function Split(const AString: String; const ADelimiter: String): specialize IIterator<String>;
begin
  Result := TStringSplitIterator.Create(AString, ADelimiter);
end;    

function Split(AIterator: specialize IIterator<Char>; const ADelimiter: String
  ): specialize IIterator<String>;
begin
  Result := TCharSplitIterator.Create(AIterator, ADelimiter);
end;

function InBetween(AIterator: specialize IIterator<Char>; const AStart,
  AEnd: String): specialize IIterator<String>;
begin
  Result := TInBetweenIterator.Create(AIterator, AStart, AEnd);
end;

function IterateUTF8(const AString: String): specialize IIterator<String>;
begin
  Result := TUTF8Iterator.Create(AString);
end; 

function IterateUTF8(const AIterator: specialize IIterator<Char>): specialize IIterator<String>;
begin
  Result := TUTF8AggregateIterator.Create(AIterator);
end;

{ Map Functions }
generic function Map<TFrom, TTo>(AIterator: specialize IIterator<TFrom>;
  AFunction: specialize TUnaryFunction<TTo, TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(AIterator, AFunction);
end;

generic function Map<TFrom, TTo>(AIterator: specialize IIterator<TFrom>;
  AFunction: specialize TConstUnaryFunction<TTo, TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(AIterator, AFunction);
end;

generic function Map<TFrom, TTo>(AIterator: specialize IIterator<TFrom>;
  AFunction: specialize TUnaryFunctionMethod<TTo, TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(AIterator, AFunction);
end;

generic function Map<TFrom, TTo>(AIterator: specialize IIterator<TFrom>;
  AFunction: specialize TConstUnaryFunctionMethod<TTo, TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(AIterator, AFunction);
end;

generic function Map<TFrom, TTo>(AIterator: specialize IIterator<TFrom>;
  AFunction: specialize TUnaryFunctionNested<TTo, TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(AIterator, AFunction);
end;

generic function Map<TFrom, TTo>(AIterator: specialize IIterator<TFrom>;
  AFunction: specialize TConstUnaryFunctionNested<TTo, TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(AIterator, AFunction);
end;

{ Filter Functions }

generic function Filter<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunction<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TFilterIterator<T>.Create(AIterator, AFunction);
end;

generic function Filter<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunction<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TFilterIterator<T>.Create(AIterator, AFunction);
end;

generic function Filter<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunctionMethod<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TFilterIterator<T>.Create(AIterator, AFunction);
end;

generic function Filter<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TFilterIterator<T>.Create(AIterator, AFunction);
end;

generic function Filter<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunctionNested<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TFilterIterator<T>.Create(AIterator, AFunction);
end;

generic function Filter<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunctionNested<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TFilterIterator<T>.Create(AIterator, AFunction);
end;
  
{ Take and TakeWhile Functions }

generic function Take<T>(AIterator: specialize IIterator<T>; ACount: SizeInt):
  specialize IIterator<T>;
begin
  Result := specialize TTakeIterator<T>.Create(AIterator, ACount);
end;

generic function TakeWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunction<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function TakeWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunction<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function TakeWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunctionMethod<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function TakeWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function TakeWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunctionNested<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function TakeWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunctionNested<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function TakeUntil<T>(AIterator: specialize IIterator<T>;
  const ASequence: specialize TArray<T>; AIncludeSequence: Boolean = False):
  specialize IIterator<T>;
begin
  Result := specialize TTakeUntilIterator<T>.Create(AIterator, ASequence, AIncludeSequence);
end;

generic function TakeUntil<T>(AIterator: specialize IIterator<T>;
  const ASequence: array of T; AIncludeSequence: Boolean = False): specialize IIterator<T>;
begin
  Result := specialize TTakeUntilIterator<T>.Create(AIterator, ASequence, AIncludeSequence);
end;

function TakeUntil(AIterator: specialize IIterator<Char>;
  const ASequence: String; AIncludeSequence: Boolean): specialize IIterator<Char
  >;
begin
  Result := TTakeUntilStringIterator.Create(AIterator, ASequence, AIncludeSequence);
end;

{ Skip and SkipWhile Functions }

generic function Skip<T>(AIterator: specialize IIterator<T>; ACount: SizeInt):
  specialize IIterator<T>;
begin
  Result := specialize TSkipIterator<T>.Create(AIterator, ACount);
end;

generic function SkipWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunction<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function SkipWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunction<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function SkipWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunctionMethod<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function SkipWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function SkipWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TUnaryFunctionNested<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function SkipWhile<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstUnaryFunctionNested<Boolean, T>): specialize IIterator<T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function SkipUntil<T>(AIterator: specialize IIterator<T>;
  const ASequence: specialize TArray<T>; ASkipSequence: Boolean):
  specialize IIterator<T>;
begin
  Result := specialize TSkipUntilIterator<T>.Create(AIterator, ASequence, ASkipSequence);
end;

generic function SkipUntil<T>(AIterator: specialize IIterator<T>;
  const ASequence: array of T; ASkipSequence: Boolean): specialize IIterator<T>;
begin
  Result := specialize TSkipUntilIterator<T>.Create(AIterator, ASequence, ASkipSequence);
end;

function SkipUntil(AIterator: specialize IIterator<Char>;
  const ASequence: String; ASkipSequence: Boolean): specialize IIterator<Char>;
begin
  Result := TSkipUntilStringIterator.Create(AIterator, ASequence, ASkipSequence);
end;

{ Expand Functions }

generic function Expand<TSource, TTarget>(
    AIterator: specialize IIterator<TSource>;
    AExpandFunction: specialize TUnaryFunction<specialize IIterator<TSource>, TSource>
  ): specialize IIterator<TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(AIterator, AExpandFunction);
end;

generic function Expand<TSource, TTarget>(
    AIterator: specialize IIterator<TSource>;
    AExpandFunction: specialize TConstUnaryFunction<specialize IIterator<TSource>, TSource>
  ): specialize IIterator<TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(AIterator, AExpandFunction);
end;

generic function Expand<TSource, TTarget>(
    AIterator: specialize IIterator<TSource>;
    AExpandFunction: specialize TUnaryFunctionMethod<specialize IIterator<TSource>, TSource>
  ): specialize IIterator<TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(AIterator, AExpandFunction);
end;

generic function Expand<TSource, TTarget>(
    AIterator: specialize IIterator<TSource>;
    AExpandFunction: specialize TConstUnaryFunctionMethod<specialize IIterator<TSource>, TSource>
  ): specialize IIterator<TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(AIterator, AExpandFunction);
end;

generic function Expand<TSource, TTarget>(
    AIterator: specialize IIterator<TSource>;
    AExpandFunction: specialize TUnaryFunctionNested<specialize IIterator<TSource>, TSource>
  ): specialize IIterator<TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(AIterator, AExpandFunction);
end;

generic function Expand<TSource, TTarget>(
    AIterator: specialize IIterator<TSource>;
    AExpandFunction: specialize TConstUnaryFunctionNested<specialize IIterator<TTarget>, TSource>
  ): specialize IIterator<TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(AIterator, AExpandFunction);
end;

generic function ExpandArrays<T>(AIterator: specialize IIterator<specialize TArray<T>>): specialize IIterator<T>;
begin
  Result := specialize TArrayExpandIterator<T>.Create(AIterator);
end;

function ExpandStrings(AIterator: specialize IIterator<String>): specialize IIterator<Char>;
begin
  Result := TExpandStringIterator.Create(AIterator);
end;

{ Typing functions }

generic function Cast<TFrom, TTo>(AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TCastIterator<TFrom, TTo>.Create(AIterator);
end;

generic function CastObject<TFrom, TTo>(AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TCastObjectIterator<TFrom, TTo>.Create(AIterator);
end;

generic function CastObject<TTo>(AIterator: specialize IIterator<TObject>): specialize IIterator<TTo>;
begin
  Result := specialize TCastObjectIterator<TObject, TTo>.Create(AIterator);
end;

generic function CastObject<TTo>(AIterator: specialize IIterator<Pointer>): specialize IIterator<TTo>;
begin
  Result := specialize TCastPointerObjectIterator<TTo>.Create(AIterator);
end;

generic function FilterClass<TBaseClass, TFilterClass>(AIterator: specialize IIterator<TBaseClass>): specialize IIterator<TFilterClass>;
begin
  Result := specialize TFilterTypeIterator<TBaseClass, TFilterClass>.Create(AIterator);
end; 

generic function FilterClass<TFilterClass>(AIterator: specialize IIterator<TObject>): specialize IIterator<TFilterClass>;
begin
  Result := specialize TFilterTypeIterator<TObject, TFilterClass>.Create(AIterator);
end;

generic function ClassTypes<TBaseClass>(AIterator: specialize IIterator<TBaseClass>): specialize IIterator<TClass>;
begin
  Result := specialize TClassTypesIterator<TBaseClass>.Create(AIterator);
end;

function ClassTypes(AIterator: specialize IIterator<TObject>): specialize IIterator<TClass>;
begin
  Result := specialize TClassTypesIterator<TObject>.Create(AIterator);
end;

{ Fold/Reduce }

// FOLDL

generic function FoldL<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TBinaryFunction<TResult, TResult, TData>; const InitialData: TResult): TResult;
begin
  Result := specialize FoldLCollect<TResult, TData>(AIterator, AFunction, InitialData);
end;

generic function FoldL<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TConstBinaryFunction<TResult, TResult, TData>; const InitialData: TResult): TResult;
begin
  Result := specialize FoldLCollect<TResult, TData>(AIterator, AFunction, InitialData);
end;

generic function FoldL<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TBinaryFunctionMethod<TResult, TResult, TData>; const InitialData: TResult): TResult;
begin
  Result := specialize FoldLCollect<TResult, TData>(AIterator, AFunction, InitialData);
end;

generic function FoldL<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TConstBinaryFunctionMethod<TResult, TResult, TData>; const InitialData: TResult): TResult;
begin
  Result := specialize FoldLCollect<TResult, TData>(AIterator, AFunction, InitialData);
end;

generic function FoldL<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TBinaryFunctionNested<TResult, TResult, TData>; const InitialData: TResult): TResult;
begin
  Result := specialize FoldLCollect<TResult, TData>(AIterator, AFunction, InitialData);
end;

generic function FoldL<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TConstBinaryFunctionNested<TResult, TResult, TData>; const InitialData: TResult): TResult;
begin
  Result := specialize FoldLCollect<TResult, TData>(AIterator, AFunction, InitialData);
end;

// FoldR

generic function FoldR<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TBinaryFunction<TResult, TData, TResult>; const InitialData: TResult): TResult;
begin
  Result := specialize FoldRCollect<TResult, TData>(AIterator, AFunction, InitialData);
end;

generic function FoldR<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TConstBinaryFunction<TResult, TData, TResult>; const InitialData: TResult): TResult;
begin
  Result := specialize FoldRCollect<TResult, TData>(AIterator, AFunction, InitialData);
end;

generic function FoldR<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TBinaryFunctionMethod<TResult, TData, TResult>; const InitialData: TResult): TResult;
begin
  Result := specialize FoldRCollect<TResult, TData>(AIterator, AFunction, InitialData);
end;

generic function FoldR<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TConstBinaryFunctionMethod<TResult, TData, TResult>; const InitialData: TResult): TResult;
begin
  Result := specialize FoldRCollect<TResult, TData>(AIterator, AFunction, InitialData);
end;

generic function FoldR<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TBinaryFunctionNested<TResult, TData, TResult>; const InitialData: TResult): TResult;
begin
  Result := specialize FoldRCollect<TResult, TData>(AIterator, AFunction, InitialData);
end;

generic function FoldR<TResult, TData>(AIterator: specialize IIterator<TData>;
  AFunction: specialize TConstBinaryFunctionNested<TResult, TData, TResult>; const InitialData: TResult): TResult;
begin
  Result := specialize FoldRCollect<TResult, TData>(AIterator, AFunction, InitialData);
end;

// Reduce InitialData

generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunction<T, T, T>; const InitialData: T): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, AFunction, InitialData);
end;

generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunction<T, T, T>; const InitialData: T): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, AFunction, InitialData);
end;

generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionMethod<T, T, T>; const InitialData: T): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, AFunction, InitialData);
end;

generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionMethod<T, T, T>; const InitialData: T): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, AFunction, InitialData);
end;

generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionNested<T, T, T>; const InitialData: T): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, AFunction, InitialData);
end;

generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionNested<T, T, T>; const InitialData: T): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, AFunction, InitialData);
end;

// Reduce Default

generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunction<T, T, T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, AFunction, Default(T));
end;

generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunction<T, T, T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, AFunction, Default(T));
end;

generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionMethod<T, T, T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, AFunction, Default(T));
end;

generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionMethod<T, T, T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, AFunction, Default(T));
end;

generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionNested<T, T, T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, AFunction, Default(T));
end;

generic function Reduce<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionNested<T, T, T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, AFunction, Default(T));
end;

generic function Sum<T>(AIterator: specialize IIterator<T>): T;

function _Add(const A, B: T): T;
begin
  Result := A + B;
end;

begin
  Result := specialize FoldLCollect<T, T>(AIterator, @_Add, Default(T));
end;

generic function Product<T>(AIterator: specialize IIterator<T>): T;

function _Mul(const A, B: T): T;
begin
  Result := A * B;
end;

begin
  Result := specialize FoldLCollect<T, T>(AIterator, @_Mul, 1);
end;

function Join(AIterator: specialize IIterator<String>; const Delimiter: String; GeometricGrowth: Boolean): String;
begin
  if GeometricGrowth then
    Result := JoinCollectGeometric(AIterator, Delimiter)
  else
    Result := JoinCollectLinear(AIterator, Delimiter);
end; 

function Join(AIterator: specialize IIterator<Char>; GeometricGrowth: Boolean): String;
begin
  if GeometricGrowth then
    Result := CollectStringGeometric(AIterator)
  else
    Result := CollectStringLinear(AIterator);
end;  

function Join(AIterator: specialize IIterator<String>; GeometricGrowth: Boolean): String;
begin
  if GeometricGrowth then
    Result := CollectStringGeometric(AIterator)
  else
    Result := CollectStringLinear(AIterator);
end;

{ Collectors }

generic function CollectArray<T>(AIterator: specialize IIterator<T>; GeometricGrowth: Boolean = True): specialize TArray<T>;
begin
  if GeometricGrowth then
    Result := specialize CollectArrayGeometric<T>(AIterator)
  else 
    Result := specialize CollectArrayLinear<T>(AIterator);
end;

generic function Collect<T, TContainer>(AIterator: specialize IIterator<T>): TContainer;
begin
  Result := specialize CollectContainerAdd<T, TContainer>(AIterator);
end;

generic function Collect<T, TContainer>(AIterator: specialize IIterator<T>; AContainer: TContainer): TContainer;
begin
  Result := specialize CollectContainerAdd<T, TContainer>(AIterator, AContainer);
end;

{ Index }

generic function Index<T>(AIterator: specialize IIterator<T>): specialize IIterator<specialize TPair<SizeInt, T>>;
begin
  Result := specialize TIndexIterator<T>.Create(AIterator);
end;

{ Step }
generic function Step<T>(AIterator: specialize IIterator<T>; StepSize: SizeInt): specialize IIterator<T>;
begin
  Result := specialize TStepIterator<T>.Create(AIterator, StepSize);
end;

{ Ordering }
generic function Reverse<T>(AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TReverseIterator<T>.Create(AIterator);
end;

generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunction<Integer, T, T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunction<Integer, T, T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionMethod<Integer, T, T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionMethod<Integer, T, T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionNested<Integer, T, T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionNested<Integer, T, T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

// Sorting: Less function

generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunction<Boolean, T, T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunction<Boolean, T, T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionMethod<Boolean, T, T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionMethod<Boolean, T, T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TBinaryFunctionNested<Boolean, T, T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AIterator: specialize IIterator<T>;
  AFunction: specialize TConstBinaryFunctionNested<Boolean, T, T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

{ Next/Last Functions }

generic function Next<T>(AIterator: specialize IIterator<T>; out AValue: T): Boolean;
begin
  Result := AIterator.MoveNext;
  if Result then
    AValue := AIterator.Current;
end;

generic function Next<T>(AIterator: specialize IIterator<T>): T;
begin
  if not specialize Next<T>(AIterator, Result) then
    raise EEndOfIterator.Create('Iterator has no next element');
end;

generic function NextOpt<T>(AIterator: specialize IIterator<T>): specialize TNullable<T>;
begin
  Result := nil;
  if AIterator.MoveNext then
    Result := AIterator.Current;
end;

generic function Last<T>(AIterator: specialize IIterator<T>; out AValue: T): Boolean;
begin
  Result := AIterator.MoveNext;
  if Result then repeat
    AValue := AIterator.Current;
  until not AIterator.MoveNext;
end;

generic function Last<T>(AIterator: specialize IIterator<T>): T;
begin
  if not specialize Last<T>(AIterator, Result) then
    raise EEndOfIterator.Create('Iterator has no next element');
end;

generic function LastOpt<T>(AIterator: specialize IIterator<T>): specialize TNullable<T>;
begin
  Result := nil;
  While AIterator.MoveNext do
    Result := AIterator.Current;
end;

end.

