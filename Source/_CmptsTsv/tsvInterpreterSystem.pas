unit tsvInterpreterSystem;

interface

uses UMainUnited, tsvInterpreterCore;


procedure TObject_ClassType(var Value: Variant; Args: TArguments);
procedure TObject_ClassName(var Value: Variant; Args: TArguments);
procedure TObject_ClassNameIs(var Value: Variant; Args: TArguments);
procedure TObject_ClassParent(var Value: Variant; Args: TArguments);
procedure TObject_ClassInfo(var Value: Variant; Args: TArguments);
procedure TObject_InstanceSize(var Value: Variant; Args: TArguments);
procedure TObject_InheritsFrom(var Value: Variant; Args: TArguments);


procedure System_Inc(var Value: Variant; Args: TArguments);
procedure System_Dec(var Value: Variant; Args: TArguments);
procedure System_Move(var Value: Variant; Args: TArguments);
procedure System_ParamCount(var Value: Variant; Args: TArguments);
procedure System_ParamStr(var Value: Variant; Args: TArguments);
procedure System_Randomize(var Value: Variant; Args: TArguments);
procedure System_Random(var Value: Variant; Args: TArguments);
procedure System_RandomRange(var Value: Variant; Args: TArguments);
procedure System_UpCase(var Value: Variant; Args: TArguments);
procedure System_VarType(var Value: Variant; Args: TArguments);
procedure System_VarAsType(var Value: Variant; Args: TArguments);
procedure System_VarIsEmpty(var Value: Variant; Args: TArguments);
procedure System_VarIsNull(var Value: Variant; Args: TArguments);
procedure System_VarToStr(var Value: Variant; Args: TArguments);
procedure System_VarFromDateTime(var Value: Variant; Args: TArguments);
procedure System_VarToDateTime(var Value: Variant; Args: TArguments);
procedure System_Ord(var Value: Variant; Args: TArguments);
procedure System_Chr(var Value: Variant; Args: TArguments);
procedure System_Abs(var Value: Variant; Args: TArguments);
procedure System_Length(var Value: Variant; Args: TArguments);
procedure System_Copy(var Value: Variant; Args: TArguments);
procedure System_Round(var Value: Variant; Args: TArguments);
procedure System_Trunc(var Value: Variant; Args: TArguments);
procedure System_Pos(var Value: Variant; Args: TArguments);
procedure System_Delete(var value : Variant; Args : TArguments);
procedure System_Insert(var value : Variant; Args : TArguments);
procedure System_Sqr(var value : Variant; Args : TArguments);
procedure System_Sqrt(var value : Variant; Args : TArguments);
procedure System_Exp(var value : Variant; Args : TArguments);
procedure System_Ln(var value : Variant; Args : TArguments);
procedure System_Sin(var value : Variant; Args : TArguments);
procedure System_Cos(var value : Variant; Args : TArguments);
procedure System_Tan(var value : Variant; Args : TArguments);
procedure System_ArcTan(var value : Variant; Args : TArguments);
procedure System_SetLength(var Value: Variant; Args: TArguments);
procedure System_SizeOf(var Value: Variant; Args: TArguments);
procedure System_Assigned(var Value: Variant; Args: TArguments);

procedure System_VarArrayCreate(var Value: Variant; Args: TArguments);
procedure System_VarArrayOf(var Value: Variant; Args: TArguments);
procedure System_VarClear(var Value: Variant; Args: TArguments);

implementation

  { TObject }

{  function ClassType: TClass; }

procedure TObject_ClassType(var Value: Variant; Args: TArguments);
begin
  Value := C2V(TObject(Args.Obj).ClassType);
end;

{  function ClassName: ShortString; }

procedure TObject_ClassName(var Value: Variant; Args: TArguments);
begin
  Value := TObject(Args.Obj).ClassName;
end;

{  function ClassNameIs(const Name: string): Boolean; }

procedure TObject_ClassNameIs(var Value: Variant; Args: TArguments);
begin
  Value := TObject(Args.Obj).ClassNameIs(Args.Values[0]);
end;

{  function ClassParent: TClass; }

procedure TObject_ClassParent(var Value: Variant; Args: TArguments);
begin
  Value := C2V(TObject(Args.Obj).ClassParent);
end;

{  function ClassInfo: Pointer; }

procedure TObject_ClassInfo(var Value: Variant; Args: TArguments);
begin
  Value := P2V(TObject(Args.Obj).ClassInfo);
