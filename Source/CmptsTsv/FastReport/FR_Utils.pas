
{******************************************}
{                                          }
{             FastReport v2.4              }
{            Various routines              }
{                                          }
{ Copyright (c) 1998-2001 by Tzyganenko A. }
{                                          }
{******************************************}

unit FR_Utils;

interface

{$I FR.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  FR_DBRel, Forms, StdCtrls, Menus;


procedure frReadMemo(Stream: TStream; l: TStrings);
procedure frReadMemo22(Stream: TStream; l: TStrings);
procedure frWriteMemo(Stream: TStream; l: TStrings);
function frReadString(Stream: TStream): String;
function frReadString22(Stream: TStream): String;
procedure frWriteString(Stream: TStream; s: String);
function frReadBoolean(Stream: TStream): Boolean;
function frReadByte(Stream: TStream): Byte;
function frReadWord(Stream: TStream): Word;
function frReadInteger(Stream: TStream): Integer;
procedure frReadFont(Stream: TStream; Font: TFont);
procedure frWriteBoolean(Stream: TStream; Value: Boolean);
procedure frWriteByte(Stream: TStream; Value: Byte);
procedure frWriteWord(Stream: TStream; Value: Word);
procedure frWriteInteger(Stream: TStream; Value: Integer);
procedure frWriteFont(Stream: TStream; Font: TFont);
procedure frEnableControls(c: Array of TControl; e: Boolean);
function frControlAtPos(Win: TWinControl; p: TPoint): TControl;
function frGetDataSet(ComplexName: String): TfrTDataSet;
function frGetFieldValue(F: TfrTField): Variant;
procedure frGetDataSetAndField(ComplexName: String;
  var DataSet: TfrTDataSet; var Field: String);
function frGetFontStyle(Style: TFontStyles): Integer;
function frSetFontStyle(Style: Integer): TFontStyles;
function frFindComponent(Owner: TComponent; Name: String): TComponent;
procedure frGetComponents(Owner: TComponent; ClassRef: TClass;
  List: TStrings; Skip: TComponent);
function frGetWindowsVersion: String;
function frStrToFloat(s: String): Double;
function frRemoveQuotes(const s: String): String;
procedure frSetCommaText(Text: String; sl: TStringList);
function frLoadStr(ID: Integer): String;


implementation

uses FR_Class, FR_DSet
{$IFDEF IBO}
, IB_Components, IB_Header
{$ELSE}
, DB
{$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};


//--------------------------------------------------------------------------
function frSetFontStyle(Style: Integer): TFontStyles;
begin
  Result := [];
  if (Style and $1) <> 0 then Result := Result + [fsItalic];
  if (Style and $2) <> 0 then Result := Result + [fsBold];
  if (Style and $4) <> 0 then Result := Result + [fsUnderLine];
  if (Style and $8) <> 0 then Result := Result + [fsStrikeOut];
end;

function frGetFontStyle(Style: TFontStyles): Integer;
begin
  Result := 0;
  if fsItalic in Style then Result := Result or $1;
  if fsBold in Style then Result := Result or $2;
  if fsUnderline in Style then Result := Result or $4;
  if fsStrikeOut in Style then Result := Result or $8;
end;

procedure frReadMemo(Stream: TStream; l: TStrings);
var
  s: String;
  b: Byte;
  n: Word;
begin
  l.Clear;
  Stream.Read(n, 2);
  if n > 0 then
    repeat
      Stream.Read(n, 2);
      SetLength(s, n);
      if n > 0 then
        Stream.Read(s[1], n);
      l.Add(s);
      Stream.Read(b, 1);
    until b = 0
  else
    Stream.Read(b, 1);
end;

procedure frWriteMemo(Stream: TStream; l: TStrings);
var
  s: String;
  i: Integer;
  n: Word;
  b: Byte;
begin
  n := l.Count;
  Stream.Write(n, 2);
  for i := 0 to l.Count - 1 do
  begin
    s := l[i];
    n := Length(s);
    Stream.Write(n, 2);
    if n > 0 then
      Stream.Write(s[1], n);
    b := 13;
    if i <> l.Count - 1 then Stream.Write(b, 1);
  end;
  b := 0;
  Stream.Write(b, 1);
end;

function frReadString(Stream: TStream): String;
var
  s: String;
  n: Word;
  b: Byte;
begin
  Stream.Read(n, 2);
  SetLength(s, n);
  if n > 0 then
    Stream.Read(s[1], n);
  Stream.Read(b, 1);
  Result := s;
end;

procedure frWriteString(Stream: TStream; s: String);
var
  b: Byte;
  n: Word;
begin
  n := Length(s);
  Stream.Write(n, 2);
  if n > 0 then
    Stream.Write(s[1], n);
  b := 0;
  Stream.Write(b, 1);
end;

procedure frReadMemo22(Stream: TStream; l: TStrings);
var
  s: String;
  i: Integer;
  b: Byte;
begin
  SetLength(s, 4096);
  l.Clear;
  i := 1;
  repeat
    Stream.Read(b,1);
    if (b = 13) or (b = 0) then
    begin
      SetLength(s, i - 1);
      if not ((b = 0) and (i = 1)) then l.Add(s);
      SetLength(s, 4096);
      i := 1;
    end
    else if b <> 0 then
    begin
      s[i] := Chr(b);
      Inc(i);
      if i > 4096 then
        SetLength(s, Length(s) + 4096);
    end;
  until b = 0;
end;

function frReadString22(Stream: TStream): String;
var
  s: String;
  i: Integer;
  b: Byte;
begin
  SetLength(s, 4096);
  i := 1;
  repeat
    Stream.Read(b, 1);
    if b = 0 then
      SetLength(s, i - 1)
    else
    begin
      s[i] := Chr(b);
      Inc(i);
      if i > 4096 then
        SetLength(s, Length(s) + 4096);
    end;
  until b = 0;
  Result := s;
end;

function frReadBoolean(Stream: TStream): Boolean;
begin
  Stream.Read(Result, 1);
end;

function frReadByte(Stream: TStream): Byte;
begin
  Stream.Read(Result, 1);
end;

function frReadWord(Stream: TStream): Word;
begin
  Stream.Read(Result, 2);
end;

function frReadInteger(Stream: TStream): Integer;
begin
  Stream.Read(Result, 4);
end;

{$HINTS OFF}
procedure frReadFont(Stream: TStream; Font: TFont);
var
  w: Word;
begin
  Font.Name := frReadString(Stream);
  Font.Size := frReadInteger(Stream);
  Font.Style := frSetFontStyle(frReadWord(Stream));
  Font.Color := frReadInteger(Stream);
  w := frReadWord(Stream);
{$IFNDEF Delphi2}
  Font.Charset := w;
{$ENDIF}
end;
{$HINTS ON}

procedure frWriteBoolean(Stream: TStream; Value: Boolean);
begin
  Stream.Write(Value, 1);
end;

procedure frWriteByte(Stream: TStream; Value: Byte);
begin
  Stream.Write(Value, 1);
end;

procedure frWriteWord(Stream: TStream; Value: Word);
begin
  Stream.Write(Value, 2);
end;

procedure frWriteInteger(Stream: TStream; Value: Integer);
begin
  Stream.Write(Value, 4);
end;

{$HINTS OFF}
procedure frWriteFont(Stream: TStream; Font: TFont);
var
  w: Word;
begin
  frWriteString(Stream, Font.Name);
  frWriteInteger(Stream, Font.Size);
  frWriteWord(Stream, frGetFontStyle(Font.Style));
  frWriteInteger(Stream, Font.Color);
  w := frCharset;
{$IFNDEF Delphi2}
  w := Font.Charset;
{$ENDIF}
  frWriteWord(Stream, w);
end;
{$HINTS ON}

type
  THackWinControl = class(TWinControl)
  end;

procedure frEnableControls(c: Array of TControl; e: Boolean);
const
  Clr1: Array[Boolean] of TColor = (clGrayText, clWindowText);
  Clr2: Array[Boolean] of TColor = (clBtnFace, clWindow);
var
  i: Integer;
begin
  for i := Low(c) to High(c) do
    if c[i] is TLabel then
      with c[i] as TLabel do
      begin
        Font.Color := Clr1[e];
        Enabled := e;
      end
    else if c[i] is TWinControl then
      with THackWinControl(c[i]) do
      begin
        Color := Clr2[e];
        Enabled := e;
      end
    else
      c[i].Enabled := e;
end;

function frControlAtPos(Win: TWinControl; p: TPoint): TControl;
var
  i: Integer;
  c: TControl;
  p1: TPoint;
begin
  Result := nil;
  with Win do
  begin
    for i := ControlCount - 1 downto 0 do
    begin
      c := Controls[i];
      if c.Visible and PtInRect(Rect(c.Left, c.Top, c.Left + c.Width, c.Top + c.Height), p) then
        if (c is TWinControl) and (csAcceptsControls in c.ControlStyle) and
           (TWinControl(c).ControlCount > 0) then
        begin
          p1 := p;
          Dec(p1.X, c.Left); Dec(p1.Y, c.Top);
          c := frControlAtPos(TWinControl(c), p1);
          if c <> nil then
          begin
            Result := c;
            Exit;
          end;
        end
        else
        begin
          Result := c;
          Exit;
        end;
    end;
  end;
end;

function frGetDataSet(ComplexName: String): TfrTDataSet;
begin
  Result := TfrTDataSet(frFindComponent(CurReport.Owner, ComplexName));
end;

function frGetFieldValue(F: TfrTField): Variant;
begin
{$IFDEF IBO}
{$IFDEF Delphi4}
  if (F.SQLType = SQL_INT64) or (F.SQLType = SQL_INT64_) and (F.SQLScale = 0) then
     Result := F.DisplayText
  else
{$ENDIF}
  begin
    if (F.IsBoolean) and not ((F.SqlType=SQL_Text) or (F.SqlType=SQL_Text_)) then
      Result := F.AsBoolean
    else
      Result := F.AsVariant;
  end;

