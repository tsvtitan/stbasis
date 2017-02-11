{***********************************************************
                R&A Library
                   RAI2
       Copyright (C) 1998-2001 Andrei Prygounkov

       component   : RAI2Program and more..
       description : R&A Interpreter version 2

       author      : Andrei Prygounkov
       e-mail      : a.prygounkov@gmx.de
       www         : http://ralib.hotbox.ru

       additional programming:
       peter Fischer-Haase <pfischer@ise-online.de> commented as "pfh" 
************************************************************}
{$INCLUDE RA.INC}

unit RAI2_System;

interface

uses RAI2 {$IFDEF RA_D6H}, Variants {$ENDIF};

procedure RegisterRAI2Adapter(RAI2Adapter: TRAI2Adapter);

implementation


  { TObject }

{  function ClassType: TClass; }

procedure TObject_ClassType(var Value: Variant; Args: TArgs);
begin
  Value := C2V(TObject(Args.Obj).ClassType);
end;

{  function ClassName: ShortString; }

procedure TObject_ClassName(var Value: Variant; Args: TArgs);
begin
  Value := TObject(Args.Obj).ClassName;
end;

{  function ClassNameIs(const Name: string): Boolean; }

procedure TObject_ClassNameIs(var Value: Variant; Args: TArgs);
begin
  Value := TObject(Args.Obj).ClassNameIs(Args.Values[0]);
end;

{  function ClassParent: TClass; }

procedure TObject_ClassParent(var Value: Variant; Args: TArgs);
begin
  Value := C2V(TObject(Args.Obj).ClassParent);
end;

{  function ClassInfo: Pointer; }

procedure TObject_ClassInfo(var Value: Variant; Args: TArgs);
begin
  Value := P2V(TObject(Args.Obj).ClassInfo);
end;

{  function InstanceSize: Longint; }

procedure TObject_InstanceSize(var Value: Variant; Args: TArgs);
begin
  Value := TObject(Args.Obj).InstanceSize;
end;

{  function InheritsFrom(AClass: TClass): Boolean; }

procedure TObject_InheritsFrom(var Value: Variant; Args: TArgs);
begin
  Value := TObject(Args.Obj).InheritsFrom(V2C(Args.Values[0]));
end;

(*
{  function GetInterface(const IID: TGUID; out Obj): Boolean; }
procedure TObject_GetInterface(var Value: Variant; Args: TArgs);
begin
  Value := TObject(Args.Obj).GetInterface(Args.Values[0], Args.Values[1], Args.Values[2]);
end;
*)

  { TInterfacedObject }

{$IFDEF RA_D3H}
{ property Read RefCount: Integer }

procedure TInterfacedObject_Read_RefCount(var Value: Variant; Args: TArgs);
begin
  Value := TInterfacedObject(Args.Obj).RefCount;
end;
{$ENDIF RA_D3H}

{ procedure Move(const Source; var Dest; Count: Integer); }

procedure RAI2_Move(var Value: Variant; Args: TArgs);
begin
  Move(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ function ParamCount: Integer; }

procedure RAI2_ParamCount(var Value: Variant; Args: TArgs);
begin
  Value := ParamCount;
end;

{ function ParamStr(Index: Integer): string; }

procedure RAI2_ParamStr(var Value: Variant; Args: TArgs);
begin
  Value := ParamStr(Args.Values[0]);
end;

{ procedure Randomize; }

procedure RAI2_Randomize(var Value: Variant; Args: TArgs);
begin
  Randomize;
end;

procedure RAI2_Random(var Value: Variant; Args: TArgs);
begin
  Value := Random(Integer(Args.Values[0]));
end;

{ function UpCase(Ch: Char): Char; }

procedure RAI2_UpCase(var Value: Variant; Args: TArgs);
begin
  Value := UpCase(string(Args.Values[0])[1]);
end;