end;

{  function InstanceSize: Longint; }

procedure TObject_InstanceSize(var Value: Variant; Args: TArguments);
begin
  Value := TObject(Args.Obj).InstanceSize;
end;

{  function InheritsFrom(AClass: TClass): Boolean; }

procedure TObject_InheritsFrom(var Value: Variant; Args: TArguments);
begin
  Value := TObject(Args.Obj).InheritsFrom(V2C(Args.Values[0]));
end;


// procedure Inc(var X [ ; N: Longint ] );
procedure System_Inc(var Value: Variant; Args: TArguments);
var
  i: LongInt;
begin
  i:=Args.Values[0];
  if Args.Count=1 then
   Inc(i)
  else Inc(i,Integer(Args.Values[1]));
  Args.Values[0]:=i;
end;

// procedure Dec(var X[ ; N: Longint]);
procedure System_Dec(var Value: Variant; Args: TArguments);
var
  i: LongInt;
begin
  i:=Args.Values[0];
  if Args.Count=1 then
   Dec(i)
  else Dec(i,Integer(Args.Values[1]));
  Args.Values[0]:=i;
end;

{ procedure Move(const Source; var Dest; Count: Integer); }

procedure System_Move(var Value: Variant; Args: TArguments);
begin
  Move(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ function ParamCount: Integer; }

procedure System_ParamCount(var Value: Variant; Args: TArguments);
begin
  Value := ParamCount;
end;

{ function ParamStr(Index: Integer): string; }

procedure System_ParamStr(var Value: Variant; Args: TArguments);
begin
  Value := ParamStr(Args.Values[0]);
end;

{ procedure Randomize; }

procedure System_Randomize(var Value: Variant; Args: TArguments);
begin
  Randomize;
end;

procedure System_Random(var Value: Variant; Args: TArguments);
begin
  Value := Random(Integer(Args.Values[0]));
end;

function RandomRange(const AFrom, ATo: Integer): Integer;
begin
  if AFrom > ATo then
    Result := Random(AFrom - ATo) + ATo
  else
    Result := Random(ATo - AFrom) + AFrom;
end;

procedure System_RandomRange(var Value: Variant; Args: TArguments);
begin
  Value:=RandomRange(Args.Values[0],Args.Values[1]);
end;

{ function UpCase(Ch: Char): Char; }

procedure System_UpCase(var Value: Variant; Args: TArguments);
begin
  Value := UpCase(string(Args.Values[0])[1]);
end;

(*
{ function WideCharToString(Source: PWideChar): string; }
procedure System_WideCharToString(var Value: Variant; Args: TArguments);
begin
  Value := WideCharToString(Args.Values[0]);
end;

{ function WideCharLenToString(Source: PWideChar; SourceLen: Integer): string; }
procedure System_WideCharLenToString(var Value: Variant; Args: TArguments);
begin
  Value := WideCharLenToString(Args.Values[0], Args.Values[1]);
end;

{ procedure WideCharToStrVar(Source: PWideChar; var Dest: string); }
procedure System_WideCharToStrVar(var Value: Variant; Args: TArguments);
begin
  WideCharToStrVar(Args.Values[0], string(TVarData(Args.Values[1]).vString));
end;

{ procedure WideCharLenToStrVar(Source: PWideChar; SourceLen: Integer; var Dest: string); }
procedure System_WideCharLenToStrVar(var Value: Variant; Args: TArguments);
begin
  WideCharLenToStrVar(Args.Values[0], Args.Values[1], string(TVarData(Args.Values[2]).vString));
end;

{ function StringToWideChar(const Source: string; Dest: PWideChar; DestSize: Integer): PWideChar; }
procedure System_StringToWideChar(var Value: Variant; Args: TArguments);
begin
  Value := StringToWideChar(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ function OleStrToString(Source: PWideChar): string; }
procedure System_OleStrToString(var Value: Variant; Args: TArguments);
begin
  Value := OleStrToString(Args.Values[0]);
end;

{ procedure OleStrToStrVar(Source: PWideChar; var Dest: string); }
procedure System_OleStrToStrVar(var Value: Variant; Args: TArguments);
begin
  OleStrToStrVar(Args.Values[0], string(TVarData(Args.Values[1]).vString));
end;

{ function StringToOleStr(const Source: string): PWideChar; }
procedure System_StringToOleStr(var Value: Variant; Args: TArguments);
begin
  Value := StringToOleStr(Args.Values[0]);
end;
*)

