unit finalizers;

{$mode ObjFPC}{$H+}
{$ModeSwitch advancedrecords}

interface

uses
  Classes, SysUtils;

type

  { TClassFinalizer }

  generic TClassFinalizer<T> = record
    class procedure Finalize(var AInstance: T); static; inline;
  end;

  { TObjectFinalizer }

  generic TObjectFinalizer<T> = record
    class procedure Finalize(var AInstance: T); static; inline;
  end;

  { TManagedFinalizer }

  generic TBaseFinalizer<T> = record
    class procedure Finalize(var AInstance: T); static; inline;
  end;

implementation

{ TManagedFinalizer }

class procedure TBaseFinalizer.Finalize(var AInstance: T);
begin
  Finalize(AInstance);
  Initialize(AInstance);
end;

{ TObjectFinalizer }

class procedure TObjectFinalizer.Finalize(var AInstance: T);
begin
  AInstance.Done;
end;

{ TClassFinalizer }

class procedure TClassFinalizer.Finalize(var AInstance: T);
begin
  FreeAndNil(AInstance);
end;

end.

