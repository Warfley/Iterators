unit FuncTypes;

{$Mode ObjFPC}{$H+}
{$ModeSwitch AdvancedRecords}
{$ModeSwitch NestedProcvars}

interface

type
  { Function Types }
  TFunctionType = (ftFunction, ftConstFunction, ftFunctionMethod, ftConstFunctionMethod, ftFunctionNested, ftConstFunctionNested);

  generic TFunction<TResult> = function(): TResult;
  generic TFunctionMethod<TResult> = function(): TResult of object;
  generic TFunctionNested<TResult> = function(): TResult is nested;

  generic TAnyFunction<TResult> = record
  public type
    TMyType = specialize TAnyFunction<TResult>;
    TMyFunction = specialize TFunction<TResult>;
    TMyFunctionMethod = specialize TFunctionMethod<TResult>;
    TMyFunctionNested = specialize TFunctionNested<TResult>;

  public
    class operator :=(AFunc: TMyFunction): TMyType; inline; overload;
    class operator :=(AFunc: TMyFunctionMethod): TMyType; inline; overload;
    class operator :=(AFunc: TMyFunctionNested): TMyType; inline; overload;

  public
    function apply(): TResult; inline;

  private
    case FunctionType: TFunctionType of
      ftFunction: (FFunction: TMyFunction);
      ftFunctionMethod: (FFunctionMethod: TMyFunctionMethod);
      ftFunctionNested: (FFunctionNested: TMyFunctionNested);
  end;

  generic TUnaryFunction<TResult, TParam1> = function(Param1: TParam1): TResult;
  generic TConstUnaryFunction<TResult, TParam1> = function(const Param1: TParam1): TResult;
  generic TUnaryFunctionMethod<TResult, TParam1> = function(Param1: TParam1): TResult of object;
  generic TConstUnaryFunctionMethod<TResult, TParam1> = function(const Param1: TParam1): TResult of object;
  generic TUnaryFunctionNested<TResult, TParam1> = function(Param1: TParam1): TResult is nested;
  generic TConstUnaryFunctionNested<TResult, TParam1> = function(const Param1: TParam1): TResult is nested;

  generic TAnyUnaryFunction<TResult, TParam1> = record
  public type
    TMyType = specialize TAnyUnaryFunction<TResult, TParam1>;
    TMyUnaryFunction = specialize TUnaryFunction<TResult, TParam1>;
    TMyConstUnaryFunction = specialize TConstUnaryFunction<TResult, TParam1>;
    TMyUnaryFunctionMethod = specialize TUnaryFunctionMethod<TResult, TParam1>;
    TMyConstUnaryFunctionMethod = specialize TConstUnaryFunctionMethod<TResult, TParam1>;
    TMyUnaryFunctionNested = specialize TUnaryFunctionNested<TResult, TParam1>;
    TMyConstUnaryFunctionNested = specialize TConstUnaryFunctionNested<TResult, TParam1>;

  public
    class operator :=(AFunc: TMyUnaryFunction): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstUnaryFunction): TMyType; inline; overload;
    class operator :=(AFunc: TMyUnaryFunctionMethod): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstUnaryFunctionMethod): TMyType; inline; overload;
    class operator :=(AFunc: TMyUnaryFunctionNested): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstUnaryFunctionNested): TMyType; inline; overload;

  public
    function apply(Param1: TParam1): TResult; inline;

  private
    case FunctionType: TFunctionType of
      ftFunction: (FFunction: TMyUnaryFunction);
      ftConstFunction: (FConstFunction: TMyConstUnaryFunction);
      ftFunctionMethod: (FFunctionMethod: TMyUnaryFunctionMethod);
      ftConstFunctionMethod: (FConstFunctionMethod: TMyConstUnaryFunctionMethod);
      ftFunctionNested: (FFunctionNested: TMyUnaryFunctionNested);
      ftConstFunctionNested: (FConstFunctionNested: TMyConstUnaryFunctionNested);
  end;

  generic TBinaryFunction<TResult, TParam1, TParam2> = function(Param1: TParam1; Param2: TParam2): TResult;
  generic TConstBinaryFunction<TResult, TParam1, TParam2> = function(const Param1: TParam1; const Param2: TParam2): TResult;
  generic TBinaryFunctionMethod<TResult, TParam1, TParam2> = function(Param1: TParam1; Param2: TParam2): TResult of object;
  generic TConstBinaryFunctionMethod<TResult, TParam1, TParam2> = function(const Param1: TParam1; const Param2: TParam2): TResult of object;
  generic TBinaryFunctionNested<TResult, TParam1, TParam2> = function(Param1: TParam1; Param2: TParam2): TResult is nested;
  generic TConstBinaryFunctionNested<TResult, TParam1, TParam2> = function(const Param1: TParam1; const Param2: TParam2): TResult is nested;

  generic TAnyBinaryFunction<TResult, TParam1, TParam2> = record
  public type
    TMyType = specialize TAnyBinaryFunction<TResult, TParam1, TParam2>;
    TMyBinaryFunction = specialize TBinaryFunction<TResult, TParam1, TParam2>;
    TMyConstBinaryFunction = specialize TConstBinaryFunction<TResult, TParam1, TParam2>;
    TMyBinaryFunctionMethod = specialize TBinaryFunctionMethod<TResult, TParam1, TParam2>;
    TMyConstBinaryFunctionMethod = specialize TConstBinaryFunctionMethod<TResult, TParam1, TParam2>;
    TMyBinaryFunctionNested = specialize TBinaryFunctionNested<TResult, TParam1, TParam2>;
    TMyConstBinaryFunctionNested = specialize TConstBinaryFunctionNested<TResult, TParam1, TParam2>;

  public
    class operator :=(AFunc: TMyBinaryFunction): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstBinaryFunction): TMyType; inline; overload;
    class operator :=(AFunc: TMyBinaryFunctionMethod): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstBinaryFunctionMethod): TMyType; inline; overload;
    class operator :=(AFunc: TMyBinaryFunctionNested): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstBinaryFunctionNested): TMyType; inline; overload;

  public
    function apply(Param1: TParam1; Param2: TParam2): TResult; inline;

  private
    case FunctionType: TFunctionType of
      ftFunction: (FFunction: TMyBinaryFunction);
      ftConstFunction: (FConstFunction: TMyConstBinaryFunction);
      ftFunctionMethod: (FFunctionMethod: TMyBinaryFunctionMethod);
      ftConstFunctionMethod: (FConstFunctionMethod: TMyConstBinaryFunctionMethod);
      ftFunctionNested: (FFunctionNested: TMyBinaryFunctionNested);
      ftConstFunctionNested: (FConstFunctionNested: TMyConstBinaryFunctionNested);
  end;

  generic TTernaryFunction<TResult, TParam1, TParam2, TParam3> = function(Param1: TParam1; Param2: TParam2; Param3: TParam3): TResult;
  generic TConstTernaryFunction<TResult, TParam1, TParam2, TParam3> = function(const Param1: TParam1; const Param2: TParam2; const Param3: TParam3): TResult;
  generic TTernaryFunctionMethod<TResult, TParam1, TParam2, TParam3> = function(Param1: TParam1; Param2: TParam2; Param3: TParam3): TResult of object;
  generic TConstTernaryFunctionMethod<TResult, TParam1, TParam2, TParam3> = function(const Param1: TParam1; const Param2: TParam2; const Param3: TParam3): TResult of object;
  generic TTernaryFunctionNested<TResult, TParam1, TParam2, TParam3> = function(Param1: TParam1; Param2: TParam2; Param3: TParam3): TResult is nested;
  generic TConstTernaryFunctionNested<TResult, TParam1, TParam2, TParam3> = function(const Param1: TParam1; const Param2: TParam2; const Param3: TParam3): TResult is nested;

  generic TAnyTernaryFunction<TResult, TParam1, TParam2, TParam3> = record
  public type
    TMyType = specialize TAnyTernaryFunction<TResult, TParam1, TParam2, TParam3>;
    TMyTernaryFunction = specialize TTernaryFunction<TResult, TParam1, TParam2, TParam3>;
    TMyConstTernaryFunction = specialize TConstTernaryFunction<TResult, TParam1, TParam2, TParam3>;
    TMyTernaryFunctionMethod = specialize TTernaryFunctionMethod<TResult, TParam1, TParam2, TParam3>;
    TMyConstTernaryFunctionMethod = specialize TConstTernaryFunctionMethod<TResult, TParam1, TParam2, TParam3>;
    TMyTernaryFunctionNested = specialize TTernaryFunctionNested<TResult, TParam1, TParam2, TParam3>;
    TMyConstTernaryFunctionNested = specialize TConstTernaryFunctionNested<TResult, TParam1, TParam2, TParam3>;

  public
    class operator :=(AFunc: TMyTernaryFunction): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstTernaryFunction): TMyType; inline; overload;
    class operator :=(AFunc: TMyTernaryFunctionMethod): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstTernaryFunctionMethod): TMyType; inline; overload;
    class operator :=(AFunc: TMyTernaryFunctionNested): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstTernaryFunctionNested): TMyType; inline; overload;

  public
    function apply(Param1: TParam1; Param2: TParam2; Param3: TParam3): TResult; inline;

  private
    case FunctionType: TFunctionType of
      ftFunction: (FFunction: TMyTernaryFunction);
      ftConstFunction: (FConstFunction: TMyConstTernaryFunction);
      ftFunctionMethod: (FFunctionMethod: TMyTernaryFunctionMethod);
      ftConstFunctionMethod: (FConstFunctionMethod: TMyConstTernaryFunctionMethod);
      ftFunctionNested: (FFunctionNested: TMyTernaryFunctionNested);
      ftConstFunctionNested: (FConstFunctionNested: TMyConstTernaryFunctionNested);
  end;

  { Procedure Types }
  TProcedureType = (ptProcedure, ptConstProcedure, ptProcedureMethod, ptConstProcedureMethod, ptProcedureNested, ptConstProcedureNested);

  TProcedure = procedure();
  TProcedureMethod = procedure() of object;
  TProcedureNested = procedure() is nested;

  TAnyProcedure = record

  public
    class operator :=(AFunc: TProcedure): TAnyProcedure; inline; overload;
    class operator :=(AFunc: TProcedureMethod): TAnyProcedure; inline; overload;
    class operator :=(AFunc: TProcedureNested): TAnyProcedure; inline; overload;

  public
    procedure apply(); inline;

  private
    case ProcedureType: TProcedureType of
      ptProcedure: (FProcedure: TProcedure);
      ptProcedureMethod: (FProcedureMethod: TProcedureMethod);
      ptProcedureNested: (FProcedureNested: TProcedureNested);
  end;

  generic TUnaryProcedure<TParam1> = procedure(Param1: TParam1);
  generic TConstUnaryProcedure<TParam1> = procedure(const Param1: TParam1);
  generic TUnaryProcedureMethod<TParam1> = procedure(Param1: TParam1) of object;
  generic TConstUnaryProcedureMethod<TParam1> = procedure(const Param1: TParam1) of object;
  generic TUnaryProcedureNested<TParam1> = procedure(Param1: TParam1) is nested;
  generic TConstUnaryProcedureNested<TParam1> = procedure(const Param1: TParam1) is nested;

  generic TAnyUnaryProcedure<TParam1> = record
  public type
    TMyType = specialize TAnyUnaryProcedure<TParam1>;
    TMyUnaryProcedure = specialize TUnaryProcedure<TParam1>;
    TMyConstUnaryProcedure = specialize TConstUnaryProcedure<TParam1>;
    TMyUnaryProcedureMethod = specialize TUnaryProcedureMethod<TParam1>;
    TMyConstUnaryProcedureMethod = specialize TConstUnaryProcedureMethod<TParam1>;
    TMyUnaryProcedureNested = specialize TUnaryProcedureNested<TParam1>;
    TMyConstUnaryProcedureNested = specialize TConstUnaryProcedureNested<TParam1>;

  public
    class operator :=(AFunc: TMyUnaryProcedure): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstUnaryProcedure): TMyType; inline; overload;
    class operator :=(AFunc: TMyUnaryProcedureMethod): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstUnaryProcedureMethod): TMyType; inline; overload;
    class operator :=(AFunc: TMyUnaryProcedureNested): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstUnaryProcedureNested): TMyType; inline; overload;

  public
    procedure apply(Param1: TParam1); inline;

  private
    case ProcedureType: TProcedureType of
      ptProcedure: (FProcedure: TMyUnaryProcedure);
      ptConstProcedure: (FConstProcedure: TMyConstUnaryProcedure);
      ptProcedureMethod: (FProcedureMethod: TMyUnaryProcedureMethod);
      ptConstProcedureMethod: (FConstProcedureMethod: TMyConstUnaryProcedureMethod);
      ptProcedureNested: (FProcedureNested: TMyUnaryProcedureNested);
      ptConstProcedureNested: (FConstProcedureNested: TMyConstUnaryProcedureNested);
  end;

  generic TBinaryProcedure<TParam1, TParam2> = procedure(Param1: TParam1; Param2: TParam2);
  generic TConstBinaryProcedure<TParam1, TParam2> = procedure(const Param1: TParam1; const Param2: TParam2);
  generic TBinaryProcedureMethod<TParam1, TParam2> = procedure(Param1: TParam1; Param2: TParam2) of object;
  generic TConstBinaryProcedureMethod<TParam1, TParam2> = procedure(const Param1: TParam1; const Param2: TParam2) of object;
  generic TBinaryProcedureNested<TParam1, TParam2> = procedure(Param1: TParam1; Param2: TParam2) is nested;
  generic TConstBinaryProcedureNested<TParam1, TParam2> = procedure(const Param1: TParam1; const Param2: TParam2) is nested;

  generic TAnyBinaryProcedure<TParam1, TParam2> = record
  public type
    TMyType = specialize TAnyBinaryProcedure<TParam1, TParam2>;
    TMyBinaryProcedure = specialize TBinaryProcedure<TParam1, TParam2>;
    TMyConstBinaryProcedure = specialize TConstBinaryProcedure<TParam1, TParam2>;
    TMyBinaryProcedureMethod = specialize TBinaryProcedureMethod<TParam1, TParam2>;
    TMyConstBinaryProcedureMethod = specialize TConstBinaryProcedureMethod<TParam1, TParam2>;
    TMyBinaryProcedureNested = specialize TBinaryProcedureNested<TParam1, TParam2>;
    TMyConstBinaryProcedureNested = specialize TConstBinaryProcedureNested<TParam1, TParam2>;

  public
    class operator :=(AFunc: TMyBinaryProcedure): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstBinaryProcedure): TMyType; inline; overload;
    class operator :=(AFunc: TMyBinaryProcedureMethod): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstBinaryProcedureMethod): TMyType; inline; overload;
    class operator :=(AFunc: TMyBinaryProcedureNested): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstBinaryProcedureNested): TMyType; inline; overload;

  public
    procedure apply(Param1: TParam1; Param2: TParam2); inline;

  private
    case ProcedureType: TProcedureType of
      ptProcedure: (FProcedure: TMyBinaryProcedure);
      ptConstProcedure: (FConstProcedure: TMyConstBinaryProcedure);
      ptProcedureMethod: (FProcedureMethod: TMyBinaryProcedureMethod);
      ptConstProcedureMethod: (FConstProcedureMethod: TMyConstBinaryProcedureMethod);
      ptProcedureNested: (FProcedureNested: TMyBinaryProcedureNested);
      ptConstProcedureNested: (FConstProcedureNested: TMyConstBinaryProcedureNested);
  end;

  generic TTernaryProcedure<TParam1, TParam2, TParam3> = procedure(Param1: TParam1; Param2: TParam2; Param3: TParam3);
  generic TConstTernaryProcedure<TParam1, TParam2, TParam3> = procedure(const Param1: TParam1; const Param2: TParam2; const Param3: TParam3);
  generic TTernaryProcedureMethod<TParam1, TParam2, TParam3> = procedure(Param1: TParam1; Param2: TParam2; Param3: TParam3) of object;
  generic TConstTernaryProcedureMethod<TParam1, TParam2, TParam3> = procedure(const Param1: TParam1; const Param2: TParam2; const Param3: TParam3) of object;
  generic TTernaryProcedureNested<TParam1, TParam2, TParam3> = procedure(Param1: TParam1; Param2: TParam2; Param3: TParam3) is nested;
  generic TConstTernaryProcedureNested<TParam1, TParam2, TParam3> = procedure(const Param1: TParam1; const Param2: TParam2; const Param3: TParam3) is nested;

  generic TAnyTernaryProcedure<TParam1, TParam2, TParam3> = record
  public type
    TMyType = specialize TAnyTernaryProcedure<TParam1, TParam2, TParam3>;
    TMyTernaryProcedure = specialize TTernaryProcedure<TParam1, TParam2, TParam3>;
    TMyConstTernaryProcedure = specialize TConstTernaryProcedure<TParam1, TParam2, TParam3>;
    TMyTernaryProcedureMethod = specialize TTernaryProcedureMethod<TParam1, TParam2, TParam3>;
    TMyConstTernaryProcedureMethod = specialize TConstTernaryProcedureMethod<TParam1, TParam2, TParam3>;
    TMyTernaryProcedureNested = specialize TTernaryProcedureNested<TParam1, TParam2, TParam3>;
    TMyConstTernaryProcedureNested = specialize TConstTernaryProcedureNested<TParam1, TParam2, TParam3>;

  public
    class operator :=(AFunc: TMyTernaryProcedure): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstTernaryProcedure): TMyType; inline; overload;
    class operator :=(AFunc: TMyTernaryProcedureMethod): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstTernaryProcedureMethod): TMyType; inline; overload;
    class operator :=(AFunc: TMyTernaryProcedureNested): TMyType; inline; overload;
    class operator :=(AFunc: TMyConstTernaryProcedureNested): TMyType; inline; overload;

  public
    procedure apply(Param1: TParam1; Param2: TParam2; Param3: TParam3); inline;

  private
    case ProcedureType: TProcedureType of
      ptProcedure: (FProcedure: TMyTernaryProcedure);
      ptConstProcedure: (FConstProcedure: TMyConstTernaryProcedure);
      ptProcedureMethod: (FProcedureMethod: TMyTernaryProcedureMethod);
      ptConstProcedureMethod: (FConstProcedureMethod: TMyConstTernaryProcedureMethod);
      ptProcedureNested: (FProcedureNested: TMyTernaryProcedureNested);
      ptConstProcedureNested: (FConstProcedureNested: TMyConstTernaryProcedureNested);
  end;