{ function VarType(const V: Variant): Integer; }

procedure System_VarType(var Value: Variant; Args: TArguments);
begin
  Value := VarType(Args.Values[0]);
end;

{ function VarAsType(const V: Variant; VarType: Integer): Variant; }

procedure System_VarAsType(var Value: Variant; Args: TArguments);
begin
  Value := VarAsType(Args.Values[0], Args.Values[1]);
end;

{ function VarIsEmpty(const V: Variant): Boolean; }

procedure System_VarIsEmpty(var Value: Variant; Args: TArguments);
begin
  Value := VarIsEmpty(Args.Values[0]);
end;

{ function VarIsNull(const V: Variant): Boolean; }

procedure System_VarIsNull(var Value: Variant; Args: TArguments);
begin
  Value := VarIsNull(Args.Values[0]);
end;

{ function VarToStr(const V: Variant): string; }

procedure System_VarToStr(var Value: Variant; Args: TArguments);
begin
  Value := VarToStr(Args.Values[0]);
end;

{ function VarFromDateTime(DateTime: TDateTime): Variant; }

procedure System_VarFromDateTime(var Value: Variant; Args: TArguments);
begin
  Value := VarFromDateTime(Args.Values[0]);
end;

{ function VarToDateTime(const V: Variant): TDateTime; }

procedure System_VarToDateTime(var Value: Variant; Args: TArguments);
begin
  Value := VarToDateTime(Args.Values[0]);
end;

(*
{ function VarArrayCreate(const Bounds: array of Integer; VarType: Integer): Variant; }
procedure System_VarArrayCreate(var Value: Variant; Args: TArguments);
begin
  Value := VarArrayCreate(Args.Values[0], Args.Values[1]);
end;

{ function VarArrayOf(const Values: array of Variant): Variant; }
procedure System_VarArrayOf(var Value: Variant; Args: TArguments);
begin
  Value := VarArrayOf(Args.Values[0]);
end;

{ function VarArrayDimCount(const A: Variant): Integer; }
procedure System_VarArrayDimCount(var Value: Variant; Args: TArguments);
begin
  Value := VarArrayDimCount(Args.Values[0]);
end;

{ function VarArrayLowBound(const A: Variant; Dim: Integer): Integer; }
procedure System_VarArrayLowBound(var Value: Variant; Args: TArguments);
begin
  Value := VarArrayLowBound(Args.Values[0], Args.Values[1]);
end;

{ function VarArrayHighBound(const A: Variant; Dim: Integer): Integer; }
procedure System_VarArrayHighBound(var Value: Variant; Args: TArguments);
begin
  Value := VarArrayHighBound(Args.Values[0], Args.Values[1]);
end;

{ function VarArrayLock(const A: Variant): Pointer; }
procedure System_VarArrayLock(var Value: Variant; Args: TArguments);
begin
  Value := P2V(VarArrayLock(Args.Values[0]));
end;

{ procedure VarArrayUnlock(const A: Variant); }
procedure System_VarArrayUnlock(var Value: Variant; Args: TArguments);
begin
  VarArrayUnlock(Args.Values[0]);
end;

{ function VarArrayRef(const A: Variant): Variant; }
procedure System_VarArrayRef(var Value: Variant; Args: TArguments);
begin
  Value := VarArrayRef(Args.Values[0]);
end;

{ function VarIsArray(const A: Variant): Boolean; }
procedure System_VarIsArray(var Value: Variant; Args: TArguments);
begin
  Value := VarIsArray(Args.Values[0]);
end;
*)

{ function Ord(const A: Variant): Integer; }

procedure System_Ord(var Value: Variant; Args: TArguments);
begin
  if VarType(Args.Values[0]) = varString then
    Value := Ord(VarToStr(Args.Values[0])[1])
  else
    Value := Integer(Args.Values[0]);
end;


{ function Chr(X: Byte): Char }

procedure System_Chr(var Value: Variant; Args: TArguments);
begin
  Value := Chr(Byte(Args.Values[0]));
end;

{ function Abs(X); }

procedure System_Abs(var Value: Variant; Args: TArguments);
begin
  if VarType(Args.Values[0]) = varInteger then
    Value := Abs(Integer(Args.Values[0]))
  else
    Value := Abs(Extended(Args.Values[0]));
end;

{ function Length(S): Integer; }

procedure System_Length(var Value: Variant; Args: TArguments);
begin
  Value := Length(Args.Values[0]);