  if VarIsEmpty(Result) or (Result = Null) then
  begin
    case F.SqlType of
      SQL_Text, SQL_Text_,
      SQL_BLOB, SQL_BLOB_,
      SQL_Array, SQL_Array_,
      SQL_Varying, SQL_Varying_: Result := '';
      SQL_DOUBLE, SQL_DOUBLE_,
      SQL_FLOAT, SQL_FLOAT_,
      SQL_LONG, SQL_LONG_,
      SQL_D_FLOAT, SQL_D_FLOAT_,
      SQL_QUAD, SQL_QUAD_,
      SQL_SHORT, SQL_SHORT_,
      SQL_INT64, SQL_INT64_,
      SQL_DATE, SQL_DATE_: Result := 0;
    end;
  end;

{$ELSE}
  if not F.DataSet.Active then
    F.DataSet.Open;
  if Assigned(F.OnGetText) then
    Result := F.DisplayText else
{$IFDEF Delphi4}
  if F.DataType in [ftLargeint] then
    Result := F.DisplayText
  else
{$ENDIF}
  Result := F.AsVariant;

  if Result = Null then
    if F.DataType = ftString then
      Result := ''
{$IFDEF Delphi4}
    else if F.DataType = ftWideString then
      Result := ''
{$ENDIF}
    else if F.DataType = ftBoolean then
      Result := False
    else
      Result := 0;
{$ENDIF}
end;

procedure frGetDataSetAndField(ComplexName: String; var DataSet: TfrTDataSet;
  var Field: String);
var
  i, j, n: Integer;
  f: TComponent;
  sl: TStringList;
  s: String;
  c: Char;
  cn: TControl;