implementation

{ TAnyFunction }

class operator TAnyFunction.:=(AFunc: TMyFunction): TMyType;
begin
  Result.FunctionType := ftFunction;
  Result.FFunction := AFunc;
end;

class operator TAnyFunction.:=(AFunc: TMyFunctionMethod): TMyType;
begin
  Result.FunctionType := ftFunctionMethod;
  Result.FFunctionMethod := AFunc;
end;

class operator TAnyFunction.:=(AFunc: TMyFunctionNested): TMyType;
begin
  Result.FunctionType := ftFunctionNested;
  Result.FFunctionNested := AFunc;
end;

function TAnyFunction.apply(): TResult;
begin
  case FunctionType of
  ftFunction: Result := FFunction();
  ftFunctionMethod: Result := FFunctionMethod();
  ftFunctionNested: Result := FFunctionNested();
  end;
end;


{ TAnyUnaryFunction }

class operator TAnyUnaryFunction.:=(AFunc: TMyUnaryFunction): TMyType;
begin
  Result.FunctionType := ftFunction;
  Result.FFunction := AFunc;
end;

class operator TAnyUnaryFunction.:=(AFunc: TMyConstUnaryFunction): TMyType;
begin
  Result.FunctionType := ftConstFunction;
  Result.FConstFunction := AFunc;