(*
{ function WideCharToString(Source: PWideChar): string; }
procedure RAI2_WideCharToString(var Value: Variant; Args: TArgs);
begin
  Value := WideCharToString(Args.Values[0]);
end;

{ function WideCharLenToString(Source: PWideChar; SourceLen: Integer): string; }
procedure RAI2_WideCharLenToString(var Value: Variant; Args: TArgs);
begin
  Value := WideCharLenToString(Args.Values[0], Args.Values[1]);
end;

{ procedure WideCharToStrVar(Source: PWideChar; var Dest: string); }
procedure RAI2_WideCharToStrVar(var Value: Variant; Args: TArgs);
begin
  WideCharToStrVar(Args.Values[0], string(TVarData(Args.Values[1]).vString));
end;

{ procedure WideCharLenToStrVar(Source: PWideChar; SourceLen: Integer; var Dest: string); }
procedure RAI2_WideCharLenToStrVar(var Value: Variant; Args: TArgs);
begin
  WideCharLenToStrVar(Args.Values[0], Args.Values[1], string(TVarData(Args.Values[2]).vString));
end;

{ function StringToWideChar(const Source: string; Dest: PWideChar; DestSize: Integer): PWideChar; }
procedure RAI2_StringToWideChar(var Value: Variant; Args: TArgs);
begin
  Value := StringToWideChar(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ function OleStrToString(Source: PWideChar): string; }
procedure RAI2_OleStrToString(var Value: Variant; Args: TArgs);
begin
  Value := OleStrToString(Args.Values[0]);
end;

{ procedure OleStrToStrVar(Source: PWideChar; var Dest: string); }
procedure RAI2_OleStrToStrVar(var Value: Variant; Args: TArgs);
begin
  OleStrToStrVar(Args.Values[0], string(TVarData(Args.Values[1]).vString));
end;

{ function StringToOleStr(const Source: string): PWideChar; }
procedure RAI2_StringToOleStr(var Value: Variant; Args: TArgs);
begin
  Value := StringToOleStr(Args.Values[0]);
end;
*)

{ function VarType(const V: Variant): Integer; }

procedure RAI2_VarType(var Value: Variant; Args: TArgs);
begin
  Value := VarType(Args.Values[0]);
end;

{ function VarAsType(const V: Variant; VarType: Integer): Variant; }

procedure RAI2_VarAsType(var Value: Variant; Args: TArgs);
begin
  Value := VarAsType(Args.Values[0], Args.Values[1]);
end;

{ function VarIsEmpty(const V: Variant): Boolean; }

procedure RAI2_VarIsEmpty(var Value: Variant; Args: TArgs);
begin
  Value := VarIsEmpty(Args.Values[0]);
end;

{ function VarIsNull(const V: Variant): Boolean; }

procedure RAI2_VarIsNull(var Value: Variant; Args: TArgs);
begin
  Value := VarIsNull(Args.Values[0]);
end;

{ function VarToStr(const V: Variant): string; }

procedure RAI2_VarToStr(var Value: Variant; Args: TArgs);
begin
  Value := VarToStr(Args.Values[0]);
end;

{ function VarFromDateTime(DateTime: TDateTime): Variant; }

procedure RAI2_VarFromDateTime(var Value: Variant; Args: TArgs);
begin
  Value := VarFromDateTime(Args.Values[0]);
end;

{ function VarToDateTime(const V: Variant): TDateTime; }

procedure RAI2_VarToDateTime(var Value: Variant; Args: TArgs);
begin
  Value := VarToDateTime(Args.Values[0]);
end;

