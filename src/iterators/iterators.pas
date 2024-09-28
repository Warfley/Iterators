unit iterators;

{$mode objfpc}{$H+}
{$ModeSwitch nestedprocvars}

interface

uses
  Classes, SysUtils, functypes,

  iterators.base, iterators.map, iterators.filter, iterators.take,
  iterators.skip, iterators.typing, iterators.ordering, iterators.helper,
  iterators.collector, iterators.strings, iterators.expand, iterators.Range,
  iterators.streams,

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
// String iterators
function Split(const AString: String; const ADelimiter: String): specialize IIterator<String>; overload; inline;
function Split(AIterator: specialize IIterator<Char>; const ADelimiter: String): specialize IIterator<String>; overload; inline;
function InBetween(AIterator: specialize IIterator<Char>; const AStart, AEnd: String): specialize IIterator<String>; overload; inline;
function IterateUTF8(const AString: String): specialize IIterator<String>; inline; overload;
function IterateUTF8(const AIterator: specialize IIterator<Char>): specialize IIterator<String>; inline; overload;
// Range iterators
generic function IterateRange<T>(const AStart, AStop: T): specialize IIterator<T>; inline; overload;
generic function IterateRange<T>(const AStart, AStop, AStep: T): specialize IIterator<T>; inline; overload;
// Generators
generic function Generate<T>(
    AFunction: specialize TFunction<specialize TNullable<T>>
  ): specialize IIterator<T>; overload; inline;
generic function Generate<T>(
    AFunction: specialize TFunctionMethod<specialize TNullable<T>>
  ): specialize IIterator<T>; overload; inline;
generic function Generate<T>(
    AFunction: specialize TFunctionNested<specialize TNullable<T>>
  ): specialize IIterator<T>; overload; inline;

generic function GenerateInf<T>(AFunction: specialize TFunction<T>
  ): specialize IIterator<T>; overload; inline;
generic function GenerateInf<T>(AFunction: specialize TFunctionMethod<T>
  ): specialize IIterator<T>; overload; inline;
generic function GenerateInf<T>(AFunction: specialize TFunctionNested<T>
  ): specialize IIterator<T>; overload; inline;
// Stream iterators

generic function Iterate<T>(AStream: TStream; AOwnsStream: Boolean = True):
  specialize IIterator<T>; overload; inline;