end;

class operator TAnyUnaryFunction.:=(AFunc: TMyUnaryFunctionMethod): TMyType;
begin
  Result.FunctionType := ftFunctionMethod;
  Result.FFunctionMethod := AFunc;
end;

class operator TAnyUnaryFunction.:=(AFunc: TMyConstUnaryFunctionMethod): TMyType;
begin
  Result.FunctionType := ftConstFunctionMethod;
  Result.FConstFunctionMethod := AFunc;
end;

class operator TAnyUnaryFunction.:=(AFunc: TMyUnaryFunctionNested): TMyType;
begin
  Result.FunctionType := ftFunctionNested;
  Result.FFunctionNested := AFunc;
end;

class operator TAnyUnaryFunction.:=(AFunc: TMyConstUnaryFunctionNested): TMyType;
begin
  Result.FunctionType := ftConstFunctionNested;
  Result.FConstFunctionNested := AFunc;
end;

function TAnyUnaryFunction.apply(Param1: TParam1): TResult;
begin
  case FunctionType of
  ftFunction: Result := FFunction(Param1);
  ftConstFunction: Result := FConstFunction(Param1);
  ftFunctionMethod: Result := FFunctionMethod(Param1);
  ftConstFunctionMethod: Result := FConstFunctionMethod(Param1);
  ftFunctionNested: Result := FFunctionNested(Param1);
  ftConstFunctionNested: Result := FConstFunctionNested(Param1);
  end;