(*
{ function VarArrayCreate(const Bounds: array of Integer; VarType: Integer): Variant; }
procedure RAI2_VarArrayCreate(var Value: Variant; Args: TArgs);
begin
  Value := VarArrayCreate(Args.Values[0], Args.Values[1]);
end;

{ function VarArrayOf(const Values: array of Variant): Variant; }
procedure RAI2_VarArrayOf(var Value: Variant; Args: TArgs);
begin
  Value := VarArrayOf(Args.Values[0]);
end;

{ function VarArrayDimCount(const A: Variant): Integer; }
procedure RAI2_VarArrayDimCount(var Value: Variant; Args: TArgs);
begin
  Value := VarArrayDimCount(Args.Values[0]);
end;

{ function VarArrayLowBound(const A: Variant; Dim: Integer): Integer; }
procedure RAI2_VarArrayLowBound(var Value: Variant; Args: TArgs);
begin
  Value := VarArrayLowBound(Args.Values[0], Args.Values[1]);
end;

{ function VarArrayHighBound(const A: Variant; Dim: Integer): Integer; }
procedure RAI2_VarArrayHighBound(var Value: Variant; Args: TArgs);
begin
  Value := VarArrayHighBound(Args.Values[0], Args.Values[1]);
end;

{ function VarArrayLock(const A: Variant): Pointer; }
procedure RAI2_VarArrayLock(var Value: Variant; Args: TArgs);
begin
  Value := P2V(VarArrayLock(Args.Values[0]));
end;

{ procedure VarArrayUnlock(const A: Variant); }
procedure RAI2_VarArrayUnlock(var Value: Variant; Args: TArgs);
begin
  VarArrayUnlock(Args.Values[0]);
end;

{ function VarArrayRef(const A: Variant): Variant; }
procedure RAI2_VarArrayRef(var Value: Variant; Args: TArgs);
begin
  Value := VarArrayRef(Args.Values[0]);
end;

{ function VarIsArray(const A: Variant): Boolean; }
procedure RAI2_VarIsArray(var Value: Variant; Args: TArgs);
begin
  Value := VarIsArray(Args.Values[0]);
end;
*)

{ function Ord(const A: Variant): Integer; }

procedure RAI2_Ord(var Value: Variant; Args: TArgs);
begin
  if VarType(Args.Values[0]) = varString then
    Value := Ord(VarToStr(Args.Values[0])[1])
  else
    Value := Integer(Args.Values[0]);
end;


{ function Chr(X: Byte): Char }

procedure RAI2_Chr(var Value: Variant; Args: TArgs);
begin
  Value := Chr(Byte(Args.Values[0]));
end;

{ function Abs(X); }

procedure RAI2_Abs(var Value: Variant; Args: TArgs);
begin
  if VarType(Args.Values[0]) = varInteger then
    Value := Abs(Integer(Args.Values[0]))
  else
    Value := Abs(Extended(Args.Values[0]));
end;

{ function Length(S): Integer; }

procedure RAI2_Length(var Value: Variant; Args: TArgs);
begin
  Value := Length(Args.Values[0]);
end;

{ function Copy(S; Index, Count: Integer): String; }

procedure RAI2_Copy(var Value: Variant; Args: TArgs);
begin
  Value := Copy(Args.Values[0], Integer(Args.Values[1]), Integer(Args.Values[2]));
end;

{ function Round(Value: Extended): Int64; }

procedure RAI2_Round(var Value: Variant; Args: TArgs);
begin
  Value := Integer(Round(Args.Values[0]));
end;

{ function Trunc(Value: Extended): Int64; }

procedure RAI2_Trunc(var Value: Variant; Args: TArgs);
begin
  Value := Integer(Trunc(Args.Values[0]));
end;

{ function Pos(Substr: string; S: string): Integer; }

procedure RAI2_Pos(var Value: Variant; Args: TArgs);
begin
  Value := Pos(String(Args.Values[0]), String(Args.Values[1]));
end;

//+++pfh
{procedure Delete(var S: string; Index, Count:Integer);}
procedure RAI2_Delete(var value : Variant; Args : TArgs);
Var
  s : String;
Begin
  s := Args.Values[0];
  Delete(S,Integer(Args.Values[1]),Integer(Args.Values[2]));
  Args.Values[0] := s;
  Value := S;
End;

{procedure Insert(Source: string; var S: string; Index: Integer);}
procedure RAI2_Insert(var value : Variant; Args : TArgs);
Var
  s : String;
Begin
  s := Args.Values[1];
  Insert(String(Args.Values[0]),S,Integer(Args.Values[2]));
  Args.Values[1] := s;
  Value := S;
End;

{ function Sqr(X: Extended): Extended; }
procedure RAI2_Sqr(var value : Variant; Args : TArgs);
Begin
  Value := Sqr(Args.Values[0]);
End;

{ function Sqrt(X: Extended): Extended; }
procedure RAI2_Sqrt(var value : Variant; Args : TArgs);
Begin
  Value := Sqrt(Args.Values[0]);
End;

{ function Exp(X: Extended): Extended; }
procedure RAI2_Exp(var value : Variant; Args : TArgs);
Begin
  Value := Exp(Args.Values[0]);