  function FindField(ds: TfrTDataSet; FName: String): String;
  var
    sl: TStringList;
  begin
    Result := '';
    if ds <> nil then
    begin
      sl := TStringList.Create;
      frGetFieldNames(ds, sl);
      if sl.IndexOf(FName) <> -1 then
        Result := FName;
      sl.Free;
    end;
  end;

begin
  Field := '';
  f := CurReport.Owner;
  sl := TStringList.Create;

  n := 0; j := 1;
  for i := 1 to Length(ComplexName) do
  begin
    c := ComplexName[i];
    if c = '"' then
    begin
      sl.Add(Copy(ComplexName, i, 255));
      j := i;
      break;
    end
    else if c = '.' then
    begin
      sl.Add(Copy(ComplexName, j, i - j));
      j := i + 1;
      Inc(n);
    end;
  end;
  if j <> i then
    sl.Add(Copy(ComplexName, j, 255));

  case n of
    0: // field name only
      begin
        if DataSet <> nil then
        begin
          s := frRemoveQuotes(ComplexName);
          Field := FindField(DataSet, s);
        end;
      end;
    1: // DatasetName.FieldName
      begin
        DataSet := TfrTDataSet(frFindComponent(f, sl[0]));
        s := frRemoveQuotes(sl[1]);
        Field := FindField(DataSet, s);
      end;
    2: // FormName.DatasetName.FieldName
      begin
        f := FindGlobalComponent(sl[0]);
        if f <> nil then
        begin
          DataSet := TfrTDataSet(f.FindComponent(sl[1]));
          s := frRemoveQuotes(sl[2]);
          Field := FindField(DataSet, s);
        end;
      end;
    3: // FormName.FrameName.DatasetName.FieldName - Delphi5
      begin
        f := FindGlobalComponent(sl[0]);
        if f <> nil then
        begin
          cn := TControl(f.FindComponent(sl[1]));
          DataSet := TfrTDataSet(cn.FindComponent(sl[2]));
          s := frRemoveQuotes(sl[3]);
          Field := FindField(DataSet, s);
        end;
      end;
  end;