end;


{ TAnyBinaryFunction }

class operator TAnyBinaryFunction.:=(AFunc: TMyBinaryFunction): TMyType;
begin
  Result.FunctionType := ftFunction;
  Result.FFunction := AFunc;
end;

class operator TAnyBinaryFunction.:=(AFunc: TMyConstBinaryFunction): TMyType;
begin
  Result.FunctionType := ftConstFunction;
  Result.FConstFunction := AFunc;
end;

class operator TAnyBinaryFunction.:=(AFunc: TMyBinaryFunctionMethod): TMyType;
begin
  Result.FunctionType := ftFunctionMethod;
  Result.FFunctionMethod := AFunc;
end;

class operator TAnyBinaryFunction.:=(AFunc: TMyConstBinaryFunctionMethod): TMyType;
begin
  Result.FunctionType := ftConstFunctionMethod;
  Result.FConstFunctionMethod := AFunc;
end;

class operator TAnyBinaryFunction.:=(AFunc: TMyBinaryFunctionNested): TMyType;
begin
  Result.FunctionType := ftFunctionNested;
  Result.FFunctionNested := AFunc;
end;

class operator TAnyBinaryFunction.:=(AFunc: TMyConstBinaryFunctionNested): TMyType;
begin
  Result.FunctionType := ftConstFunctionNested;
  Result.FConstFunctionNested := AFunc;
