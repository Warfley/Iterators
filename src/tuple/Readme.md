# Tuples
Tuples are types that hold multiple values of different types. This unit supports Tuples with up to 5 values (Pair, Triple, Quadruple, Quintuple):

```pascal
var
  p: TPair<String, Integer>;
begin
  p := TPair<String, Integer>.Create('Hello World', 42);
  // The same as
  p := Pair<String, Integer>('Hello World', 42);
  // The same as
  p := Tuple<String, Integer>('Hello World', 42);
  // Or using implicit specialization
  p := Pair('Hello World', 42);
```
The values can be accessed via `First`, `Second`, `Third`, `Fourth` and `Fifth`:
```pascal
  WriteLn('First: ', p.First, ' Second: ', p.Second);
```

These are public record fields, so you can take the pointer of them to get pointer access:
```pascal
var
  p: TPair<String, Integer>;
  pt: PString;
begin
  pt := @p.First;
```

## Unpacking
Tuples allow for unpacking into normal variables with a form of pattern matching, by using the `_` placeholder:
```pascal
var
  q: TQuintuple<String, Integer, Double, Integer, String>;
  i, j: Integer;
begin
  ...
  // Unpack the 2nd and 3rd element into i and j
  q.Unpack(_, i, _, j, _);
```

See `examples/tupletest` for further information