  sl.Free;
end;

function frFindComponent(Owner: TComponent; Name: String): TComponent;
var
  n: Integer;
  s1, s2: String;
begin
  Result := nil;
  n := Pos('.', Name);
  try
    if n = 0 then
      Result := Owner.FindComponent(Name)
    else
    begin
      s1 := Copy(Name, 1, n - 1);        // module name
      s2 := Copy(Name, n + 1, 255);      // component name
      Owner := FindGlobalComponent(s1);
      if Owner <> nil then
      begin
        n := Pos('.', s2);
        if n <> 0 then        // frame name - Delphi5
        begin
          s1 := Copy(s2, 1, n - 1);
          s2 := Copy(s2, n + 1, 255);
          Owner := Owner.FindComponent(s1);
          if Owner <> nil then
            Result := Owner.FindComponent(s2);
        end
        else
          Result := Owner.FindComponent(s2);
      end;
    end;
  except
    on Exception do
      raise EClassNotFound.Create('Missing ' + Name);
  end;
end;

{$HINTS OFF}
procedure frGetComponents(Owner: TComponent; ClassRef: TClass;
  List: TStrings; Skip: TComponent);
var
  i, j: Integer;

  procedure EnumComponents(f: TComponent);
  var
    i: Integer;
    c: TComponent;
  begin
{$IFDEF Delphi5}
    if f is TForm then
      for i := 0 to TForm(f).ControlCount - 1 do
      begin
        c := TForm(f).Controls[i];
        if c is TFrame then
          EnumComponents(c);
      end;
{$ENDIF}
    for i := 0 to f.ComponentCount - 1 do
    begin
      c := f.Components[i];
      if (c <> Skip) and (c is ClassRef) then
        if f = Owner then
          List.Add(c.Name)
        else if ((f is TForm) or (f is TDataModule)) then
          List.Add(f.Name + '.' + c.Name)
        else
          List.Add(TControl(f).Parent.Name + '.' + f.Name + '.' + c.Name)
    end;
  end;

begin
  List.Clear;
  for i := 0 to Screen.FormCount - 1 do
    EnumComponents(Screen.Forms[i]);
  for i := 0 to Screen.DataModuleCount - 1 do
    EnumComponents(Screen.DataModules[i]);
{$IFDEF Delphi6}
  with Screen do
    for i := 0 to CustomFormCount - 1 do
      with CustomForms[i] do
      if (ClassName = 'TDataModuleForm')  then
        for j := 0 to ComponentCount - 1 do
        begin
          if (Components[j] is TDataModule) then
            EnumComponents(Components[j]);
        end;
{$ENDIF}
end;
{$HINTS ON}

function frGetWindowsVersion: String;
var
  Ver: TOsVersionInfo;
begin
  Ver.dwOSVersionInfoSize := SizeOf(Ver);
  GetVersionEx(Ver);
  with Ver do begin
    case dwPlatformId of
      VER_PLATFORM_WIN32s: Result := '32s';
      VER_PLATFORM_WIN32_WINDOWS:
        begin
          dwBuildNumber := dwBuildNumber and $0000FFFF;
          if (dwMajorVersion > 4) or ((dwMajorVersion = 4) and
            (dwMinorVersion >= 10)) then
            Result := '98' else
            Result := '95';
        end;
      VER_PLATFORM_WIN32_NT: Result := 'NT';
    end;
  end;
end;

function frStrToFloat(s: String): Double;
var
  i: Integer;
begin
  for i := 1 to Length(s) do
    if s[i] in [',', '.'] then
      s[i] := DecimalSeparator;
  Result := StrToFloat(Trim(s));
end;

function frRemoveQuotes(const s: String): String;
begin
  if (Length(s) > 2) and (s[1] = '"') and (s[Length(s)] = '"') then
    Result := Copy(s, 2, Length(s) - 2) else
    Result := s;
end;

procedure frSetCommaText(Text: String; sl: TStringList);
var
  i: Integer;

  function ExtractCommaName(s: string; var Pos: Integer): string;
  var
    i: Integer;
  begin
    i := Pos;
    while (i <= Length(s)) and (s[i] <> ';') do Inc(i);
    Result := Copy(s, Pos, i - Pos);
    if (i <= Length(s)) and (s[i] = ';') then Inc(i);
    Pos := i;
  end;

begin
  i := 1;
  sl.Clear;
  while i <= Length(Text) do
    sl.Add(ExtractCommaName(Text, i));
end;

function frLoadStr(ID: Integer): String;
begin
  Result := frLocale.LoadStr(ID);
end;

end.