end;

function TAnyBinaryFunction.apply(Param1: TParam1; Param2: TParam2): TResult;
begin
  case FunctionType of
  ftFunction: Result := FFunction(Param1, Param2);
  ftConstFunction: Result := FConstFunction(Param1, Param2);
  ftFunctionMethod: Result := FFunctionMethod(Param1, Param2);
  ftConstFunctionMethod: Result := FConstFunctionMethod(Param1, Param2);
  ftFunctionNested: Result := FFunctionNested(Param1, Param2);
  ftConstFunctionNested: Result := FConstFunctionNested(Param1, Param2);
  end;
end;


{ TAnyTernaryFunction }

class operator TAnyTernaryFunction.:=(AFunc: TMyTernaryFunction): TMyType;
begin
  Result.FunctionType := ftFunction;
  Result.FFunction := AFunc;
end;

class operator TAnyTernaryFunction.:=(AFunc: TMyConstTernaryFunction): TMyType;
begin
  Result.FunctionType := ftConstFunction;
  Result.FConstFunction := AFunc;
end;

class operator TAnyTernaryFunction.:=(AFunc: TMyTernaryFunctionMethod): TMyType;
begin
  Result.FunctionType := ftFunctionMethod;
  Result.FFunctionMethod := AFunc;
end;