generic function Iterate<T>(
  AFunction: specialize TUnaryFunction<specialize TNullable<T>, TStream>;
  AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<T>; overload; inline;
generic function Iterate<T>(
  AFunction: specialize TConstUnaryFunction<specialize TNullable<T>, TStream>;
  AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<T>; overload; inline;
generic function Iterate<T>(
  AFunction: specialize TUnaryFunctionMethod<specialize TNullable<T>, TStream>;
  AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<T>; overload; inline;
generic function Iterate<T>(
  AFunction: specialize TConstUnaryFunctionMethod<specialize TNullable<T>, TStream>;
  AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<T>; overload; inline;
generic function Iterate<T>(
  AFunction: specialize TUnaryFunctionNested<specialize TNullable<T>, TStream>;
  AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<T>; overload; inline;
generic function Iterate<T>(
  AFunction: specialize TConstUnaryFunctionNested<specialize TNullable<T>, TStream>;
  AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<T>; overload; inline;

function IterateLines(AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<String>; inline;
function IterateUTF8(AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<String>; overload; inline;

// Map functions
generic function Map<TFrom, TTo>(AFunction: specialize TUnaryFunction<TTo, TFrom>;
  const AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>; overload; inline;
generic function Map<TFrom, TTo>(AFunction: specialize TConstUnaryFunction<TTo, TFrom>;
  const AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>; overload; inline;
generic function Map<TFrom, TTo>(AFunction: specialize TUnaryFunctionMethod<TTo, TFrom>;
  const AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>; overload; inline;
generic function Map<TFrom, TTo>(AFunction: specialize TConstUnaryFunctionMethod<TTo, TFrom>;
  const AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>; overload; inline;
generic function Map<TFrom, TTo>(AFunction: specialize TUnaryFunctionNested<TTo, TFrom>;
  const AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>; overload; inline;
generic function Map<TFrom, TTo>(AFunction: specialize TConstUnaryFunctionNested<TTo, TFrom>;
  const AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>; overload; inline;

{
generic function Map<TFrom, TTo>(AFunction: specialize TUnaryFunction<TTo, TFrom>):
  specialize TIteratorCombinator<TTo, TFrom>; overload; inline;
generic function Map<TFrom, TTo>(AFunction: specialize TConstUnaryFunction<TTo, TFrom>):
  specialize TIteratorCombinator<TTo, TFrom>; overload; inline;
generic function Map<TFrom, TTo>(AFunction: specialize TUnaryFunctionMethod<TTo, TFrom>):
  specialize TIteratorCombinator<TTo, TFrom>; overload; inline;
generic function Map<TFrom, TTo>(AFunction: specialize TConstUnaryFunctionMethod<TTo, TFrom>):
  specialize TIteratorCombinator<TTo, TFrom>; overload; inline;
generic function Map<TFrom, TTo>(AFunction: specialize TUnaryFunctionNested<TTo, TFrom>):
  specialize TIteratorCombinator<TTo, TFrom>; overload; inline;
generic function Map<TFrom, TTo>(AFunction: specialize TConstUnaryFunctionNested<TTo, TFrom>):
  specialize TIteratorCombinator<TTo, TFrom>; overload; inline;
}

// Filter functions
generic function Filter<T>(AFunction: specialize TUnaryFunction<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function Filter<T>(AFunction: specialize TConstUnaryFunction<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function Filter<T>(AFunction: specialize TUnaryFunctionMethod<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function Filter<T>(AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function Filter<T>(AFunction: specialize TUnaryFunctionNested<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function Filter<T>(AFunction: specialize TConstUnaryFunctionNested<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;

{
generic function Filter<T>(AFunction: specialize TUnaryFunction<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function Filter<T>(AFunction: specialize TConstUnaryFunction<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function Filter<T>(AFunction: specialize TUnaryFunctionMethod<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function Filter<T>(AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function Filter<T>(AFunction: specialize TUnaryFunctionNested<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function Filter<T>(AFunction: specialize TConstUnaryFunctionNested<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
}

// Take and Takewhile
generic function Take<T>(ACount: SizeInt; const AIterator: specialize IIterator<T>):
  specialize IIterator<T>; overload; inline;
generic function TakeWhile<T>(AFunction: specialize TUnaryFunction<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function TakeWhile<T>(AFunction: specialize TConstUnaryFunction<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function TakeWhile<T>(AFunction: specialize TUnaryFunctionMethod<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function TakeWhile<T>(AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function TakeWhile<T>(AFunction: specialize TUnaryFunctionNested<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function TakeWhile<T>(AFunction: specialize TConstUnaryFunctionNested<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function TakeUntil<T>(const ASequence: specialize TArray<T>;
  const AIterator: specialize IIterator<T>; AIncludeSequence: Boolean = False):
  specialize IIterator<T>; overload; inline;
generic function TakeUntil<T>(const ASequence: array of T;
  const AIterator: specialize IIterator<T>; AIncludeSequence: Boolean = False):
  specialize IIterator<T>; overload; inline;
function TakeUntil(const ASequence: String; const AIterator: specialize IIterator<Char>;
  AIncludeSequence: Boolean = False): specialize IIterator<Char>; overload; inline;

{
generic function Take<T>(ACount: SizeInt): specialize TIteratorCombinator<T, T>; overload; inline;
generic function TakeWhile<T>(AFunction: specialize TUnaryFunction<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function TakeWhile<T>(AFunction: specialize TConstUnaryFunction<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function TakeWhile<T>(AFunction: specialize TUnaryFunctionMethod<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function TakeWhile<T>(AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function TakeWhile<T>(AFunction: specialize TUnaryFunctionNested<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function TakeWhile<T>(AFunction: specialize TConstUnaryFunctionNested<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function TakeUntil<T>(const ASequence: specialize TArray<T>;
  AIncludeSequence: Boolean = False): specialize TIteratorCombinator<T, T>; overload; inline;
generic function TakeUntil<T>(const ASequence: array of T;
  AIncludeSequence: Boolean = False): specialize TIteratorCombinator<T, T>; overload; inline;
function TakeUntil(const ASequence: String; AIncludeSequence: Boolean = False):
  specialize TIteratorCombinator<Char, Char>; overload; inline;
}

// Skip and SkipWhile
generic function Skip<T>(ACount: SizeInt; const AIterator: specialize IIterator<T>):
  specialize IIterator<T>; overload;
generic function SkipWhile<T>(AFunction: specialize TUnaryFunction<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function SkipWhile<T>(AFunction: specialize TConstUnaryFunction<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function SkipWhile<T>(AFunction: specialize TUnaryFunctionMethod<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function SkipWhile<T>(AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function SkipWhile<T>(AFunction: specialize TUnaryFunctionNested<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function SkipWhile<T>(AFunction: specialize TConstUnaryFunctionNested<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function SkipUntil<T>(const ASequence: specialize TArray<T>;
  const AIterator: specialize IIterator<T>; AIncludeSequence: Boolean = False):
  specialize IIterator<T>; overload; inline;
generic function SkipUntil<T>(const ASequence: array of T;
  const AIterator: specialize IIterator<T>; AIncludeSequence: Boolean = False):
  specialize IIterator<T>; overload; inline;
function SkipUntil(const ASequence: String; const AIterator: specialize IIterator<Char>;
  AIncludeSequence: Boolean = False): specialize IIterator<Char>; overload; inline;

{
generic function Skip<T>(ACount: SizeInt): specialize TIteratorCombinator<T, T>; overload; inline;
generic function SkipWhile<T>(AFunction: specialize TUnaryFunction<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function SkipWhile<T>(AFunction: specialize TConstUnaryFunction<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function SkipWhile<T>(AFunction: specialize TUnaryFunctionMethod<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function SkipWhile<T>(AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function SkipWhile<T>(AFunction: specialize TUnaryFunctionNested<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function SkipWhile<T>(AFunction: specialize TConstUnaryFunctionNested<Boolean, T>):
  specialize TIteratorCombinator<T, T>; overload; inline;
generic function SkipUntil<T>(const ASequence: specialize TArray<T>;
  AIncludeSequence: Boolean = False): specialize TIteratorCombinator<T, T>; overload; inline;
generic function SkipUntil<T>(const ASequence: array of T;
  AIncludeSequence: Boolean = False): specialize TIteratorCombinator<T, T>; overload; inline;
function SkipUntil(const ASequence: String; AIncludeSequence: Boolean = False):
  specialize TIteratorCombinator<Char, Char>; overload; inline;
}

// Expanding functions
generic function Expand<TSource, TTarget>(
  AExpandFunction: specialize TUnaryFunction<specialize IIterator<TTarget>, TSource>;
  const AIterator: specialize IIterator<TSource>
): specialize IIterator<TTarget>; overload; inline;
generic function Expand<TSource, TTarget>(
  AExpandFunction: specialize TConstUnaryFunction<specialize IIterator<TTarget>, TSource>;
  const AIterator: specialize IIterator<TSource>
): specialize IIterator<TTarget>; overload; inline;
generic function Expand<TSource, TTarget>(
  AExpandFunction: specialize TUnaryFunctionMethod<specialize IIterator<TTarget>, TSource>;
  const AIterator: specialize IIterator<TSource>
): specialize IIterator<TTarget>; overload; inline;
generic function Expand<TSource, TTarget>(
  AExpandFunction: specialize TConstUnaryFunctionMethod<specialize IIterator<TTarget>, TSource>;
  const AIterator: specialize IIterator<TSource>
): specialize IIterator<TTarget>; overload; inline;
generic function Expand<TSource, TTarget>(
  AExpandFunction: specialize TUnaryFunctionNested<specialize IIterator<TTarget>, TSource>;
  const AIterator: specialize IIterator<TSource>
): specialize IIterator<TTarget>; overload; inline;
generic function Expand<TSource, TTarget>(
  AExpandFunction: specialize TConstUnaryFunctionNested<specialize IIterator<TTarget>, TSource>;
  const AIterator: specialize IIterator<TSource>
): specialize IIterator<TTarget>; overload; inline;

{
generic function Expand<TSource, TTarget>(
    AExpandFunction: specialize TUnaryFunction<specialize IIterator<TTarget>, TSource>
  ): specialize TIteratorCombinator<TSource, TTarget>; overload; inline;
generic function Expand<TSource, TTarget>(
    AExpandFunction: specialize TConstUnaryFunction<specialize IIterator<TTarget>, TSource>
  ): specialize TIteratorCombinator<TSource, TTarget>; overload; inline;
generic function Expand<TSource, TTarget>(
    AExpandFunction: specialize TUnaryFunctionMethod<specialize IIterator<TTarget>, TSource>
  ): specialize TIteratorCombinator<TSource, TTarget>; overload; inline;
generic function Expand<TSource, TTarget>(
    AExpandFunction: specialize TConstUnaryFunctionMethod<specialize IIterator<TTarget>, TSource>
  ): specialize TIteratorCombinator<TSource, TTarget>; overload; inline;
generic function Expand<TSource, TTarget>(
    AExpandFunction: specialize TUnaryFunctionNested<specialize IIterator<TTarget>, TSource>
  ): specialize TIteratorCombinator<TSource, TTarget>; overload; inline;
generic function Expand<TSource, TTarget>(
    AExpandFunction: specialize TConstUnaryFunctionNested<specialize IIterator<TTarget>, TSource>
  ): specialize TIteratorCombinator<TSource, TTarget>; overload; inline;
}

// TODO: Add one type expand functions for implicit specialization?

generic function ExpandArrays<T>(const AIterator: specialize IIterator<specialize TArray<T>>): specialize IIterator<T>; overload; inline;
function ExpandStrings(const AIterator: specialize IIterator<String>): specialize IIterator<Char>; inline;

{
generic function ExpandArrays<T>: specialize TIteratorCombinator<specialize TArray<T>, T>; overload; inline;
function ExpandStrings: specialize TIteratorCombinator<String, Char>; inline;
}

// Typing functions
generic function Cast<TFrom, TTo>(const AIterator: specialize IIterator<TFrom>):
  specialize IIterator<TTo>; overload; inline;
generic function CastObject<TFrom, TTo: TObject>(const AIterator: specialize IIterator<TFrom>):
  specialize IIterator<TTo>; overload; inline;
generic function CastObject<TTo: TObject>(const AIterator: specialize IIterator<TObject>):
  specialize IIterator<TTo>; overload; inline;
generic function CastObject<TTo: TObject>(const AIterator: specialize IIterator<Pointer>):
  specialize IIterator<TTo>; overload; inline;
generic function FilterClass<TBaseClass, TFilterClass: TObject>(const AIterator: specialize IIterator<TBaseClass>):
  specialize IIterator<TFilterClass>; overload; inline;
generic function FilterClass<TFilterClass: TObject>(const AIterator: specialize IIterator<TObject>):
  specialize IIterator<TFilterClass>; overload; inline;
generic function ClassTypes<TBaseClass: TObject>(const AIterator: specialize IIterator<TBaseClass>):
  specialize IIterator<TClass>; overload; inline;
function ClassTypes(const AIterator: specialize IIterator<TObject>):
  specialize IIterator<TClass>; overload; inline;

{
generic function Cast<TFrom, TTo>: specialize TIteratorCombinator<TFrom, TTo>; overload; inline;
generic function CastObject<TFrom, TTo: TObject>: specialize TIteratorCombinator<TFrom, TTo>; overload; inline;
generic function CastObject<TTo: TObject>: specialize TIteratorCombinator<TObject, TTo>; overload; inline;
generic function CastObjectFromPointer<TTo: TObject>: specialize TIteratorCombinator<Pointer, TTo>; overload; inline;
generic function FilterClass<TBaseClass, TFilterClass: TObject>: specialize TIteratorCombinator<TBaseClass, TFilterClass>; overload; inline;
generic function FilterClass<TFilterClass: TObject>: specialize TIteratorCombinator<TObject, TFilterClass>; overload; inline;
generic function ClassTypes<TBaseClass: TObject>: specialize TIteratorCombinator<TBaseClass, TClass>; overload; inline;
function ClassTypes: specialize TIteratorCombinator<TObject, TClass>; overload; inline;
}

// Fold/Reduce
generic function FoldL<TResult, TData>(
  AFunction: specialize TBinaryFunction<TResult, TResult, TData>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult; overload; inline;
generic function FoldL<TResult, TData>(
  AFunction: specialize TConstBinaryFunction<TResult, TResult, TData>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult; overload; inline;
generic function FoldL<TResult, TData>(
  AFunction: specialize TBinaryFunctionMethod<TResult, TResult, TData>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult; overload; inline;
generic function FoldL<TResult, TData>(
  AFunction: specialize TConstBinaryFunctionMethod<TResult, TResult, TData>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult; overload; inline;
generic function FoldL<TResult, TData>(
  AFunction: specialize TBinaryFunctionNested<TResult, TResult, TData>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult; overload; inline;
generic function FoldL<TResult, TData>(
  AFunction: specialize TConstBinaryFunctionNested<TResult, TResult, TData>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult; overload; inline;

generic function FoldR<TResult, TData>(
  AFunction: specialize TBinaryFunction<TResult, TData, TResult>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult; overload; inline;
generic function FoldR<TResult, TData>(
  AFunction: specialize TConstBinaryFunction<TResult, TData, TResult>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult; overload; inline;
generic function FoldR<TResult, TData>(
  AFunction: specialize TBinaryFunctionMethod<TResult, TData, TResult>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult; overload; inline;
generic function FoldR<TResult, TData>(
  AFunction: specialize TConstBinaryFunctionMethod<TResult, TData, TResult>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult; overload; inline;
generic function FoldR<TResult, TData>(
  AFunction: specialize TBinaryFunctionNested<TResult, TData, TResult>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult; overload; inline;
generic function FoldR<TResult, TData>(
  AFunction: specialize TConstBinaryFunctionNested<TResult, TData, TResult>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult; overload; inline;

generic function Reduce<T>(AFunction: specialize TBinaryFunction<T, T, T>; const InitialData: T;
  const AIterator: specialize IIterator<T>): T; overload; inline;
generic function Reduce<T>(AFunction: specialize TConstBinaryFunction<T, T, T>; const InitialData: T;
  const AIterator: specialize IIterator<T>): T; overload; inline;
generic function Reduce<T>(AFunction: specialize TBinaryFunctionMethod<T, T, T>; const InitialData: T;
  const AIterator: specialize IIterator<T>): T; overload; inline;
generic function Reduce<T>(AFunction: specialize TConstBinaryFunctionMethod<T, T, T>; const InitialData: T;
  const AIterator: specialize IIterator<T>): T; overload; inline;
generic function Reduce<T>(AFunction: specialize TBinaryFunctionNested<T, T, T>; const InitialData: T;
  const AIterator: specialize IIterator<T>): T; overload; inline;
generic function Reduce<T>(AFunction: specialize TConstBinaryFunctionNested<T, T, T>; const InitialData: T;
  const AIterator: specialize IIterator<T>): T; overload; inline;

generic function Reduce<T>(AFunction: specialize TBinaryFunction<T, T, T>;
  const AIterator: specialize IIterator<T>): T; overload; inline;
generic function Reduce<T>(AFunction: specialize TConstBinaryFunction<T, T, T>;
  const AIterator: specialize IIterator<T>): T; overload; inline;
generic function Reduce<T>(AFunction: specialize TBinaryFunctionMethod<T, T, T>;
  const AIterator: specialize IIterator<T>): T; overload; inline;
generic function Reduce<T>(AFunction: specialize TConstBinaryFunctionMethod<T, T, T>;
  const AIterator: specialize IIterator<T>): T; overload; inline;
generic function Reduce<T>(AFunction: specialize TBinaryFunctionNested<T, T, T>;
  const AIterator: specialize IIterator<T>): T; overload; inline;
generic function Reduce<T>(AFunction: specialize TConstBinaryFunctionNested<T, T, T>;
  const AIterator: specialize IIterator<T>): T; overload; inline;

// special Reduce
generic function Sum<T>(AIterator: specialize IIterator<T>): T; overload; inline;
generic function Product<T>(AIterator: specialize IIterator<T>): T; overload; inline;
function Join(const Delimiter: String; const AIterator: specialize IIterator<String>; GeometricGrowth: Boolean = True): String; overload; inline;
function Join(const AIterator: specialize IIterator<Char>; GeometricGrowth: Boolean = True): String; overload; inline;
function Join(const AIterator: specialize IIterator<String>; GeometricGrowth: Boolean = True): String; overload; inline;

// Collect
generic function CollectArray<T>(const AIterator: specialize IIterator<T>; GeometricGrowth: Boolean = True): specialize TArray<T>; inline;
generic function Collect<T, TContainer>(const AIterator: specialize IIterator<T>): TContainer; overload; inline;
generic function Collect<T, TContainer>(const AIterator: specialize IIterator<T>; AContainer: TContainer): TContainer; overload; inline;

// Index
generic function Index<T>(AIterator: specialize IIterator<T>): specialize IIterator<specialize TPair<SizeInt, T>>; inline;

// Step
generic function Step<T>(StepSize: SizeInt; const AIterator: specialize IIterator<T>): specialize IIterator<T>; inline;

// Ordering
generic function Reverse<T>(const AIterator: specialize IIterator<T>): specialize IIterator<T>; inline;
// Sorting: Compare function
generic function Sorted<T>(AFunction: specialize TBinaryFunction<Integer, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AFunction: specialize TConstBinaryFunction<Integer, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AFunction: specialize TBinaryFunctionMethod<Integer, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AFunction: specialize TConstBinaryFunctionMethod<Integer, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AFunction: specialize TBinaryFunctionNested<Integer, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AFunction: specialize TConstBinaryFunctionNested<Integer, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
// Sorting: Less function
generic function Sorted<T>(AFunction: specialize TBinaryFunction<Boolean, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AFunction: specialize TConstBinaryFunction<Boolean, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AFunction: specialize TBinaryFunctionMethod<Boolean, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AFunction: specialize TConstBinaryFunctionMethod<Boolean, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AFunction: specialize TBinaryFunctionNested<Boolean, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;
generic function Sorted<T>(AFunction: specialize TConstBinaryFunctionNested<Boolean, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>; overload; inline;

// Get Next element from iterator
generic function Next<T>(out AValue: T; const AIterator: specialize IIterator<T>): Boolean; overload; inline;
generic function Next<T>(const AIterator: specialize IIterator<T>): T; overload; inline;
generic function NextOpt<T>(const AIterator: specialize IIterator<T>): specialize TNullable<T>; overload; inline;
// Get the Last element from iterator
generic function Last<T>(out AValue: T; const AIterator: specialize IIterator<T>): Boolean; overload; inline;
generic function Last<T>(const AIterator: specialize IIterator<T>): T; overload; inline;
generic function LastOpt<T>(const AIterator: specialize IIterator<T>): specialize TNullable<T>; overload; inline;

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

generic function IterateRange<T>(const AStart, AStop: T): specialize IIterator<T>;
begin
  Result := specialize TRangeIterator<T>.Create(AStart, AStop);
end;

generic function IterateRange<T>(const AStart, AStop, AStep: T): specialize IIterator<T>;
begin
  Result := specialize TStepRangeIterator<T>.Create(AStart, AStop, AStep);
end;

generic function Generate<T>(
    AFunction: specialize TFunction<specialize TNullable<T>>
  ): specialize IIterator<T>;
begin
  Result := specialize TGeneratorIterator<T>.Create(AFunction);
end;

generic function Generate<T>(
    AFunction: specialize TFunctionMethod<specialize TNullable<T>>
  ): specialize IIterator<T>;
begin
  Result := specialize TGeneratorIterator<T>.Create(AFunction);
end;

generic function Generate<T>(
    AFunction: specialize TFunctionNested<specialize TNullable<T>>
  ): specialize IIterator<T>;
begin
  Result := specialize TGeneratorIterator<T>.Create(AFunction);
end;

generic function GenerateInf<T>(AFunction: specialize TFunction<T>
  ): specialize IIterator<T>;
begin
  Result := specialize TInfiniteGeneratorIterator<T>.Create(AFunction);
end;

generic function GenerateInf<T>(AFunction: specialize TFunctionMethod<T>
  ): specialize IIterator<T>;
begin
  Result := specialize TInfiniteGeneratorIterator<T>.Create(AFunction);
end;

generic function GenerateInf<T>(AFunction: specialize TFunctionNested<T>
  ): specialize IIterator<T>;
begin
  Result := specialize TInfiniteGeneratorIterator<T>.Create(AFunction);
end;

{ Stream iterator }

generic function Iterate<T>(AStream: TStream; AOwnsStream: Boolean = True):
  specialize IIterator<T>;
begin
  Result := specialize TStreamIterator<T>.Create(AStream, AOwnsStream);
end;

generic function Iterate<T>(
  AFunction: specialize TUnaryFunction<specialize TNullable<T>, TStream>;
  AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<T>;
begin
  Result := specialize TCustomStreamIterator<T>.Create(AStream, AOwnsStream, AFunction);
end;

generic function Iterate<T>(
  AFunction: specialize TConstUnaryFunction<specialize TNullable<T>, TStream>;
  AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<T>;
begin
  Result := specialize TCustomStreamIterator<T>.Create(AStream, AOwnsStream, AFunction);
end;

generic function Iterate<T>(
  AFunction: specialize TUnaryFunctionMethod<specialize TNullable<T>, TStream>;
  AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<T>;
begin
  Result := specialize TCustomStreamIterator<T>.Create(AStream, AOwnsStream, AFunction);
end;

generic function Iterate<T>(
  AFunction: specialize TConstUnaryFunctionMethod<specialize TNullable<T>, TStream>;
  AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<T>;
begin
  Result := specialize TCustomStreamIterator<T>.Create(AStream, AOwnsStream, AFunction);
end;

generic function Iterate<T>(
  AFunction: specialize TUnaryFunctionNested<specialize TNullable<T>, TStream>;
  AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<T>;
begin
  Result := specialize TCustomStreamIterator<T>.Create(AStream, AOwnsStream, AFunction);
end;

generic function Iterate<T>(
  AFunction: specialize TConstUnaryFunctionNested<specialize TNullable<T>, TStream>;
  AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<T>;
begin
  Result := specialize TCustomStreamIterator<T>.Create(AStream, AOwnsStream, AFunction);
end;

function IterateLines(AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<String>;
begin
  Result := TLineStreamIterator.Create(AStream, AOwnsStream);
end;

function IterateUTF8(AStream: TStream; AOwnsStream: Boolean = True): specialize IIterator<String>;
begin
  Result := TUTF8StreamIterator.Create(AStream, AOwnsStream);
end;

{ Map Functions }
generic function Map<TFrom, TTo>(AFunction: specialize TUnaryFunction<TTo, TFrom>;
  const AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(AIterator, AFunction);
end;

generic function Map<TFrom, TTo>(AFunction: specialize TConstUnaryFunction<TTo, TFrom>;
  const AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(AIterator, AFunction);
end;

generic function Map<TFrom, TTo>(AFunction: specialize TUnaryFunctionMethod<TTo, TFrom>;
  const AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(AIterator, AFunction);
end;

generic function Map<TFrom, TTo>(AFunction: specialize TConstUnaryFunctionMethod<TTo, TFrom>;
  const AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(AIterator, AFunction);
end;

generic function Map<TFrom, TTo>(AFunction: specialize TUnaryFunctionNested<TTo, TFrom>;
  const AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(AIterator, AFunction);
end;

generic function Map<TFrom, TTo>(AFunction: specialize TConstUnaryFunctionNested<TTo, TFrom>;
  const AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(AIterator, AFunction);
end;

{
generic function Map<TFrom, TTo>(AFunction: specialize TUnaryFunction<TTo, TFrom>):
  specialize TIteratorCombinator<TTo, TFrom>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(nil, AFunction);
end;

generic function Map<TFrom, TTo>(AFunction: specialize TConstUnaryFunction<TTo, TFrom>):
  specialize TIteratorCombinator<TTo, TFrom>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(nil, AFunction);
end;

generic function Map<TFrom, TTo>(AFunction: specialize TUnaryFunctionMethod<TTo, TFrom>):
  specialize TIteratorCombinator<TTo, TFrom>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(nil, AFunction);
end;

generic function Map<TFrom, TTo>(AFunction: specialize TConstUnaryFunctionMethod<TTo, TFrom>):
  specialize TIteratorCombinator<TTo, TFrom>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(nil, AFunction);
end;

generic function Map<TFrom, TTo>(AFunction: specialize TUnaryFunctionNested<TTo, TFrom>):
  specialize TIteratorCombinator<TTo, TFrom>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(nil, AFunction);
end;

generic function Map<TFrom, TTo>(AFunction: specialize TConstUnaryFunctionNested<TTo, TFrom>):
  specialize TIteratorCombinator<TTo, TFrom>;
begin
  Result := specialize TMapIterator<TFrom, TTo>.Create(nil, AFunction);
end;
}

{ Filter Functions }

generic function Filter<T>(AFunction: specialize TUnaryFunction<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TFilterIterator<T>.Create(AIterator, AFunction);
end;

generic function Filter<T>(AFunction: specialize TConstUnaryFunction<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TFilterIterator<T>.Create(AIterator, AFunction);
end;

generic function Filter<T>(AFunction: specialize TUnaryFunctionMethod<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TFilterIterator<T>.Create(AIterator, AFunction);
end;

generic function Filter<T>(AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TFilterIterator<T>.Create(AIterator, AFunction);
end;

generic function Filter<T>(AFunction: specialize TUnaryFunctionNested<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TFilterIterator<T>.Create(AIterator, AFunction);
end;

generic function Filter<T>(AFunction: specialize TConstUnaryFunctionNested<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TFilterIterator<T>.Create(AIterator, AFunction);
end;
{
generic function Filter<T>(AFunction: specialize TUnaryFunction<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TFilterIterator<T>.Create(nil, AFunction);
end;

generic function Filter<T>(AFunction: specialize TConstUnaryFunction<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TFilterIterator<T>.Create(nil, AFunction);
end;

generic function Filter<T>(AFunction: specialize TUnaryFunctionMethod<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TFilterIterator<T>.Create(nil, AFunction);
end;

generic function Filter<T>(AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TFilterIterator<T>.Create(nil, AFunction);
end;

generic function Filter<T>(AFunction: specialize TUnaryFunctionNested<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TFilterIterator<T>.Create(nil, AFunction);
end;

generic function Filter<T>(AFunction: specialize TConstUnaryFunctionNested<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TFilterIterator<T>.Create(nil, AFunction);
end;
 } 
{ Take and TakeWhile Functions }

generic function Take<T>(ACount: SizeInt; const AIterator: specialize IIterator<T>):
  specialize IIterator<T>;
begin
  Result := specialize TTakeIterator<T>.Create(AIterator, ACount);
end;

generic function TakeWhile<T>(AFunction: specialize TUnaryFunction<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function TakeWhile<T>(AFunction: specialize TConstUnaryFunction<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function TakeWhile<T>(AFunction: specialize TUnaryFunctionMethod<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function TakeWhile<T>(AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function TakeWhile<T>(AFunction: specialize TUnaryFunctionNested<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function TakeWhile<T>(AFunction: specialize TConstUnaryFunctionNested<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function TakeUntil<T>(const ASequence: specialize TArray<T>;
  const AIterator: specialize IIterator<T>; AIncludeSequence: Boolean):
  specialize IIterator<T>;
begin
  Result := specialize TTakeUntilIterator<T>.Create(AIterator, ASequence, AIncludeSequence);
end;

generic function TakeUntil<T>(const ASequence: array of T;
  const AIterator: specialize IIterator<T>; AIncludeSequence: Boolean):
  specialize IIterator<T>;
begin
  Result := specialize TTakeUntilIterator<T>.Create(AIterator, ASequence, AIncludeSequence);
end;

function TakeUntil(const ASequence: String; const AIterator: specialize IIterator<Char>;
  AIncludeSequence: Boolean): specialize IIterator<Char
  >;
begin
  Result := TTakeUntilStringIterator.Create(AIterator, ASequence, AIncludeSequence);
end;
 {
generic function Take<T>(ACount: SizeInt): specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TTakeIterator<T>.Create(nil, ACount);
end;

generic function TakeWhile<T>(AFunction: specialize TUnaryFunction<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(nil, AFunction);
end;

generic function TakeWhile<T>(AFunction: specialize TConstUnaryFunction<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(nil, AFunction);
end;

generic function TakeWhile<T>(AFunction: specialize TUnaryFunctionMethod<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(nil, AFunction);
end;

generic function TakeWhile<T>(AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(nil, AFunction);
end;

generic function TakeWhile<T>(AFunction: specialize TUnaryFunctionNested<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(nil, AFunction);
end;

generic function TakeWhile<T>(AFunction: specialize TConstUnaryFunctionNested<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TTakeWhileIterator<T>.Create(nil, AFunction);
end;

generic function TakeUntil<T>(const ASequence: specialize TArray<T>;
  AIncludeSequence: Boolean = False): specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TTakeUntilIterator<T>.Create(nil, ASequence, AIncludeSequence);
end;

generic function TakeUntil<T>(const ASequence: array of T;
  AIncludeSequence: Boolean = False): specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TTakeUntilIterator<T>.Create(nil, ASequence, AIncludeSequence);
end;

function TakeUntil(const ASequence: String; AIncludeSequence: Boolean = False):
  specialize TIteratorCombinator<Char, Char>;
begin
  Result := TTakeUntilStringIterator.Create(nil, ASequence, AIncludeSequence);
end;
 }
{ Skip and SkipWhile Functions }

generic function Skip<T>(ACount: SizeInt; const AIterator: specialize IIterator<T>):
  specialize IIterator<T>;
begin
  Result := specialize TSkipIterator<T>.Create(AIterator, ACount);
end;

generic function SkipWhile<T>(AFunction: specialize TUnaryFunction<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function SkipWhile<T>(AFunction: specialize TConstUnaryFunction<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function SkipWhile<T>(AFunction: specialize TUnaryFunctionMethod<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function SkipWhile<T>(AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function SkipWhile<T>(AFunction: specialize TUnaryFunctionNested<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function SkipWhile<T>(AFunction: specialize TConstUnaryFunctionNested<Boolean, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(AIterator, AFunction);
end;

generic function SkipUntil<T>(const ASequence: specialize TArray<T>;
  const AIterator: specialize IIterator<T>; AIncludeSequence: Boolean):
  specialize IIterator<T>;
begin
  Result := specialize TSkipUntilIterator<T>.Create(AIterator, ASequence, AIncludeSequence);
end;

generic function SkipUntil<T>(const ASequence: array of T;
  const AIterator: specialize IIterator<T>; AIncludeSequence: Boolean):
  specialize IIterator<T>;
begin
  Result := specialize TSkipUntilIterator<T>.Create(AIterator, ASequence, AIncludeSequence);
end;

function SkipUntil(const ASequence: String; const AIterator: specialize IIterator<Char>;
  AIncludeSequence: Boolean): specialize IIterator<Char
  >;
begin
  Result := TSkipUntilStringIterator.Create(AIterator, ASequence, AIncludeSequence);
end;
{
generic function Skip<T>(ACount: SizeInt): specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TSkipIterator<T>.Create(nil, ACount);
end;

generic function SkipWhile<T>(AFunction: specialize TUnaryFunction<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(nil, AFunction);
end;

generic function SkipWhile<T>(AFunction: specialize TConstUnaryFunction<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(nil, AFunction);
end;

generic function SkipWhile<T>(AFunction: specialize TUnaryFunctionMethod<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(nil, AFunction);
end;

generic function SkipWhile<T>(AFunction: specialize TConstUnaryFunctionMethod<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(nil, AFunction);
end;

generic function SkipWhile<T>(AFunction: specialize TUnaryFunctionNested<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(nil, AFunction);
end;

generic function SkipWhile<T>(AFunction: specialize TConstUnaryFunctionNested<Boolean, T>):
  specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TSkipWhileIterator<T>.Create(nil, AFunction);
end;

generic function SkipUntil<T>(const ASequence: specialize TArray<T>;
  AIncludeSequence: Boolean = False): specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TSkipUntilIterator<T>.Create(nil, ASequence, AIncludeSequence);
end;

generic function SkipUntil<T>(const ASequence: array of T;
  AIncludeSequence: Boolean = False): specialize TIteratorCombinator<T, T>;
begin
  Result := specialize TSkipUntilIterator<T>.Create(nil, ASequence, AIncludeSequence);
end;

function SkipUntil(const ASequence: String; AIncludeSequence: Boolean = False):
  specialize TIteratorCombinator<Char, Char>;
begin
  Result := TSkipUntilStringIterator.Create(nil, ASequence, AIncludeSequence);
end;
 }
{ Expand Functions }

generic function Expand<TSource, TTarget>(
  AExpandFunction: specialize TUnaryFunction<specialize IIterator<TTarget>, TSource>;
  const AIterator: specialize IIterator<TSource>): specialize IIterator<TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(AIterator, AExpandFunction);
end;

generic function Expand<TSource, TTarget>(
  AExpandFunction: specialize TConstUnaryFunction<specialize IIterator<TTarget>, TSource>;
  const AIterator: specialize IIterator<TSource>): specialize IIterator<TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(AIterator, AExpandFunction);
end;

generic function Expand<TSource, TTarget>(
  AExpandFunction: specialize TUnaryFunctionMethod<specialize IIterator<TTarget>, TSource>;
  const AIterator: specialize IIterator<TSource>): specialize IIterator<TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(AIterator, AExpandFunction);
end;

generic function Expand<TSource, TTarget>(
  AExpandFunction: specialize TConstUnaryFunctionMethod<specialize IIterator<TTarget>, TSource>;
  const AIterator: specialize IIterator<TSource>): specialize IIterator<TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(AIterator, AExpandFunction);
end;

generic function Expand<TSource, TTarget>(
  AExpandFunction: specialize TUnaryFunctionNested<specialize IIterator<TTarget>, TSource>;
  const AIterator: specialize IIterator<TSource>): specialize IIterator<TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(AIterator, AExpandFunction);
end;

generic function Expand<TSource, TTarget>(
  AExpandFunction: specialize TConstUnaryFunctionNested<specialize IIterator<TTarget>, TSource>;
  const AIterator: specialize IIterator<TSource>): specialize IIterator<TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(AIterator, AExpandFunction);
end;
 {
generic function Expand<TSource, TTarget>(
    AExpandFunction: specialize TUnaryFunction<specialize IIterator<TTarget>, TSource>
  ): specialize TIteratorCombinator<TSource, TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(nil, AExpandFunction);
end;

generic function Expand<TSource, TTarget>(
    AExpandFunction: specialize TConstUnaryFunction<specialize IIterator<TTarget>, TSource>
  ): specialize TIteratorCombinator<TSource, TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(nil, AExpandFunction);
end;

generic function Expand<TSource, TTarget>(
    AExpandFunction: specialize TUnaryFunctionMethod<specialize IIterator<TTarget>, TSource>
  ): specialize TIteratorCombinator<TSource, TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(nil, AExpandFunction);
end;

generic function Expand<TSource, TTarget>(
    AExpandFunction: specialize TConstUnaryFunctionMethod<specialize IIterator<TTarget>, TSource>
  ): specialize TIteratorCombinator<TSource, TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(nil, AExpandFunction);
end;

generic function Expand<TSource, TTarget>(
    AExpandFunction: specialize TUnaryFunctionNested<specialize IIterator<TTarget>, TSource>
  ): specialize TIteratorCombinator<TSource, TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(nil, AExpandFunction);
end;

generic function Expand<TSource, TTarget>(
    AExpandFunction: specialize TConstUnaryFunctionNested<specialize IIterator<TTarget>, TSource>
  ): specialize TIteratorCombinator<TSource, TTarget>;
begin
  Result := specialize TExpandIterator<TSource, TTarget>.Create(nil, AExpandFunction);
end;
 }
generic function ExpandArrays<T>(const AIterator: specialize IIterator<specialize TArray<T>>): specialize IIterator<T>;
begin
  Result := specialize TArrayExpandIterator<T>.Create(AIterator);
end;

function ExpandStrings(const AIterator: specialize IIterator<String>): specialize IIterator<Char>;
begin
  Result := TExpandStringIterator.Create(AIterator);
end;
 {
generic function ExpandArrays<T>: specialize TIteratorCombinator<specialize TArray<T>, T>;
begin
  Result := specialize TArrayExpandIterator<T>.Create(nil);
end;

function ExpandStrings: specialize TIteratorCombinator<String, Char>;
begin
  Result := specialize TIteratorCombinator<String, Char>(TExpandStringIterator.Create(nil));
end;
 }
{ Typing functions }

generic function Cast<TFrom, TTo>(const AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TCastIterator<TFrom, TTo>.Create(AIterator);
end;

generic function CastObject<TFrom, TTo>(const AIterator: specialize IIterator<TFrom>): specialize IIterator<TTo>;
begin
  Result := specialize TCastObjectIterator<TFrom, TTo>.Create(AIterator);
end;

generic function CastObject<TTo>(const AIterator: specialize IIterator<TObject>): specialize IIterator<TTo>;
begin
  Result := specialize TCastObjectIterator<TObject, TTo>.Create(AIterator);
end;

generic function CastObject<TTo>(const AIterator: specialize IIterator<Pointer>): specialize IIterator<TTo>;
begin
  Result := specialize TCastPointerObjectIterator<TTo>.Create(AIterator);
end;

generic function FilterClass<TBaseClass, TFilterClass>(const AIterator: specialize IIterator<TBaseClass>): specialize IIterator<TFilterClass>;
begin
  Result := specialize TFilterTypeIterator<TBaseClass, TFilterClass>.Create(AIterator);
end; 

generic function FilterClass<TFilterClass>(const AIterator: specialize IIterator<TObject>): specialize IIterator<TFilterClass>;
begin
  Result := specialize TFilterTypeIterator<TObject, TFilterClass>.Create(AIterator);
end;

generic function ClassTypes<TBaseClass>(const AIterator: specialize IIterator<TBaseClass>): specialize IIterator<TClass>;
begin
  Result := specialize TClassTypesIterator<TBaseClass>.Create(AIterator);
end;

function ClassTypes(const AIterator: specialize IIterator<TObject>): specialize IIterator<TClass>;
begin
  Result := specialize TClassTypesIterator<TObject>.Create(AIterator);
end;
 {
generic function Cast<TFrom, TTo>: specialize TIteratorCombinator<TFrom, TTo>;
begin
  Result := specialize TCastIterator<TFrom, TTo>.Create(nil);
end;

generic function CastObject<TFrom, TTo>: specialize TIteratorCombinator<TFrom, TTo>;
begin
  Result := specialize TCastObjectIterator<TFrom, TTo>.Create(nil);
end;

generic function CastObject<TTo>: specialize TIteratorCombinator<TObject, TTo>;
begin
  Result := specialize TCastObjectIterator<TObject, TTo>.Create(nil);
end;

generic function CastObjectFromPointer<TTo>: specialize TIteratorCombinator<Pointer, TTo>;
begin
  Result := specialize TIteratorCombinator<Pointer, TTo>(specialize TCastPointerObjectIterator<TTo>.Create(nil));
end;

generic function FilterClass<TBaseClass, TFilterClass>: specialize TIteratorCombinator<TBaseClass, TFilterClass>;
begin
  Result := specialize TFilterTypeIterator<TBaseClass, TFilterClass>.Create(nil);
end;

generic function FilterClass<TFilterClass>: specialize TIteratorCombinator<TObject, TFilterClass>;
begin
  Result := specialize TFilterTypeIterator<TObject, TFilterClass>.Create(nil);
end;

generic function ClassTypes<TBaseClass>: specialize TIteratorCombinator<TBaseClass, TClass>;
begin
  Result := specialize TIteratorCombinator<TBaseClass, TClass>(specialize TClassTypesIterator<TBaseClass>.Create(nil));
end;

function ClassTypes: specialize TIteratorCombinator<TObject, TClass>;
begin
  Result := specialize TIteratorCombinator<TObject, TClass>(specialize TClassTypesIterator<TObject>.Create(nil));
end;
 }
{ Fold/Reduce }

// FOLDL

generic function FoldL<TResult, TData>(
  AFunction: specialize TBinaryFunction<TResult, TResult, TData>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult;
begin
  Result := specialize FoldLCollect<TResult, TData>(AIterator, 
  AFunction, InitialData);
end;

generic function FoldL<TResult, TData>(
  AFunction: specialize TConstBinaryFunction<TResult, TResult, TData>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult;
begin
  Result := specialize FoldLCollect<TResult, TData>(AIterator, 
  AFunction, InitialData);
end;

generic function FoldL<TResult, TData>(
  AFunction: specialize TBinaryFunctionMethod<TResult, TResult, TData>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult;
begin
  Result := specialize FoldLCollect<TResult, TData>(AIterator, 
  AFunction, InitialData);
end;

generic function FoldL<TResult, TData>(
  AFunction: specialize TConstBinaryFunctionMethod<TResult, TResult, TData>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult;
begin
  Result := specialize FoldLCollect<TResult, TData>(AIterator, 
  AFunction, InitialData);
end;

generic function FoldL<TResult, TData>(
  AFunction: specialize TBinaryFunctionNested<TResult, TResult, TData>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult;
begin
  Result := specialize FoldLCollect<TResult, TData>(AIterator, 
  AFunction, InitialData);
end;

generic function FoldL<TResult, TData>(
  AFunction: specialize TConstBinaryFunctionNested<TResult, TResult, TData>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult;
begin
  Result := specialize FoldLCollect<TResult, TData>(AIterator, 
  AFunction, InitialData);
end;

// FoldR

generic function FoldR<TResult, TData>(
  AFunction: specialize TBinaryFunction<TResult, TData, TResult>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult;
begin
  Result := specialize FoldRCollect<TResult, TData>(AIterator, 
  AFunction, InitialData);
end;

generic function FoldR<TResult, TData>(
  AFunction: specialize TConstBinaryFunction<TResult, TData, TResult>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult;
begin
  Result := specialize FoldRCollect<TResult, TData>(AIterator, 
  AFunction, InitialData);
end;

generic function FoldR<TResult, TData>(
  AFunction: specialize TBinaryFunctionMethod<TResult, TData, TResult>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult;
begin
  Result := specialize FoldRCollect<TResult, TData>(AIterator, 
  AFunction, InitialData);
end;

generic function FoldR<TResult, TData>(
  AFunction: specialize TConstBinaryFunctionMethod<TResult, TData, TResult>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult;
begin
  Result := specialize FoldRCollect<TResult, TData>(AIterator, 
  AFunction, InitialData);
end;

generic function FoldR<TResult, TData>(
  AFunction: specialize TBinaryFunctionNested<TResult, TData, TResult>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult;
begin
  Result := specialize FoldRCollect<TResult, TData>(AIterator, 
  AFunction, InitialData);
end;

generic function FoldR<TResult, TData>(
  AFunction: specialize TConstBinaryFunctionNested<TResult, TData, TResult>; const InitialData: TResult;
  const AIterator: specialize IIterator<TData>): TResult;
begin
  Result := specialize FoldRCollect<TResult, TData>(AIterator, 
  AFunction, InitialData);
end;

// Reduce InitialData

generic function Reduce<T>(
  AFunction: specialize TBinaryFunction<T, T, T>; const InitialData: T;
  const AIterator: specialize IIterator<T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, 
  AFunction, InitialData);
end;

generic function Reduce<T>(
  AFunction: specialize TConstBinaryFunction<T, T, T>; const InitialData: T;
  const AIterator: specialize IIterator<T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, 
  AFunction, InitialData);
end;

generic function Reduce<T>(
  AFunction: specialize TBinaryFunctionMethod<T, T, T>; const InitialData: T;
  const AIterator: specialize IIterator<T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, 
  AFunction, InitialData);
end;

generic function Reduce<T>(
  AFunction: specialize TConstBinaryFunctionMethod<T, T, T>; const InitialData: T;
  const AIterator: specialize IIterator<T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, 
  AFunction, InitialData);
end;

generic function Reduce<T>(
  AFunction: specialize TBinaryFunctionNested<T, T, T>; const InitialData: T;
  const AIterator: specialize IIterator<T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, 
  AFunction, InitialData);
end;

generic function Reduce<T>(
  AFunction: specialize TConstBinaryFunctionNested<T, T, T>; const InitialData: T;
  const AIterator: specialize IIterator<T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, 
  AFunction, InitialData);
end;

// Reduce Default

generic function Reduce<T>(
  AFunction: specialize TBinaryFunction<T, T, T>;
  const AIterator: specialize IIterator<T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, 
  AFunction, Default(T));
end;

generic function Reduce<T>(
  AFunction: specialize TConstBinaryFunction<T, T, T>;
  const AIterator: specialize IIterator<T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, 
  AFunction, Default(T));
end;

generic function Reduce<T>(
  AFunction: specialize TBinaryFunctionMethod<T, T, T>;
  const AIterator: specialize IIterator<T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, 
  AFunction, Default(T));
end;

generic function Reduce<T>(
  AFunction: specialize TConstBinaryFunctionMethod<T, T, T>;
  const AIterator: specialize IIterator<T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, 
  AFunction, Default(T));
end;

generic function Reduce<T>(
  AFunction: specialize TBinaryFunctionNested<T, T, T>;
  const AIterator: specialize IIterator<T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, 
  AFunction, Default(T));
end;

generic function Reduce<T>(
  AFunction: specialize TConstBinaryFunctionNested<T, T, T>;
  const AIterator: specialize IIterator<T>): T;
begin
  Result := specialize FoldLCollect<T, T>(AIterator, 
  AFunction, Default(T));
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

function Join(const Delimiter: String; const AIterator: specialize IIterator<String>; GeometricGrowth: Boolean): String;
begin
  if GeometricGrowth then
    Result := JoinCollectGeometric(AIterator, Delimiter)
  else
    Result := JoinCollectLinear(AIterator, Delimiter);
end; 

function Join(const AIterator: specialize IIterator<Char>; GeometricGrowth: Boolean): String;
begin
  if GeometricGrowth then
    Result := CollectStringGeometric(AIterator)
  else
    Result := CollectStringLinear(AIterator);
end;  

function Join(const AIterator: specialize IIterator<String>; GeometricGrowth: Boolean): String;
begin
  if GeometricGrowth then
    Result := CollectStringGeometric(AIterator)
  else
    Result := CollectStringLinear(AIterator);
end;

{ Collectors }

generic function CollectArray<T>(const AIterator: specialize IIterator<T>; GeometricGrowth: Boolean = True): specialize TArray<T>;
begin
  if GeometricGrowth then
    Result := specialize CollectArrayGeometric<T>(AIterator)
  else 
    Result := specialize CollectArrayLinear<T>(AIterator);
end;

generic function Collect<T, TContainer>(const AIterator: specialize IIterator<T>): TContainer;
begin
  Result := specialize CollectContainerAdd<T, TContainer>(AIterator);
end;

generic function Collect<T, TContainer>(const AIterator: specialize IIterator<T>; AContainer: TContainer): TContainer;
begin
  Result := specialize CollectContainerAdd<T, TContainer>(AIterator, AContainer);
end;

{ Index }

generic function Index<T>(const AIterator: specialize IIterator<T>): specialize IIterator<specialize TPair<SizeInt, T>>;
begin
  Result := specialize TIndexIterator<T>.Create(AIterator);
end;

{ Step }
generic function Step<T>(StepSize: SizeInt; const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TStepIterator<T>.Create(AIterator, StepSize);
end;

{ Ordering }
generic function Reverse<T>(const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TReverseIterator<T>.Create(AIterator);
end;

generic function Sorted<T>(AFunction: specialize TBinaryFunction<Integer, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AFunction: specialize TConstBinaryFunction<Integer, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AFunction: specialize TBinaryFunctionMethod<Integer, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AFunction: specialize TConstBinaryFunctionMethod<Integer, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AFunction: specialize TBinaryFunctionNested<Integer, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AFunction: specialize TConstBinaryFunctionNested<Integer, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

// Sorting: Less function

generic function Sorted<T>(AFunction: specialize TBinaryFunction<Boolean, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AFunction: specialize TConstBinaryFunction<Boolean, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AFunction: specialize TBinaryFunctionMethod<Boolean, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AFunction: specialize TConstBinaryFunctionMethod<Boolean, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AFunction: specialize TBinaryFunctionNested<Boolean, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

generic function Sorted<T>(AFunction: specialize TConstBinaryFunctionNested<Boolean, T, T>;
  const AIterator: specialize IIterator<T>): specialize IIterator<T>;
begin
  Result := specialize TSortingIterator<T>.Create(AIterator, AFunction);
end;

{ Next/Last Functions }

generic function Next<T>(out AValue: T; const AIterator: specialize IIterator<T>): Boolean;
begin
  Result := AIterator.MoveNext;
  if Result then
    AValue := AIterator.Current;
end;

generic function Next<T>(const AIterator: specialize IIterator<T>): T;
begin
  if not specialize Next<T>(Result, AIterator) then
    raise EEndOfIterator.Create('Iterator has no next element');
end;

generic function NextOpt<T>(const AIterator: specialize IIterator<T>): specialize TNullable<T>;
begin
  Result.Clear;
  if AIterator.MoveNext then
    Result := AIterator.Current;
end;

generic function Last<T>(out AValue: T; const AIterator: specialize IIterator<T>): Boolean;
begin
  Result := AIterator.MoveNext;
  if Result then repeat
    AValue := AIterator.Current;
  until not AIterator.MoveNext;
end;

generic function Last<T>(const AIterator: specialize IIterator<T>): T;
begin
  if not specialize Last<T>(Result, AIterator) then
    raise EEndOfIterator.Create('Iterator has no next element');
end;

generic function LastOpt<T>(const AIterator: specialize IIterator<T>): specialize TNullable<T>;
begin
  Result.Clear;
  While AIterator.MoveNext do
    Result := AIterator.Current;
end;

end.