End;

{ function Ln(X: Extended): Extended; }
procedure RAI2_Ln(var value : Variant; Args : TArgs);
Begin
  Value := Ln(Args.Values[0]);
End;

{ function Sin(X: Extended): Extended; }
procedure RAI2_Sin(var value : Variant; Args : TArgs);
Begin
  Value := Sin(Args.Values[0]);
End;

{ function Cos(X: Extended): Extended; }
procedure RAI2_Cos(var value : Variant; Args : TArgs);
Begin
  Value := Cos(Args.Values[0]);
End;

{ function Tan(X: Extended): Extended; }
procedure RAI2_Tan(var value : Variant; Args : TArgs);
Begin
  Value := Sqr(Args.Values[0]);
End;

{ function ArcTan(X: Extended): Extended; }
procedure RAI2_ArcTan(var value : Variant; Args : TArgs);
Begin
  Value := Sqr(Args.Values[0]);
End;
//---pfh

{ procedure SetLength(var s: ShortString; newLength: Integer); }
procedure RAI2_SetLength(var Value: Variant; Args: TArgs);
begin
  SetLength(string(TVarData(Args.Values[0]).vString), Integer(Args.Values[1]));
end;

// function SizeOf(X): Integer;
procedure RAI2_SizeOf(var Value: Variant; Args: TArgs);
begin
  Value := SizeOf(Args.Values[0]);
end;