class operator TAnyTernaryFunction.:=(AFunc: TMyConstTernaryFunctionMethod): TMyType;
begin
  Result.FunctionType := ftConstFunctionMethod;
  Result.FConstFunctionMethod := AFunc;
end;

class operator TAnyTernaryFunction.:=(AFunc: TMyTernaryFunctionNested): TMyType;
begin
  Result.FunctionType := ftFunctionNested;
  Result.FFunctionNested := AFunc;
end;

class operator TAnyTernaryFunction.:=(AFunc: TMyConstTernaryFunctionNested): TMyType;
begin
  Result.FunctionType := ftConstFunctionNested;
  Result.FConstFunctionNested := AFunc;
end;

function TAnyTernaryFunction.apply(Param1: TParam1; Param2: TParam2; Param3: TParam3): TResult;
begin
  case FunctionType of
  ftFunction: Result := FFunction(Param1, Param2, Param3);
  ftConstFunction: Result := FConstFunction(Param1, Param2, Param3);
  ftFunctionMethod: Result := FFunctionMethod(Param1, Param2, Param3);
  ftConstFunctionMethod: Result := FConstFunctionMethod(Param1, Param2, Param3);
  ftFunctionNested: Result := FFunctionNested(Param1, Param2, Param3);
  ftConstFunctionNested: Result := FConstFunctionNested(Param1, Param2, Param3);
  end;