end;

{ function Copy(S; Index, Count: Integer): String; }

procedure System_Copy(var Value: Variant; Args: TArguments);
begin
  Value := Copy(Args.Values[0], Integer(Args.Values[1]), Integer(Args.Values[2]));
end;

{ function Round(Value: Extended): Int64; }

procedure System_Round(var Value: Variant; Args: TArguments);
begin
  Value := Integer(Round(Args.Values[0]));
end;

{ function Trunc(Value: Extended): Int64; }

procedure System_Trunc(var Value: Variant; Args: TArguments);
begin
  Value := Integer(Trunc(Args.Values[0]));
end;

{ function Pos(Substr: string; S: string): Integer; }

procedure System_Pos(var Value: Variant; Args: TArguments);
begin
  Value := Pos(String(Args.Values[0]), String(Args.Values[1]));
end;

//+++pfh
{procedure Delete(var S: string; Index, Count:Integer);}
procedure System_Delete(var value : Variant; Args : TArguments);
Var
  s : String;
Begin
  s := Args.Values[0];
  Delete(S,Integer(Args.Values[1]),Integer(Args.Values[2]));
  Args.Values[0] := s;
  Value := S;
End;

{procedure Insert(Source: string; var S: string; Index: Integer);}
procedure System_Insert(var value : Variant; Args : TArguments);
Var
  s : String;
Begin
  s := Args.Values[1];
  Insert(String(Args.Values[0]),S,Integer(Args.Values[2]));
  Args.Values[1] := s;
  Value := S;
End;

{ function Sqr(X: Extended): Extended; }
procedure System_Sqr(var value : Variant; Args : TArguments);
Begin
  Value := Sqr(Args.Values[0]);
End;

{ function Sqrt(X: Extended): Extended; }
procedure System_Sqrt(var value : Variant; Args : TArguments);
Begin
  Value := Sqrt(Args.Values[0]);
End;

{ function Exp(X: Extended): Extended; }
procedure System_Exp(var value : Variant; Args : TArguments);
Begin
  Value := Exp(Args.Values[0]);
End;

{ function Ln(X: Extended): Extended; }
procedure System_Ln(var value : Variant; Args : TArguments);
Begin
  Value := Ln(Args.Values[0]);
End;

{ function Sin(X: Extended): Extended; }
procedure System_Sin(var value : Variant; Args : TArguments);
Begin
  Value := Sin(Args.Values[0]);
End;

{ function Cos(X: Extended): Extended; }
procedure System_Cos(var value : Variant; Args : TArguments);
Begin
  Value := Cos(Args.Values[0]);
End;

{ function Tan(X: Extended): Extended; }
procedure System_Tan(var value : Variant; Args : TArguments);
Begin
  Value := Sqr(Args.Values[0]);
End;

{ function ArcTan(X: Extended): Extended; }
procedure System_ArcTan(var value : Variant; Args : TArguments);
Begin
  Value := Sqr(Args.Values[0]);
End;
//---pfh

{ procedure SetLength(var s: ShortString; newLength: Integer); }
procedure System_SetLength(var Value: Variant; Args: TArguments);
begin
  SetLength(string(TVarData(Args.Values[0]).vString), Integer(Args.Values[1]));
end;

// function SizeOf(X): Integer;
procedure System_SizeOf(var Value: Variant; Args: TArguments);
begin
  Value := SizeOf(Args.Values[0]);
end;

// function Assigned(P): Boolean;
procedure System_Assigned(var Value: Variant; Args: TArguments);
var
  P: Pointer;
begin
  P:=V2P(Args.Values[0]);
  Value := Assigned(P);
end;

// function VarArrayCreate(const Bounds: array of Integer; VarType: Integer): Variant;
procedure System_VarArrayCreate(var Value: Variant; Args: TArguments);
var
  Bounds: array of Integer;
begin
  Bounds:=Args.Values[0];
  Value:=VarArrayCreate(Bounds,Args.Values[1]);
end;

// function VarArrayOf(const Values: array of Variant): Variant;
procedure System_VarArrayOf(var Value: Variant; Args: TArguments);
begin
  Value:=VarArrayOf(Args.Values[0]);
end;

// procedure VarClear(var V : Variant);
procedure System_VarClear(var Value: Variant; Args: TArguments);
var
  V: Variant;
begin
  V:=Args.Values[0];
  VarClear(V);
  Args.Values[0]:=V;
end;

end.