procedure RegisterRAI2Adapter(RAI2Adapter: TRAI2Adapter);
begin
  with RAI2Adapter do
  begin
   { TObject }
    AddClass('System', TObject, 'TObject');
    AddGet(TObject, 'ClassType', TObject_ClassType, 0, [0], varEmpty);
    AddGet(TObject, 'ClassName', TObject_ClassName, 0, [0], varEmpty);
    AddGet(TObject, 'ClassNameIs', TObject_ClassNameIs, 1, [varEmpty], varEmpty);
    AddGet(TObject, 'ClassParent', TObject_ClassParent, 0, [0], varEmpty);
    AddGet(TObject, 'ClassInfo', TObject_ClassInfo, 0, [0], varEmpty);
    AddGet(TObject, 'InstanceSize', TObject_InstanceSize, 0, [0], varEmpty);
    AddGet(TObject, 'InheritsFrom', TObject_InheritsFrom, 1, [varEmpty], varEmpty);
   // AddGet(TObject, 'GetInterface', TObject_GetInterface, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
   { TInterfacedObject }
{$IFDEF RA_D3H}
    AddClass('System', TInterfacedObject, 'TInterfacedObject');
    AddGet(TInterfacedObject, 'RefCount', TInterfacedObject_Read_RefCount, 0, [0], varEmpty);
{$ENDIF RA_D3H}
    AddFun('System', 'Move', RAI2_Move, 3, [varEmpty, varByRef, varEmpty], varEmpty);
    AddFun('System', 'ParamCount', RAI2_ParamCount, 0, [0], varEmpty);
    AddFun('System', 'ParamStr', RAI2_ParamStr, 1, [varEmpty], varEmpty);
    AddFun('System', 'Randomize', RAI2_Randomize, 0, [0], varEmpty);
    AddFun('System', 'Random', RAI2_Random, 1, [varInteger], varEmpty);
    AddFun('System', 'UpCase', RAI2_UpCase, 1, [varEmpty], varEmpty);
  {  AddFun('System', 'WideCharToString', RAI2_WideCharToString, 1, [varEmpty], varEmpty);
    AddFun('System', 'WideCharLenToString', RAI2_WideCharLenToString, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('System', 'WideCharToStrVar', RAI2_WideCharToStrVar, 2, [varEmpty, varByRef], varEmpty);
    AddFun('System', 'WideCharLenToStrVar', RAI2_WideCharLenToStrVar, 3, [varEmpty, varEmpty, varByRef], varEmpty);
    AddFun('System', 'StringToWideChar', RAI2_StringToWideChar, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('System', 'OleStrToString', RAI2_OleStrToString, 1, [varEmpty], varEmpty);
    AddFun('System', 'OleStrToStrVar', RAI2_OleStrToStrVar, 2, [varEmpty, varByRef], varEmpty);
    AddFun('System', 'StringToOleStr', RAI2_StringToOleStr, 1, [varEmpty], varEmpty); }
    AddFun('System', 'VarType', RAI2_VarType, 1, [varEmpty], varEmpty);
    AddFun('System', 'VarAsType', RAI2_VarAsType, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('System', 'VarIsEmpty', RAI2_VarIsEmpty, 1, [varEmpty], varEmpty);
    AddFun('System', 'VarIsNull', RAI2_VarIsNull, 1, [varEmpty], varEmpty);
    AddFun('System', 'VarToStr', RAI2_VarToStr, 1, [varEmpty], varEmpty);
    AddFun('System', 'VarFromDateTime', RAI2_VarFromDateTime, 1, [varEmpty], varEmpty);
    AddFun('System', 'VarToDateTime', RAI2_VarToDateTime, 1, [varEmpty], varEmpty);
   { AddFun('System', 'VarArrayCreate', RAI2_VarArrayCreate, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('System', 'VarArrayOf', RAI2_VarArrayOf, 1, [varEmpty], varEmpty);
    AddFun('System', 'VarArrayDimCount', RAI2_VarArrayDimCount, 1, [varEmpty], varEmpty);
    AddFun('System', 'VarArrayLowBound', RAI2_VarArrayLowBound, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('System', 'VarArrayHighBound', RAI2_VarArrayHighBound, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('System', 'VarArrayLock', RAI2_VarArrayLock, 1, [varEmpty], varEmpty);
    AddFun('System', 'VarArrayUnlock', RAI2_VarArrayUnlock, 1, [varEmpty], varEmpty);
    AddFun('System', 'VarArrayRef', RAI2_VarArrayRef, 1, [varEmpty], varEmpty);
    AddFun('System', 'VarIsArray', RAI2_VarIsArray, 1, [varEmpty], varEmpty); }
    AddFun('System', 'ord', RAI2_Ord, 1, [varEmpty], varEmpty);

    AddFun('system', 'Chr', RAI2_Chr, 1, [varEmpty], varEmpty);
    AddFun('system', 'Abs', RAI2_Abs,1,[varEmpty], varEmpty);
    AddFun('system', 'Length', RAI2_Length,1,[varEmpty], varEmpty);
    AddFun('system', 'Copy', RAI2_Copy,3,[varEmpty,varEmpty,varEmpty], varEmpty);
    AddFun('system', 'Round', RAI2_Round,1,[varEmpty], varEmpty);
    AddFun('system', 'Trunc', RAI2_Trunc,1,[varEmpty], varEmpty);
    AddFun('system', 'Pos', RAI2_Pos,2,[varEmpty,varEmpty], varEmpty);

//+++pfh
    // some Stringfunctions
    AddFun('system', 'Delete', RAI2_Delete,3,[varByRef,varEmpty,varEmpty], varEmpty);
    AddFun('system', 'Insert', RAI2_Insert,3,[varEmpty,varByRef,varEmpty], varEmpty);
    // some mathfunctions
    AddFun('system', 'Sqr', RAI2_Sqr,1,[varEmpty], varEmpty);
    AddFun('system', 'Sqrt', RAI2_Sqrt,1,[varEmpty], varEmpty);
    AddFun('system', 'Exp', RAI2_Exp,1,[varEmpty], varEmpty);
    AddFun('system', 'Ln', RAI2_Ln,1,[varEmpty], varEmpty);
    AddFun('system', 'Sin', RAI2_Sin,1,[varEmpty], varEmpty);
    AddFun('system', 'Cos', RAI2_Cos,1,[varEmpty], varEmpty);
    AddFun('system', 'Tan', RAI2_Tan,1,[varEmpty], varEmpty);
    AddFun('system', 'ArcTan', RAI2_ArcTan,1,[varEmpty], varEmpty);
//---pfh
    AddFun('system', 'SetLength', RAI2_SetLength, 2, [varByRef or varString, varInteger], varEmpty);

    AddFun('system', 'SizeOf', RAI2_SizeOf, 1, [varByRef or varInteger], varInteger);
    
 end; { with }
end; { RegisterRAI2Adapter }

end.