end;


{ TAnyProcedure }

class operator TAnyProcedure.:=(AFunc: TProcedure): TAnyProcedure;
begin
  Result.ProcedureType := ptProcedure;
  Result.FProcedure := AFunc;
end;

class operator TAnyProcedure.:=(AFunc: TProcedureMethod): TAnyProcedure;
begin
  Result.ProcedureType := ptProcedureMethod;
  Result.FProcedureMethod := AFunc;
end;

class operator TAnyProcedure.:=(AFunc: TProcedureNested): TAnyProcedure;
begin
  Result.ProcedureType := ptProcedureNested;
  Result.FProcedureNested := AFunc;
end;

procedure TAnyProcedure.apply();
begin
  case ProcedureType of
  ptProcedure: FProcedure();
  ptProcedureMethod: FProcedureMethod();
  ptProcedureNested: FProcedureNested();
  end;
end;


{ TAnyUnaryProcedure }

class operator TAnyUnaryProcedure.:=(AFunc: TMyUnaryProcedure): TMyType;
begin
  Result.ProcedureType := ptProcedure;
  Result.FProcedure := AFunc;
end;

class operator TAnyUnaryProcedure.:=(AFunc: TMyConstUnaryProcedure): TMyType;
begin
  Result.ProcedureType := ptConstProcedure;
  Result.FConstProcedure := AFunc;
end;

class operator TAnyUnaryProcedure.:=(AFunc: TMyUnaryProcedureMethod): TMyType;
begin
  Result.ProcedureType := ptProcedureMethod;
  Result.FProcedureMethod := AFunc;
end;

class operator TAnyUnaryProcedure.:=(AFunc: TMyConstUnaryProcedureMethod): TMyType;
begin
  Result.ProcedureType := ptConstProcedureMethod;
  Result.FConstProcedureMethod := AFunc;
end;

class operator TAnyUnaryProcedure.:=(AFunc: TMyUnaryProcedureNested): TMyType;
begin
  Result.ProcedureType := ptProcedureNested;
  Result.FProcedureNested := AFunc;
end;

class operator TAnyUnaryProcedure.:=(AFunc: TMyConstUnaryProcedureNested): TMyType;
begin
  Result.ProcedureType := ptConstProcedureNested;
  Result.FConstProcedureNested := AFunc;
end;

procedure TAnyUnaryProcedure.apply(Param1: TParam1);
begin
  case ProcedureType of
  ptProcedure: FProcedure(Param1);
  ptConstProcedure: FConstProcedure(Param1);
  ptProcedureMethod: FProcedureMethod(Param1);
  ptConstProcedureMethod: FConstProcedureMethod(Param1);
  ptProcedureNested: FProcedureNested(Param1);
  ptConstProcedureNested: FConstProcedureNested(Param1);
  end;
end;


{ TAnyBinaryProcedure }

class operator TAnyBinaryProcedure.:=(AFunc: TMyBinaryProcedure): TMyType;
begin
  Result.ProcedureType := ptProcedure;
  Result.FProcedure := AFunc;
end;

class operator TAnyBinaryProcedure.:=(AFunc: TMyConstBinaryProcedure): TMyType;
begin
  Result.ProcedureType := ptConstProcedure;
  Result.FConstProcedure := AFunc;
end;

class operator TAnyBinaryProcedure.:=(AFunc: TMyBinaryProcedureMethod): TMyType;
begin
  Result.ProcedureType := ptProcedureMethod;
  Result.FProcedureMethod := AFunc;
end;

class operator TAnyBinaryProcedure.:=(AFunc: TMyConstBinaryProcedureMethod): TMyType;
begin
  Result.ProcedureType := ptConstProcedureMethod;
  Result.FConstProcedureMethod := AFunc;
end;

class operator TAnyBinaryProcedure.:=(AFunc: TMyBinaryProcedureNested): TMyType;
begin
  Result.ProcedureType := ptProcedureNested;
  Result.FProcedureNested := AFunc;
end;

class operator TAnyBinaryProcedure.:=(AFunc: TMyConstBinaryProcedureNested): TMyType;
begin
  Result.ProcedureType := ptConstProcedureNested;
  Result.FConstProcedureNested := AFunc;
end;

procedure TAnyBinaryProcedure.apply(Param1: TParam1; Param2: TParam2);
begin
  case ProcedureType of
  ptProcedure: FProcedure(Param1, Param2);
  ptConstProcedure: FConstProcedure(Param1, Param2);
  ptProcedureMethod: FProcedureMethod(Param1, Param2);
  ptConstProcedureMethod: FConstProcedureMethod(Param1, Param2);
  ptProcedureNested: FProcedureNested(Param1, Param2);
  ptConstProcedureNested: FConstProcedureNested(Param1, Param2);
  end;
end;


{ TAnyTernaryProcedure }

class operator TAnyTernaryProcedure.:=(AFunc: TMyTernaryProcedure): TMyType;
begin
  Result.ProcedureType := ptProcedure;
  Result.FProcedure := AFunc;
end;

class operator TAnyTernaryProcedure.:=(AFunc: TMyConstTernaryProcedure): TMyType;
begin
  Result.ProcedureType := ptConstProcedure;
  Result.FConstProcedure := AFunc;
end;

class operator TAnyTernaryProcedure.:=(AFunc: TMyTernaryProcedureMethod): TMyType;
begin
  Result.ProcedureType := ptProcedureMethod;
  Result.FProcedureMethod := AFunc;
end;

class operator TAnyTernaryProcedure.:=(AFunc: TMyConstTernaryProcedureMethod): TMyType;
begin
  Result.ProcedureType := ptConstProcedureMethod;
  Result.FConstProcedureMethod := AFunc;
end;

class operator TAnyTernaryProcedure.:=(AFunc: TMyTernaryProcedureNested): TMyType;
begin
  Result.ProcedureType := ptProcedureNested;
  Result.FProcedureNested := AFunc;
end;

class operator TAnyTernaryProcedure.:=(AFunc: TMyConstTernaryProcedureNested): TMyType;
begin
  Result.ProcedureType := ptConstProcedureNested;
  Result.FConstProcedureNested := AFunc;
end;

procedure TAnyTernaryProcedure.apply(Param1: TParam1; Param2: TParam2; Param3: TParam3);
begin
  case ProcedureType of
  ptProcedure: FProcedure(Param1, Param2, Param3);
  ptConstProcedure: FConstProcedure(Param1, Param2, Param3);
  ptProcedureMethod: FProcedureMethod(Param1, Param2, Param3);
  ptConstProcedureMethod: FConstProcedureMethod(Param1, Param2, Param3);
  ptProcedureNested: FProcedureNested(Param1, Param2, Param3);
  ptConstProcedureNested: FConstProcedureNested(Param1, Param2, Param3);
  end;
end;


end.
