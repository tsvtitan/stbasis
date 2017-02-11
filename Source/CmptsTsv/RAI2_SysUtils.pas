{***********************************************************
                R&A Library
                   RAI2
       Copyright (C) 1998-2001 Andrei Prygounkov

       description : adapter unit - converts RAI2 calls to delphi calls

       author      : Andrei Prygounkov
       e-mail      : a.prygounkov@gmx.de
       www         : http://ralib.hotbox.ru
************************************************************}
{$INCLUDE RA.INC}

unit RAI2_SysUtils;

interface

uses SysUtils, RAI2;

  procedure RegisterRAI2Adapter(RAI2Adapter: TRAI2Adapter);

  function SearchRec2Var(const SearchRec: TSearchRec): Variant;
  function Var2SearchRec(const SearchRec: Variant): TSearchRec;

implementation

{$IFDEF LINUX}
uses Variants;
{$ENDIF}

{ TSearchRec }

function SearchRec2Var(const SearchRec: TSearchRec): Variant;
var
  Rec: ^TSearchRec;
begin
  New(Rec);
  Rec^ := SearchRec;
  Result := R2V('TSearchRec', Rec);
end;

function Var2SearchRec(const SearchRec: Variant): TSearchRec;
begin
  Result := TSearchRec(V2R(SearchRec)^);
end;

  { Exception }

{ constructor Create(Msg: string) }
procedure Exception_Create(var Value: Variant; Args: TArgs);
begin
  Value := O2V(Exception.Create(Args.Values[0]));
end;

{ constructor CreateFmt(Msg: string; Args: array) }
procedure Exception_CreateFmt(var Value: Variant; Args: TArgs);
begin
//  Value := O2V(Exception.CreateFmt(Args.Values[0], Args.Values[1]));
  NotImplemented('Exception.CreateFmt');
end;

{ constructor CreateRes(Ident: Integer) }
procedure Exception_CreateRes(var Value: Variant; Args: TArgs);
begin
  Value := O2V(Exception.CreateRes(Args.Values[0]));
end;

{ constructor CreateResFmt(Ident: Integer; Args: array) }
procedure Exception_CreateResFmt(var Value: Variant; Args: TArgs);
begin
//  Value := O2V(Exception.CreateResFmt(Args.Values[0], Args.Values[1]));
  NotImplemented('Exception.CreateResFmt');
end;

{ constructor CreateHelp(Msg: string; AHelpContext: Integer) }
procedure Exception_CreateHelp(var Value: Variant; Args: TArgs);
begin
  Value := O2V(Exception.CreateHelp(Args.Values[0], Args.Values[1]));
end;

{ constructor CreateFmtHelp(Msg: string; Args: array; AHelpContext: Integer) }
procedure Exception_CreateFmtHelp(var Value: Variant; Args: TArgs);
begin
//  Value := O2V(Exception.CreateFmtHelp(Args.Values[0], Args.Values[1], Args.Values[2]));
  NotImplemented('Exception.CreateFmtHelp');
end;

{ constructor CreateResHelp(Ident: Integer; AHelpContext: Integer) }
procedure Exception_CreateResHelp(var Value: Variant; Args: TArgs);
begin
  Value := O2V(Exception.CreateResHelp(Args.Values[0], Args.Values[1]));
end;

{ constructor CreateResFmtHelp(Ident: Integer; Args: array; AHelpContext: Integer) }
procedure Exception_CreateResFmtHelp(var Value: Variant; Args: TArgs);
begin
//  Value := O2V(Exception.CreateResFmtHelp(Args.Values[0], Args.Values[1], Args.Values[2]));
  NotImplemented('Exception.CreateResFmtHelp');
end;

{ property Read HelpContext: Integer }
procedure Exception_Read_HelpContext(var Value: Variant; Args: TArgs);
begin
  Value := Exception(Args.Obj).HelpContext;
end;

{ property Write HelpContext(Value: Integer) }
procedure Exception_Write_HelpContext(const Value: Variant; Args: TArgs);
begin
  Exception(Args.Obj).HelpContext := Value;
end;

{ property Read Message: string }
procedure Exception_Read_Message(var Value: Variant; Args: TArgs);
begin
  Value := Exception(Args.Obj).Message;
end;

{ property Write Message(Value: string) }
procedure Exception_Write_Message(const Value: Variant; Args: TArgs);
begin
  Exception(Args.Obj).Message := Value;
end;

  { EAbort }

  { EOutOfMemory }

  { EInOutError }

  { EIntError }

  { EDivByZero }

  { ERangeError }

  { EIntOverflow }

  { EMathError }

  { EInvalidOp }

  { EZeroDivide }

  { EOverflow }

  { EUnderflow }

  { EInvalidPointer }

  { EInvalidCast }

  { EConvertError }

  { EAccessViolation }

  { EPrivilege }

  { EStackOverflow }

  { EControlC }

  { EVariantError }

  { EPropReadOnly }

  { EPropWriteOnly }

  { EExternalException }

  { EAssertionFailed }

  { EAbstractError }

  { EIntfCastError }

  { EInvalidContainer }

  { EInvalidInsert }

  { EPackageError }

  { EWin32Error }


{ function AllocMem(Size: Cardinal): Pointer; }
procedure RAI2_AllocMem(var Value: Variant; Args: TArgs);
begin
  Value := P2V(AllocMem(Args.Values[0]));
end;

{$IFNDEF RA_D6H}
{ function NewStr(const S: string): PString; }
procedure RAI2_NewStr(var Value: Variant; Args: TArgs);
begin
  Value := P2V(NewStr(Args.Values[0]));
end;

{ procedure DisposeStr(P: PString); }
procedure RAI2_DisposeStr(var Value: Variant; Args: TArgs);
begin
  DisposeStr(V2P(Args.Values[0]));
end;

{ procedure AssignStr(var P: PString; const S: string); }
procedure RAI2_AssignStr(var Value: Variant; Args: TArgs);
begin
  AssignStr(PString(TVarData(Args.Values[0]).vPointer), Args.Values[1]);
end;

{ procedure AppendStr(var Dest: string; const S: string); }
procedure RAI2_AppendStr(var Value: Variant; Args: TArgs);
begin
  AppendStr(string(TVarData(Args.Values[0]).vString), Args.Values[1]);
end;
{$ENDIF RA_D6H} // {$IFNDEF RA_D6H}

{ function UpperCase(const S: string): string; }
procedure RAI2_UpperCase(var Value: Variant; Args: TArgs);
begin
  Value := UpperCase(Args.Values[0]);
end;

{ function LowerCase(const S: string): string; }
procedure RAI2_LowerCase(var Value: Variant; Args: TArgs);
begin
  Value := LowerCase(Args.Values[0]);
end;

{ function CompareStr(const S1, S2: string): Integer; }
procedure RAI2_CompareStr(var Value: Variant; Args: TArgs);
begin
  Value := CompareStr(Args.Values[0], Args.Values[1]);
end;

{$IFDEF RA_D3H}
{ function CompareMem(P1, P2: Pointer; Length: Integer): Boolean; }
procedure RAI2_CompareMem(var Value: Variant; Args: TArgs);
begin
  Value := CompareMem(V2P(Args.Values[0]), V2P(Args.Values[1]), Args.Values[2]);
end;
{$ENDIF RA_D3H}

{ function CompareText(const S1, S2: string): Integer; }
procedure RAI2_CompareText(var Value: Variant; Args: TArgs);
begin
  Value := CompareText(Args.Values[0], Args.Values[1]);
end;

{ function AnsiUpperCase(const S: string): string; }
procedure RAI2_AnsiUpperCase(var Value: Variant; Args: TArgs);
begin
  Value := AnsiUpperCase(Args.Values[0]);
end;

{ function AnsiLowerCase(const S: string): string; }
procedure RAI2_AnsiLowerCase(var Value: Variant; Args: TArgs);
begin
  Value := AnsiLowerCase(Args.Values[0]);
end;

{ function AnsiCompareStr(const S1, S2: string): Integer; }
procedure RAI2_AnsiCompareStr(var Value: Variant; Args: TArgs);
begin
  Value := AnsiCompareStr(Args.Values[0], Args.Values[1]);
end;

{ function AnsiCompareText(const S1, S2: string): Integer; }
procedure RAI2_AnsiCompareText(var Value: Variant; Args: TArgs);
begin
  Value := AnsiCompareText(Args.Values[0], Args.Values[1]);
end;

{$IFDEF RA_D3H}
{ function AnsiStrComp(S1, S2: PChar): Integer; }
procedure RAI2_AnsiStrComp(var Value: Variant; Args: TArgs);
begin
  Value := AnsiStrComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])));
end;

{ function AnsiStrIComp(S1, S2: PChar): Integer; }
procedure RAI2_AnsiStrIComp(var Value: Variant; Args: TArgs);
begin
  Value := AnsiStrIComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])));
end;

{ function AnsiStrLComp(S1, S2: PChar; MaxLen: Cardinal): Integer; }
procedure RAI2_AnsiStrLComp(var Value: Variant; Args: TArgs);
begin
  Value := AnsiStrLComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]);
end;

{ function AnsiStrLIComp(S1, S2: PChar; MaxLen: Cardinal): Integer; }
procedure RAI2_AnsiStrLIComp(var Value: Variant; Args: TArgs);
begin
  Value := AnsiStrLIComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]);
end;

{ function AnsiStrLower(Str: PChar): PChar; }
procedure RAI2_AnsiStrLower(var Value: Variant; Args: TArgs);
begin
  Value := string(AnsiStrLower(PChar(string(Args.Values[0]))));
end;

{ function AnsiStrUpper(Str: PChar): PChar; }
procedure RAI2_AnsiStrUpper(var Value: Variant; Args: TArgs);
begin
  Value := string(AnsiStrUpper(PChar(string(Args.Values[0]))));
end;

{ function AnsiLastChar(const S: string): PChar; }
procedure RAI2_AnsiLastChar(var Value: Variant; Args: TArgs);
begin
  Value := string(AnsiLastChar(Args.Values[0]));
end;

{ function AnsiStrLastChar(P: PChar): PChar; }
procedure RAI2_AnsiStrLastChar(var Value: Variant; Args: TArgs);
begin
  Value := string(AnsiStrLastChar(PChar(string(Args.Values[0]))));
end;
{$ENDIF RA_D3H}

{ function Trim(const S: string): string; }
procedure RAI2_Trim(var Value: Variant; Args: TArgs);
begin
  Value := Trim(Args.Values[0]);
end;

{ function TrimLeft(const S: string): string; }
procedure RAI2_TrimLeft(var Value: Variant; Args: TArgs);
begin
  Value := TrimLeft(Args.Values[0]);
end;

{ function TrimRight(const S: string): string; }
procedure RAI2_TrimRight(var Value: Variant; Args: TArgs);
begin
  Value := TrimRight(Args.Values[0]);
end;

{ function QuotedStr(const S: string): string; }
procedure RAI2_QuotedStr(var Value: Variant; Args: TArgs);
begin
  Value := QuotedStr(Args.Values[0]);
end;

{$IFDEF RA_D3H}
{ function AnsiQuotedStr(const S: string; Quote: Char): string; }
procedure RAI2_AnsiQuotedStr(var Value: Variant; Args: TArgs);
begin
  Value := AnsiQuotedStr(Args.Values[0], string(Args.Values[1])[1]);
end;

{ function AnsiExtractQuotedStr(var Src: PChar; Quote: Char): string; }
procedure RAI2_AnsiExtractQuotedStr(var Value: Variant; Args: TArgs);
begin
  Value := AnsiExtractQuotedStr(PChar(TVarData(Args.Values[0]).vPointer), string(Args.Values[1])[1]);
end;
{$ENDIF RA_D3H}

{ function AdjustLineBreaks(const S: string): string; }
procedure RAI2_AdjustLineBreaks(var Value: Variant; Args: TArgs);
begin
  Value := AdjustLineBreaks(Args.Values[0]);
end;

{ function IsValidIdent(const Ident: string): Boolean; }
procedure RAI2_IsValidIdent(var Value: Variant; Args: TArgs);
begin
  Value := IsValidIdent(Args.Values[0]);
end;

{ function IntToStr(Value: Integer): string; }
procedure RAI2_IntToStr(var Value: Variant; Args: TArgs);
begin
  Value := IntToStr(Args.Values[0]);
end;

{ function IntToHex(Value: Integer; Digits: Integer): string; }
procedure RAI2_IntToHex(var Value: Variant; Args: TArgs);
begin
  Value := IntToHex(Args.Values[0], Args.Values[1]);
end;

{ function StrToInt(const S: string): Integer; }
procedure RAI2_StrToInt(var Value: Variant; Args: TArgs);
begin
  Value := StrToInt(Args.Values[0]);
end;

{ function StrToIntDef(const S: string; Default: Integer): Integer; }
procedure RAI2_StrToIntDef(var Value: Variant; Args: TArgs);
begin
  Value := StrToIntDef(Args.Values[0], Args.Values[1]);
end;

{ function LoadStr(Ident: Integer): string; }
procedure RAI2_LoadStr(var Value: Variant; Args: TArgs);
begin
  Value := LoadStr(Args.Values[0]);
end;

(*
{ function FmtLoadStr(Ident: Integer; const Args: array of const): string; }
procedure RAI2_FmtLoadStr(var Value: Variant; Args: TArgs);
begin
  Value := FmtLoadStr(Args.Values[0], Args.Values[1]);
end;
*)

{ function FileOpen(const FileName: string; Mode: Integer): Integer; }
procedure RAI2_FileOpen(var Value: Variant; Args: TArgs);
begin
  Value := FileOpen(Args.Values[0], Args.Values[1]);
end;

{ function FileCreate(const FileName: string): Integer; }
procedure RAI2_FileCreate(var Value: Variant; Args: TArgs);
begin
{$IFDEF MSWINDOWS}
  Value := FileCreate(Args.Values[0]);
{$ENDIF MSWINDOWS}
{$IFDEF LINUX}
  Value := FileCreate(VarToStr(Args.Values[0]));
{$ENDIF LINUX}
end;

{ function FileRead(Handle: Integer; var Buffer; Count: Integer): Integer; }
procedure RAI2_FileRead(var Value: Variant; Args: TArgs);
begin
  Value := FileRead(Args.Values[0], TVarData(Args.Values[1]).vInteger, Args.Values[2]);
end;

{ function FileWrite(Handle: Integer; const Buffer; Count: Integer): Integer; }
procedure RAI2_FileWrite(var Value: Variant; Args: TArgs);
begin
  Value := FileWrite(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ function FileSeek(Handle, Offset, Origin: Integer): Integer; }
procedure RAI2_FileSeek(var Value: Variant; Args: TArgs);
begin
  Value := FileSeek(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ procedure FileClose(Handle: Integer); }
procedure RAI2_FileClose(var Value: Variant; Args: TArgs);
begin
  FileClose(Args.Values[0]);
end;

{ function FileAge(const FileName: string): Integer; }
procedure RAI2_FileAge(var Value: Variant; Args: TArgs);
begin
  Value := FileAge(Args.Values[0]);
end;

{ function FileExists(const FileName: string): Boolean; }
procedure RAI2_FileExists(var Value: Variant; Args: TArgs);
begin
  Value := FileExists(Args.Values[0]);
end;


{ function FindFirst(const Path: string; Attr: Integer; var F: TSearchRec): Integer; }
procedure RAI2_FindFirst(var Value: Variant; Args: TArgs);
begin
  Value := FindFirst(Args.Values[0], Args.Values[1], TSearchRec(V2R(Args.Values[2])^));
end;

{ function FindNext(var F: TSearchRec): Integer; }
procedure RAI2_FindNext(var Value: Variant; Args: TArgs);
begin
  Value := FindNext(TSearchRec(V2R(Args.Values[0])^));
end;

{ procedure FindClose(var F: TSearchRec); }
procedure RAI2_FindClose(var Value: Variant; Args: TArgs);
begin
  FindClose(TSearchRec(V2R(Args.Values[0])^));
end;


{ function FileGetDate(Handle: Integer): Integer; }
procedure RAI2_FileGetDate(var Value: Variant; Args: TArgs);
begin
  Value := FileGetDate(Args.Values[0]);
end;

{ function FileSetDate(Handle: Integer; Age: Integer): Integer; }
procedure RAI2_FileSetDate(var Value: Variant; Args: TArgs);
begin
{$IFDEF MSWINDOWS}
  Value := FileSetDate(Args.Values[0], Args.Values[1]);
{$ENDIF MSWINDOWS}
{$IFDEF LINUX}
  Value := FileSetDate(VarToStr(Args.Values[0]), Args.Values[1]);
{$ENDIF LINUX}
end;

{$IFDEF MSWINDOWS}
{ function FileGetAttr(const FileName: string): Integer; }
procedure RAI2_FileGetAttr(var Value: Variant; Args: TArgs);
begin
  Value := FileGetAttr(Args.Values[0]);
end;

{ function FileSetAttr(const FileName: string; Attr: Integer): Integer; }
procedure RAI2_FileSetAttr(var Value: Variant; Args: TArgs);
begin
  Value := FileSetAttr(Args.Values[0], Args.Values[1]);
end;
{$ENDIF MSWINDOWS}

{ function DeleteFile(const FileName: string): Boolean; }
procedure RAI2_DeleteFile(var Value: Variant; Args: TArgs);
begin
  Value := DeleteFile(Args.Values[0]);
end;

{ function RenameFile(const OldName, NewName: string): Boolean; }
procedure RAI2_RenameFile(var Value: Variant; Args: TArgs);
begin
  Value := RenameFile(Args.Values[0], Args.Values[1]);
end;

{ function ChangeFileExt(const FileName, Extension: string): string; }
procedure RAI2_ChangeFileExt(var Value: Variant; Args: TArgs);
begin
  Value := ChangeFileExt(Args.Values[0], Args.Values[1]);
end;

{ function ExtractFilePath(const FileName: string): string; }
procedure RAI2_ExtractFilePath(var Value: Variant; Args: TArgs);
begin
  Value := ExtractFilePath(Args.Values[0]);
end;

{ function ExtractFileDir(const FileName: string): string; }
procedure RAI2_ExtractFileDir(var Value: Variant; Args: TArgs);
begin
  Value := ExtractFileDir(Args.Values[0]);
end;

{ function ExtractFileDrive(const FileName: string): string; }
procedure RAI2_ExtractFileDrive(var Value: Variant; Args: TArgs);
begin
  Value := ExtractFileDrive(Args.Values[0]);
end;

{ function ExtractFileName(const FileName: string): string; }
procedure RAI2_ExtractFileName(var Value: Variant; Args: TArgs);
begin
  Value := ExtractFileName(Args.Values[0]);
end;

{ function ExtractFileExt(const FileName: string): string; }
procedure RAI2_ExtractFileExt(var Value: Variant; Args: TArgs);
begin
  Value := ExtractFileExt(Args.Values[0]);
end;

{ function ExpandFileName(const FileName: string): string; }
procedure RAI2_ExpandFileName(var Value: Variant; Args: TArgs);
begin
  Value := ExpandFileName(Args.Values[0]);
end;

{ function ExpandUNCFileName(const FileName: string): string; }
procedure RAI2_ExpandUNCFileName(var Value: Variant; Args: TArgs);
begin
  Value := ExpandUNCFileName(Args.Values[0]);
end;

{$IFDEF RA_D3H}
{ function ExtractRelativePath(const BaseName, DestName: string): string; }
procedure RAI2_ExtractRelativePath(var Value: Variant; Args: TArgs);
begin
  Value := ExtractRelativePath(Args.Values[0], Args.Values[1]);
end;
{$ENDIF RA_D3H}

{ function FileSearch(const Name, DirList: string): string; }
procedure RAI2_FileSearch(var Value: Variant; Args: TArgs);
begin
  Value := FileSearch(Args.Values[0], Args.Values[1]);
end;

{$IFDEF MSWINDOWS}
{ function DiskFree(Drive: Byte): Integer; }
procedure RAI2_DiskFree(var Value: Variant; Args: TArgs);
begin
  Value := Integer(DiskFree(Args.Values[0]));
end;

{ function DiskSize(Drive: Byte): Integer; }
procedure RAI2_DiskSize(var Value: Variant; Args: TArgs);
begin
  Value := Integer(DiskSize(Args.Values[0]));
end;
{$ENDIF MSWINDOWS}

{ function FileDateToDateTime(FileDate: Integer): TDateTime; }
procedure RAI2_FileDateToDateTime(var Value: Variant; Args: TArgs);
begin
  Value := FileDateToDateTime(Args.Values[0]);
end;

{ function DateTimeToFileDate(DateTime: TDateTime): Integer; }
procedure RAI2_DateTimeToFileDate(var Value: Variant; Args: TArgs);
begin
  Value := DateTimeToFileDate(Args.Values[0]);
end;

{ function GetCurrentDir: string; }
procedure RAI2_GetCurrentDir(var Value: Variant; Args: TArgs);
begin
  Value := GetCurrentDir;
end;

{ function SetCurrentDir(const Dir: string): Boolean; }
procedure RAI2_SetCurrentDir(var Value: Variant; Args: TArgs);
begin
  Value := SetCurrentDir(Args.Values[0]);
end;

{ function CreateDir(const Dir: string): Boolean; }
procedure RAI2_CreateDir(var Value: Variant; Args: TArgs);
begin
  Value := CreateDir(Args.Values[0]);
end;

{ function RemoveDir(const Dir: string): Boolean; }
procedure RAI2_RemoveDir(var Value: Variant; Args: TArgs);
begin
  Value := RemoveDir(Args.Values[0]);
end;

{ function StrLen(Str: PChar): Cardinal; }
procedure RAI2_StrLen(var Value: Variant; Args: TArgs);
begin
  Value := Integer(StrLen(PChar(string(Args.Values[0]))));
end;

{ function StrEnd(Str: PChar): PChar; }
procedure RAI2_StrEnd(var Value: Variant; Args: TArgs);
begin
  Value := string(StrEnd(PChar(string(Args.Values[0]))));
end;

{ function StrMove(Dest, Source: PChar; Count: Cardinal): PChar; }
procedure RAI2_StrMove(var Value: Variant; Args: TArgs);
begin
  Value := string(StrMove(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]));
end;

{ function StrCopy(Dest, Source: PChar): PChar; }
procedure RAI2_StrCopy(var Value: Variant; Args: TArgs);
begin
  Value := string(StrCopy(PChar(string(Args.Values[0])), PChar(string(Args.Values[1]))));
end;

{ function StrECopy(Dest, Source: PChar): PChar; }
procedure RAI2_StrECopy(var Value: Variant; Args: TArgs);
begin
  Value := string(StrECopy(PChar(string(Args.Values[0])), PChar(string(Args.Values[1]))));
end;

{ function StrLCopy(Dest, Source: PChar; MaxLen: Cardinal): PChar; }
procedure RAI2_StrLCopy(var Value: Variant; Args: TArgs);
begin
  Value := string(StrLCopy(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]));
end;

{ function StrPCopy(Dest: PChar; const Source: string): PChar; }
procedure RAI2_StrPCopy(var Value: Variant; Args: TArgs);
begin
  Value := string(StrPCopy(PChar(string(Args.Values[0])), Args.Values[1]));
end;

{ function StrPLCopy(Dest: PChar; const Source: string; MaxLen: Cardinal): PChar; }
procedure RAI2_StrPLCopy(var Value: Variant; Args: TArgs);
begin
  Value := string(StrPLCopy(PChar(string(Args.Values[0])), Args.Values[1], Args.Values[2]));
end;

{ function StrCat(Dest, Source: PChar): PChar; }
procedure RAI2_StrCat(var Value: Variant; Args: TArgs);
begin
  Value := string(StrCat(PChar(string(Args.Values[0])), PChar(string(Args.Values[1]))));
end;

{ function StrLCat(Dest, Source: PChar; MaxLen: Cardinal): PChar; }
procedure RAI2_StrLCat(var Value: Variant; Args: TArgs);
begin
  Value := string(StrLCat(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]));
end;

{ function StrComp(Str1, Str2: PChar): Integer; }
procedure RAI2_StrComp(var Value: Variant; Args: TArgs);
begin
  Value := StrComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])));
end;

{ function StrIComp(Str1, Str2: PChar): Integer; }
procedure RAI2_StrIComp(var Value: Variant; Args: TArgs);
begin
  Value := StrIComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])));
end;

{ function StrLComp(Str1, Str2: PChar; MaxLen: Cardinal): Integer; }
procedure RAI2_StrLComp(var Value: Variant; Args: TArgs);
begin
  Value := StrLComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]);
end;

{ function StrLIComp(Str1, Str2: PChar; MaxLen: Cardinal): Integer; }
procedure RAI2_StrLIComp(var Value: Variant; Args: TArgs);
begin
  Value := StrLIComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]);
end;

{ function StrScan(Str: PChar; Chr: Char): PChar; }
procedure RAI2_StrScan(var Value: Variant; Args: TArgs);
begin
  Value := string(StrScan(PChar(string(Args.Values[0])), string(Args.Values[1])[1]));
end;

{ function StrRScan(Str: PChar; Chr: Char): PChar; }
procedure RAI2_StrRScan(var Value: Variant; Args: TArgs);
begin
  Value := string(StrRScan(PChar(string(Args.Values[0])), string(Args.Values[1])[1]));
end;

{ function StrPos(Str1, Str2: PChar): PChar; }
procedure RAI2_StrPos(var Value: Variant; Args: TArgs);
begin
  Value := string(StrPos(PChar(string(Args.Values[0])), PChar(string(Args.Values[1]))));
end;

{ function StrUpper(Str: PChar): PChar; }
procedure RAI2_StrUpper(var Value: Variant; Args: TArgs);
begin
  Value := string(StrUpper(PChar(string(Args.Values[0]))));
end;

{ function StrLower(Str: PChar): PChar; }
procedure RAI2_StrLower(var Value: Variant; Args: TArgs);
begin
  Value := string(StrLower(PChar(string(Args.Values[0]))));
end;

{ function StrPas(Str: PChar): string; }
procedure RAI2_StrPas(var Value: Variant; Args: TArgs);
begin
  Value := StrPas(PChar(string(Args.Values[0])));
end;

{ function StrAlloc(Size: Cardinal): PChar; }
procedure RAI2_StrAlloc(var Value: Variant; Args: TArgs);
begin
  Value := string(StrAlloc(Args.Values[0]));
end;

{ function StrBufSize(Str: PChar): Cardinal; }
procedure RAI2_StrBufSize(var Value: Variant; Args: TArgs);
begin
  Value := Integer(StrBufSize(PChar(string(Args.Values[0]))));
end;

{ function StrNew(Str: PChar): PChar; }
procedure RAI2_StrNew(var Value: Variant; Args: TArgs);
begin
  Value := string(StrNew(PChar(string(Args.Values[0]))));
end;

{ procedure StrDispose(Str: PChar); }
procedure RAI2_StrDispose(var Value: Variant; Args: TArgs);
begin
  StrDispose(PChar(string(Args.Values[0])));
end;

{ function Format(const Format: string; const Args: array of const): string; }
procedure RAI2_Format(var Value: Variant; Args: TArgs);
begin
  Args.OpenArray(1);
  Value := Format(Args.Values[0], Slice(Args.OA^, Args.OAS));
end;

{ procedure FmtStr(var Result: string; const Format: string; const Args: array of const); }
procedure RAI2_FmtStr(var Value: Variant; Args: TArgs);
begin
  Args.OpenArray(2);
  FmtStr(string(TVarData(Args.Values[0]).vString), Args.Values[1], Slice(Args.OA^, Args.OAS));
end;

{ function StrFmt(Buffer, Format: PChar; const Args: array of const): PChar; }
procedure RAI2_StrFmt(var Value: Variant; Args: TArgs);
begin
  Args.OpenArray(2);
  Value := string(StrFmt(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Slice(Args.OA^, Args.OAS)));
end;

{ function StrLFmt(Buffer: PChar; MaxLen: Cardinal; Format: PChar; const Args: array of const): PChar; }
procedure RAI2_StrLFmt(var Value: Variant; Args: TArgs);
begin
  Args.OpenArray(3);
  Value := string(StrLFmt(PChar(string(Args.Values[0])), Args.Values[1], PChar(string(Args.Values[2])), Slice(Args.OA^, Args.OAS)));
end;

{ function FormatBuf(var Buffer; BufLen: Cardinal; const Format; FmtLen: Cardinal; const Args: array of const): Cardinal; }
procedure RAI2_FormatBuf(var Value: Variant; Args: TArgs);
begin
  Args.OpenArray(4);
  Value := Integer(FormatBuf(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3], Slice(Args.OA^, Args.OAS)));
end;

{ function FloatToStr(Value: Extended): string; }
procedure RAI2_FloatToStr(var Value: Variant; Args: TArgs);
begin
  Value := FloatToStr(Args.Values[0]);
end;

{ function CurrToStr(Value: Currency): string; }
procedure RAI2_CurrToStr(var Value: Variant; Args: TArgs);
begin
  Value := CurrToStr(Args.Values[0]);
end;

{ function FloatToStrF(Value: Extended; Format: TFloatFormat; Precision, Digits: Integer): string; }
procedure RAI2_FloatToStrF(var Value: Variant; Args: TArgs);
begin
  Value := FloatToStrF(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3]);
end;

{ function CurrToStrF(Value: Currency; Format: TFloatFormat; Digits: Integer): string; }
procedure RAI2_CurrToStrF(var Value: Variant; Args: TArgs);
begin
  Value := CurrToStrF(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

(*
{ function FloatToText(Buffer: PChar; const Value; ValueType: TFloatValue; Format: TFloatFormat; Precision, Digits: Integer): Integer; }
procedure RAI2_FloatToText(var Value: Variant; Args: TArgs);
begin
  Value := FloatToText(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2], Args.Values[3], Args.Values[4], Args.Values[5]);
end;
*)

{ function FormatFloat(const Format: string; Value: Extended): string; }
procedure RAI2_FormatFloat(var Value: Variant; Args: TArgs);
begin
  Value := FormatFloat(Args.Values[0], Args.Values[1]);
end;

{ function FormatCurr(const Format: string; Value: Currency): string; }
procedure RAI2_FormatCurr(var Value: Variant; Args: TArgs);
begin
  Value := FormatCurr(Args.Values[0], Args.Values[1]);
end;

(*
{ function FloatToTextFmt(Buffer: PChar; const Value; ValueType: TFloatValue; Format: PChar): Integer; }
procedure RAI2_FloatToTextFmt(var Value: Variant; Args: TArgs);
begin
  Value := FloatToTextFmt(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2], PChar(string(Args.Values[3])));
end;
*)

{ function StrToFloat(const S: string): Extended; }
procedure RAI2_StrToFloat(var Value: Variant; Args: TArgs);
begin
  Value := StrToFloat(Args.Values[0]);
end;

{ function StrToCurr(const S: string): Currency; }
procedure RAI2_StrToCurr(var Value: Variant; Args: TArgs);
begin
  Value := StrToCurr(Args.Values[0]);
end;

(*
{ function TextToFloat(Buffer: PChar; var Value; ValueType: TFloatValue): Boolean; }
procedure RAI2_TextToFloat(var Value: Variant; Args: TArgs);
begin
  Value := TextToFloat(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]);
end;
*)
(* need record
{ procedure FloatToDecimal(var Result: TFloatRec; const Value; ValueType: TFloatValue; Precision, Decimals: Integer); }
procedure RAI2_FloatToDecimal(var Value: Variant; Args: TArgs);
begin
  FloatToDecimal(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3], Args.Values[4]);
end;
*)

(* need record
{ function DateTimeToTimeStamp(DateTime: TDateTime): TTimeStamp; }
procedure RAI2_DateTimeToTimeStamp(var Value: Variant; Args: TArgs);
begin
  Value := DateTimeToTimeStamp(Args.Values[0]);
end;

{ function TimeStampToDateTime(const TimeStamp: TTimeStamp): TDateTime; }
procedure RAI2_TimeStampToDateTime(var Value: Variant; Args: TArgs);
begin
  Value := TimeStampToDateTime(Args.Values[0]);
end;

{ function MSecsToTimeStamp(MSecs: Comp): TTimeStamp; }
procedure RAI2_MSecsToTimeStamp(var Value: Variant; Args: TArgs);
begin
  Value := MSecsToTimeStamp(Args.Values[0]);
end;

{ function TimeStampToMSecs(const TimeStamp: TTimeStamp): Comp; }
procedure RAI2_TimeStampToMSecs(var Value: Variant; Args: TArgs);
begin
  Value := TimeStampToMSecs(Args.Values[0]);
end;
*)

{ function EncodeDate(Year, Month, Day: Word): TDateTime; }
procedure RAI2_EncodeDate(var Value: Variant; Args: TArgs);
begin
  Value := EncodeDate(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime; }
procedure RAI2_EncodeTime(var Value: Variant; Args: TArgs);
begin
  Value := EncodeTime(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3]);
end;

{ procedure DecodeDate(Date: TDateTime; var Year, Month, Day: Word); }
procedure RAI2_DecodeDate(var Value: Variant; Args: TArgs);
begin
  DecodeDate(Args.Values[0], Word(TVarData(Args.Values[1]).vSmallint), Word(TVarData(Args.Values[2]).vSmallint), Word(TVarData(Args.Values[3]).vSmallint));
end;

{ procedure DecodeTime(Time: TDateTime; var Hour, Min, Sec, MSec: Word); }
procedure RAI2_DecodeTime(var Value: Variant; Args: TArgs);
begin
  DecodeTime(Args.Values[0], Word(TVarData(Args.Values[1]).vSmallint), Word(TVarData(Args.Values[2]).vSmallint), Word(TVarData(Args.Values[3]).vSmallint), Word(TVarData(Args.Values[4]).vSmallint));
end;

(* need record
{ procedure DateTimeToSystemTime(DateTime: TDateTime; var SystemTime: TSystemTime); }
procedure RAI2_DateTimeToSystemTime(var Value: Variant; Args: TArgs);
begin
  DateTimeToSystemTime(Args.Values[0], Args.Values[1]);
end;

{ function SystemTimeToDateTime(const SystemTime: TSystemTime): TDateTime; }
procedure RAI2_SystemTimeToDateTime(var Value: Variant; Args: TArgs);
begin
  Value := SystemTimeToDateTime(Args.Values[0]);
end;
*)

{ function DayOfWeek(Date: TDateTime): Integer; }
procedure RAI2_DayOfWeek(var Value: Variant; Args: TArgs);
begin
  Value := DayOfWeek(Args.Values[0]);
end;

{ function Date: TDateTime; }
procedure RAI2_Date(var Value: Variant; Args: TArgs);
begin
  Value := Date;
end;

{ function Time: TDateTime; }
procedure RAI2_Time(var Value: Variant; Args: TArgs);
begin
  Value := Time;
end;

{ function Now: TDateTime; }
procedure RAI2_Now(var Value: Variant; Args: TArgs);
begin
  Value := Now;
end;

{$IFDEF RA_D3H}
{ function IncMonth(const Date: TDateTime; NumberOfMonths: Integer): TDateTime; }
procedure RAI2_IncMonth(var Value: Variant; Args: TArgs);
begin
  Value := IncMonth(Args.Values[0], Args.Values[1]);
end;

{ function IsLeapYear(Year: Word): Boolean; }
procedure RAI2_IsLeapYear(var Value: Variant; Args: TArgs);
begin
  Value := IsLeapYear(Args.Values[0]);
end;
{$ENDIF RA_D3H}

{ function DateToStr(Date: TDateTime): string; }
procedure RAI2_DateToStr(var Value: Variant; Args: TArgs);
begin
  Value := DateToStr(Args.Values[0]);
end;

{ function TimeToStr(Time: TDateTime): string; }
procedure RAI2_TimeToStr(var Value: Variant; Args: TArgs);
begin
  Value := TimeToStr(Args.Values[0]);
end;

{ function DateTimeToStr(DateTime: TDateTime): string; }
procedure RAI2_DateTimeToStr(var Value: Variant; Args: TArgs);
begin
  Value := DateTimeToStr(Args.Values[0]);
end;

{ function StrToDate(const S: string): TDateTime; }
procedure RAI2_StrToDate(var Value: Variant; Args: TArgs);
begin
  Value := StrToDate(Args.Values[0]);
end;

{ function StrToTime(const S: string): TDateTime; }
procedure RAI2_StrToTime(var Value: Variant; Args: TArgs);
begin
  Value := StrToTime(Args.Values[0]);
end;

{ function StrToDateTime(const S: string): TDateTime; }
procedure RAI2_StrToDateTime(var Value: Variant; Args: TArgs);
begin
  Value := StrToDateTime(Args.Values[0]);
end;

{ function FormatDateTime(const Format: string; DateTime: TDateTime): string; }
procedure RAI2_FormatDateTime(var Value: Variant; Args: TArgs);
begin
  Value := FormatDateTime(Args.Values[0], Args.Values[1]);
end;

{ procedure DateTimeToString(var Result: string; const Format: string; DateTime: TDateTime); }
procedure RAI2_DateTimeToString(var Value: Variant; Args: TArgs);
begin
  DateTimeToString(string(TVarData(Args.Values[0]).vString), Args.Values[1], Args.Values[2]);
end;

{ function SysErrorMessage(ErrorCode: Integer): string; }
procedure RAI2_SysErrorMessage(var Value: Variant; Args: TArgs);
begin
  Value := SysErrorMessage(Args.Values[0]);
end;

{ function GetLocaleStr(Locale, LocaleType: Integer; const Default: string): string; }
procedure RAI2_GetLocaleStr(var Value: Variant; Args: TArgs);
begin
  Value := GetLocaleStr(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ function GetLocaleChar(Locale, LocaleType: Integer; Default: Char): Char; }
procedure RAI2_GetLocaleChar(var Value: Variant; Args: TArgs);
begin
  Value := GetLocaleChar(Args.Values[0], Args.Values[1], string(Args.Values[2])[1]);
end;

{ procedure GetFormatSettings; }
procedure RAI2_GetFormatSettings(var Value: Variant; Args: TArgs);
begin
  GetFormatSettings;
end;

{ function ExceptObject: TObject; }
procedure RAI2_ExceptObject(var Value: Variant; Args: TArgs);
begin
  Value := O2V(ExceptObject);
end;

{ function ExceptAddr: Pointer; }
procedure RAI2_ExceptAddr(var Value: Variant; Args: TArgs);
begin
  Value := P2V(ExceptAddr);
end;

{$IFDEF RA_D3H}
{ function ExceptionErrorMessage(ExceptObject: TObject; ExceptAddr: Pointer; Buffer: PChar; Size: Integer): Integer; }
procedure RAI2_ExceptionErrorMessage(var Value: Variant; Args: TArgs);
begin
  Value := ExceptionErrorMessage(V2O(Args.Values[0]), V2P(Args.Values[1]), PChar(string(Args.Values[2])), Args.Values[3]);
end;
{$ENDIF RA_D3H}

{ procedure ShowException(ExceptObject: TObject; ExceptAddr: Pointer); }
procedure RAI2_ShowException(var Value: Variant; Args: TArgs);
begin
  ShowException(V2O(Args.Values[0]), V2P(Args.Values[1]));
end;

{ procedure Abort; }
procedure RAI2_Abort(var Value: Variant; Args: TArgs);
begin
  Abort;
end;

{ procedure OutOfMemoryError; }
procedure RAI2_OutOfMemoryError(var Value: Variant; Args: TArgs);
begin
  OutOfMemoryError;
end;

{ procedure Beep; }
procedure RAI2_Beep(var Value: Variant; Args: TArgs);
begin
  Beep;
end;

{$IFDEF RA_D3H}
{ function ByteType(const S: string; Index: Integer): TMbcsByteType; }
procedure RAI2_ByteType(var Value: Variant; Args: TArgs);
begin
  Value := ByteType(Args.Values[0], Args.Values[1]);
end;

{ function StrByteType(Str: PChar; Index: Cardinal): TMbcsByteType; }
procedure RAI2_StrByteType(var Value: Variant; Args: TArgs);
begin
  Value := StrByteType(PChar(string(Args.Values[0])), Args.Values[1]);
end;

{ function ByteToCharLen(const S: string; MaxLen: Integer): Integer; }
procedure RAI2_ByteToCharLen(var Value: Variant; Args: TArgs);
begin
  Value := ByteToCharLen(Args.Values[0], Args.Values[1]);
end;

{ function CharToByteLen(const S: string; MaxLen: Integer): Integer; }
procedure RAI2_CharToByteLen(var Value: Variant; Args: TArgs);
begin
  Value := CharToByteLen(Args.Values[0], Args.Values[1]);
end;

{ function ByteToCharIndex(const S: string; Index: Integer): Integer; }
procedure RAI2_ByteToCharIndex(var Value: Variant; Args: TArgs);
begin
  Value := ByteToCharIndex(Args.Values[0], Args.Values[1]);
end;

{ function CharToByteIndex(const S: string; Index: Integer): Integer; }
procedure RAI2_CharToByteIndex(var Value: Variant; Args: TArgs);
begin
  Value := CharToByteIndex(Args.Values[0], Args.Values[1]);
end;

{ function IsPathDelimiter(const S: string; Index: Integer): Boolean; }
procedure RAI2_IsPathDelimiter(var Value: Variant; Args: TArgs);
begin
  Value := IsPathDelimiter(Args.Values[0], Args.Values[1]);
end;

{ function IsDelimiter(const Delimiters, S: string; Index: Integer): Boolean; }
procedure RAI2_IsDelimiter(var Value: Variant; Args: TArgs);
begin
  Value := IsDelimiter(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ function LastDelimiter(const Delimiters, S: string): Integer; }
procedure RAI2_LastDelimiter(var Value: Variant; Args: TArgs);
begin
  Value := LastDelimiter(Args.Values[0], Args.Values[1]);
end;

{ function AnsiCompareFileName(const S1, S2: string): Integer; }
procedure RAI2_AnsiCompareFileName(var Value: Variant; Args: TArgs);
begin
  Value := AnsiCompareFileName(Args.Values[0], Args.Values[1]);
end;

{ function AnsiLowerCaseFileName(const S: string): string; }
procedure RAI2_AnsiLowerCaseFileName(var Value: Variant; Args: TArgs);
begin
  Value := AnsiLowerCaseFileName(Args.Values[0]);
end;

{ function AnsiUpperCaseFileName(const S: string): string; }
procedure RAI2_AnsiUpperCaseFileName(var Value: Variant; Args: TArgs);
begin
  Value := AnsiUpperCaseFileName(Args.Values[0]);
end;

{ function AnsiPos(const Substr, S: string): Integer; }
procedure RAI2_AnsiPos(var Value: Variant; Args: TArgs);
begin
  Value := AnsiPos(Args.Values[0], Args.Values[1]);
end;

{ function AnsiStrPos(Str, SubStr: PChar): PChar; }
procedure RAI2_AnsiStrPos(var Value: Variant; Args: TArgs);
begin
  Value := string(AnsiStrPos(PChar(string(Args.Values[0])), PChar(string(Args.Values[1]))));
end;

{ function AnsiStrRScan(Str: PChar; Chr: Char): PChar; }
procedure RAI2_AnsiStrRScan(var Value: Variant; Args: TArgs);
begin
  Value := string(AnsiStrRScan(PChar(string(Args.Values[0])), string(Args.Values[1])[1]));
end;

{ function AnsiStrScan(Str: PChar; Chr: Char): PChar; }
procedure RAI2_AnsiStrScan(var Value: Variant; Args: TArgs);
begin
  Value := string(AnsiStrScan(PChar(string(Args.Values[0])), string(Args.Values[1])[1]));
end;

{ function LoadPackage(const Name: string): HMODULE; }
procedure RAI2_LoadPackage(var Value: Variant; Args: TArgs);
begin
  Value := Integer(LoadPackage(Args.Values[0]));
end;

{ procedure UnloadPackage(Module: HMODULE); }
procedure RAI2_UnloadPackage(var Value: Variant; Args: TArgs);
begin
  UnloadPackage(Args.Values[0]);
end;

{$IFDEF MSWINDOWS}
{ procedure RaiseLastWin32Error; }
procedure RAI2_RaiseLastWin32Error(var Value: Variant; Args: TArgs);
begin
  RaiseLastWin32Error;
end;

{ function Win32Check(RetVal: BOOL): BOOL; }
procedure RAI2_Win32Check(var Value: Variant; Args: TArgs);
begin
  Value := Win32Check(Args.Values[0]);
end;
{$ENDIF MSWINDOWS}
{$ENDIF RA_D3H}


{ regional options }

(*
{ read CurrencyString: string }
procedure RAI2_Read_CurrencyString(var Value: Variant; Args: TArgs);
begin
  Value := CurrencyString;
end;

{ write CurrencyString: string }
procedure RAI2_Write_CurrencyString(var Value: Variant; Args: TArgs);
begin
  CurrencyString := Value;
end;

{ read CurrencyFormat: Byte }
procedure RAI2_Read_CurrencyFormat(var Value: Variant; Args: TArgs);
begin
  Value := CurrencyFormat;
end;

{ write CurrencyFormat: Byte }
procedure RAI2_Write_CurrencyFormat(var Value: Variant; Args: TArgs);
begin
  CurrencyFormat := Value;
end;

{ read NegCurrFormat: Byte }
procedure RAI2_Read_NegCurrFormat(var Value: Variant; Args: TArgs);
begin
  Value := NegCurrFormat;
end;

{ write NegCurrFormat: Byte }
procedure RAI2_Write_NegCurrFormat(var Value: Variant; Args: TArgs);
begin
  NegCurrFormat := Value;
end;

{ read ThousandSeparator }
procedure RAI2_Read_ThousandSeparator(var Value: Variant; Args: TArgs);
begin
  Value := ThousandSeparator;
end;

{ write ThousandSeparator }
procedure RAI2_Write_ThousandSeparator(var Value: Variant; Args: TArgs);
begin
  ThousandSeparator := string(Value)[1];
end;

{ read DecimalSeparator }
procedure RAI2_Read_DecimalSeparator(var Value: Variant; Args: TArgs);
begin
  Value := DecimalSeparator;
end;

{ write DecimalSeparator }
procedure RAI2_Write_DecimalSeparator(var Value: Variant; Args: TArgs);
begin
  DecimalSeparator := string(Value)[1];
end;

{ read CurrencyDecimals }
procedure RAI2_Read_CurrencyDecimals(var Value: Variant; Args: TArgs);
begin
  Value := CurrencyDecimals;
end;

{ write CurrencyDecimals }
procedure RAI2_Write_CurrencyDecimals(var Value: Variant; Args: TArgs);
begin
  CurrencyDecimals := Value;
end;

{ read DateSeparator }
procedure RAI2_Read_DateSeparator(var Value: Variant; Args: TArgs);
begin
  Value := DateSeparator;
end;

{ write DateSeparator }
procedure RAI2_Write_DateSeparator(var Value: Variant; Args: TArgs);
begin
  DateSeparator := string(Value)[1];
end;

{ read ShortDateFormat }
procedure RAI2_Read_ShortDateFormat(var Value: Variant; Args: TArgs);
begin
  Value := ShortDateFormat;
end;

{ write ShortDateFormat }
procedure RAI2_Write_ShortDateFormat(var Value: Variant; Args: TArgs);
begin
  ShortDateFormat := Value;
end;

{ read LongDateFormat }
procedure RAI2_Read_LongDateFormat(var Value: Variant; Args: TArgs);
begin
  Value := LongDateFormat;
end;

{ write LongDateFormat }
procedure RAI2_Write_LongDateFormat(var Value: Variant; Args: TArgs);
begin
  LongDateFormat := Value;
end;

{ read TimeSeparator }
procedure RAI2_Read_TimeSeparator(var Value: Variant; Args: TArgs);
begin
  Value := TimeSeparator;
end;

{ write TimeSeparator }
procedure RAI2_Write_TimeSeparator(var Value: Variant; Args: TArgs);
begin
  TimeSeparator := string(Value)[1];
end;

{ read TimeAMString }
procedure RAI2_Read_TimeAMString(var Value: Variant; Args: TArgs);
begin
  Value := TimeAMString;
end;

{ write TimeAMString }
procedure RAI2_Write_TimeAMString(var Value: Variant; Args: TArgs);
begin
  TimeAMString := Value;
end;

{ read TimePMString }
procedure RAI2_Read_TimePMString(var Value: Variant; Args: TArgs);
begin
  Value := TimePMString;
end;

{ write TimePMString }
procedure RAI2_Write_TimePMString(var Value: Variant; Args: TArgs);
begin
  TimePMString := Value;
end;

{ read ShortTimeFormat }
procedure RAI2_Read_ShortTimeFormat(var Value: Variant; Args: TArgs);
begin
  Value := ShortTimeFormat;
end;

{ write ShortTimeFormat }
procedure RAI2_Write_ShortTimeFormat(var Value: Variant; Args: TArgs);
begin
  ShortTimeFormat := Value;
end;

{ read LongTimeFormat }
procedure RAI2_Read_LongTimeFormat(var Value: Variant; Args: TArgs);
begin
  Value := LongTimeFormat;
end;

{ write LongTimeFormat }
procedure RAI2_Write_LongTimeFormat(var Value: Variant; Args: TArgs);
begin
  LongTimeFormat := Value;
end;

{$IFDEF RA_D4H}
{ read TwoDigitYearCenturyWindow }
procedure RAI2_Read_TwoDigitYearCenturyWindow(var Value: Variant; Args: TArgs);
begin
  Value := TwoDigitYearCenturyWindow;
end;

{ write TwoDigitYearCenturyWindow }
procedure RAI2_Write_TwoDigitYearCenturyWindow(var Value: Variant; Args: TArgs);
begin
  TwoDigitYearCenturyWindow := Value;
end;

{ read ListSeparator }
procedure RAI2_Read_ListSeparator(var Value: Variant; Args: TArgs);
begin
  Value := ListSeparator;
end;

{ write ListSeparator }
procedure RAI2_Write_ListSeparator(var Value: Variant; Args: TArgs);
begin
  ListSeparator := string(Args.Values[0])[1];
end;
{$ENDIF RA_D4H}

{ read ShortMonthNames }
procedure RAI2_Read_ShortMonthNames(var Value: Variant; Args: TArgs);
begin
  Value := ShortMonthNames[Integer(Args.Values[0])];
end;

{ write ShortMonthNames }
procedure RAI2_Write_ShortMonthNames(var Value: Variant; Args: TArgs);
begin
  ShortMonthNames[Integer(Args.Values[0])] := Value;
end;

{ read LongMonthNames }
procedure RAI2_Read_LongMonthNames(var Value: Variant; Args: TArgs);
begin
  Value := LongMonthNames[Integer(Args.Values[0])];
end;

{ write LongMonthNames }
procedure RAI2_Write_LongMonthNames(var Value: Variant; Args: TArgs);
begin
  LongMonthNames[Integer(Args.Values[0])] := Value;
end;

{ read ShortDayNames }
procedure RAI2_Read_ShortDayNames(var Value: Variant; Args: TArgs);
begin
  Value := ShortDayNames[Integer(Args.Values[0])];
end;

{ write ShortDayNames }
procedure RAI2_Write_ShortDayNames(var Value: Variant; Args: TArgs);
begin
  ShortDayNames[Integer(Args.Values[0])] := Value;
end;

{ read LongDayNames }
procedure RAI2_Read_LongDayNames(var Value: Variant; Args: TArgs);
begin
  Value := LongDayNames[Integer(Args.Values[0])];
end;

{ write LongDayNames }
procedure RAI2_Write_LongDayNames(var Value: Variant; Args: TArgs);
begin
  LongDayNames[Integer(Args.Values[0])] := Value;
end;

{$IFDEF RA_D4H}
{ read EraNames }
procedure RAI2_Read_EraNames(var Value: Variant; Args: TArgs);
begin
  Value := EraNames[Integer(Args.Values[0])];
end;

{ write EraNames }
procedure RAI2_Write_EraNames(var Value: Variant; Args: TArgs);
begin
  EraNames[Integer(Args.Values[0])] := Value;
end;

{ read EraYearOffsets }
procedure RAI2_Read_EraYearOffsets(var Value: Variant; Args: TArgs);
begin
  Value := EraYearOffsets[Integer(Args.Values[0])];
end;

{ write EraYearOffsets }
procedure RAI2_Write_EraYearOffsets(var Value: Variant; Args: TArgs);
begin
  EraYearOffsets[Integer(Args.Values[0])] := Value;
end;
{$ENDIF RA_D4H}
*)

type
  PSearchRec = ^TSearchRec;

procedure RAI2_NewTSearchRec(var Value: Pointer);
begin
  New(PSearchRec(Value));
end;

procedure RAI2_DisposeTSearchRec(const Value: Pointer);
begin
  Dispose(PSearchRec(Value));
end;

procedure RegisterRAI2Adapter(RAI2Adapter: TRAI2Adapter);
begin
  with RAI2Adapter do
  begin
   { Exception }
    AddClass('SysUtils', Exception, 'Exception');
    AddGet(Exception, 'Create', Exception_Create, 1, [varEmpty], varEmpty);
    AddGet(Exception, 'CreateFmt', Exception_CreateFmt, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(Exception, 'CreateRes', Exception_CreateRes, 1, [varEmpty], varEmpty);
    AddGet(Exception, 'CreateResFmt', Exception_CreateResFmt, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(Exception, 'CreateHelp', Exception_CreateHelp, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(Exception, 'CreateFmtHelp', Exception_CreateFmtHelp, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(Exception, 'CreateResHelp', Exception_CreateResHelp, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(Exception, 'CreateResFmtHelp', Exception_CreateResFmtHelp, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(Exception, 'HelpContext', Exception_Read_HelpContext, 0, [0], varEmpty);
    AddSet(Exception, 'HelpContext', Exception_Write_HelpContext, 0, [0]);
    AddGet(Exception, 'Message', Exception_Read_Message, 0, [0], varEmpty);
    AddSet(Exception, 'Message', Exception_Write_Message, 0, [0]);
   { EAbort }
    AddClass('SysUtils', EAbort, 'EAbort');
   { EOutOfMemory }
    AddClass('SysUtils', EOutOfMemory, 'EOutOfMemory');
   { EInOutError }
    AddClass('SysUtils', EInOutError, 'EInOutError');
   { EIntError }
    AddClass('SysUtils', EIntError, 'EIntError');
   { EDivByZero }
    AddClass('SysUtils', EDivByZero, 'EDivByZero');
   { ERangeError }
    AddClass('SysUtils', ERangeError, 'ERangeError');
   { EIntOverflow }
    AddClass('SysUtils', EIntOverflow, 'EIntOverflow');
   { EMathError }
    AddClass('SysUtils', EMathError, 'EMathError');
   { EInvalidOp }
    AddClass('SysUtils', EInvalidOp, 'EInvalidOp');
   { EZeroDivide }
    AddClass('SysUtils', EZeroDivide, 'EZeroDivide');
   { EOverflow }
    AddClass('SysUtils', EOverflow, 'EOverflow');
   { EUnderflow }
    AddClass('SysUtils', EUnderflow, 'EUnderflow');
   { EInvalidPointer }
    AddClass('SysUtils', EInvalidPointer, 'EInvalidPointer');
   { EInvalidCast }
    AddClass('SysUtils', EInvalidCast, 'EInvalidCast');
   { EConvertError }
    AddClass('SysUtils', EConvertError, 'EConvertError');
   { EAccessViolation }
    AddClass('SysUtils', EAccessViolation, 'EAccessViolation');
   { EPrivilege }
    AddClass('SysUtils', EPrivilege, 'EPrivilege');
   {$IFNDEF RA_D6H}
   { EStackOverflow }
    AddClass('SysUtils', EStackOverflow, 'EStackOverflow');
   {$ENDIF RA_D6H}
   { EControlC }
    AddClass('SysUtils', EControlC, 'EControlC');
   { EVariantError }
    AddClass('SysUtils', EVariantError, 'EVariantError');
   { EPropReadOnly }
    AddClass('SysUtils', EPropReadOnly, 'EPropReadOnly');
   { EPropWriteOnly }
    AddClass('SysUtils', EPropWriteOnly, 'EPropWriteOnly');
   { EExternalException }
    AddClass('SysUtils', EExternalException, 'EExternalException');
   {$IFDEF RA_D3H}
   { EAssertionFailed }
    AddClass('SysUtils', EAssertionFailed, 'EAssertionFailed');
   {$IFNDEF PC_MAPPED_EXCEPTIONS} // Linux define symbol
   { EAbstractError }
    AddClass('SysUtils', EAbstractError, 'EAbstractError');
   {$ENDIF}
   { EIntfCastError }
    AddClass('SysUtils', EIntfCastError, 'EIntfCastError');
   { EInvalidContainer }
    AddClass('SysUtils', EInvalidContainer, 'EInvalidContainer');
   { EInvalidInsert }
    AddClass('SysUtils', EInvalidInsert, 'EInvalidInsert');
   { EPackageError }
    AddClass('SysUtils', EPackageError, 'EPackageError');
   {$IFDEF MSWINDOWS}
   { EWin32Error }
    AddClass('SysUtils', EWin32Error, 'EWin32Error');
   {$ENDIF MSWINDOWS}
   {$ENDIF RA_D3H}

    AddFun('SysUtils', 'AllocMem', RAI2_AllocMem, 1, [varEmpty], varEmpty);
   {$IFNDEF RA_D6H}
    AddFun('SysUtils', 'NewStr', RAI2_NewStr, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'DisposeStr', RAI2_DisposeStr, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'AssignStr', RAI2_AssignStr, 2, [varByRef, varEmpty], varEmpty);
    AddFun('SysUtils', 'AppendStr', RAI2_AppendStr, 2, [varByRef, varEmpty], varEmpty);
   {$ENDIF RA_D6H}
    AddFun('SysUtils', 'UpperCase', RAI2_UpperCase, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'LowerCase', RAI2_LowerCase, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'CompareStr', RAI2_CompareStr, 2, [varEmpty, varEmpty], varEmpty);
   {$IFDEF RA_D3H}
    AddFun('SysUtils', 'CompareMem', RAI2_CompareMem, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
   {$ENDIF RA_D3H}
    AddFun('SysUtils', 'CompareText', RAI2_CompareText, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiUpperCase', RAI2_AnsiUpperCase, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiLowerCase', RAI2_AnsiLowerCase, 1, [varString], varString);
    AddFun('SysUtils', 'AnsiCompareStr', RAI2_AnsiCompareStr, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiCompareText', RAI2_AnsiCompareText, 2, [varEmpty, varEmpty], varEmpty);
   {$IFDEF RA_D3H}
    AddFun('SysUtils', 'AnsiStrComp', RAI2_AnsiStrComp, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiStrIComp', RAI2_AnsiStrIComp, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiStrLComp', RAI2_AnsiStrLComp, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiStrLIComp', RAI2_AnsiStrLIComp, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiStrLower', RAI2_AnsiStrLower, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiStrUpper', RAI2_AnsiStrUpper, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiLastChar', RAI2_AnsiLastChar, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiStrLastChar', RAI2_AnsiStrLastChar, 1, [varEmpty], varEmpty);
   {$ENDIF RA_D3H}
    AddFun('SysUtils', 'Trim', RAI2_Trim, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'TrimLeft', RAI2_TrimLeft, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'TrimRight', RAI2_TrimRight, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'QuotedStr', RAI2_QuotedStr, 1, [varEmpty], varEmpty);
   {$IFDEF RA_D3H}
    AddFun('SysUtils', 'AnsiQuotedStr', RAI2_AnsiQuotedStr, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiExtractQuotedStr', RAI2_AnsiExtractQuotedStr, 2, [varByRef, varEmpty], varEmpty);
   {$ENDIF RA_D3H}
    AddFun('SysUtils', 'AdjustLineBreaks', RAI2_AdjustLineBreaks, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'IsValidIdent', RAI2_IsValidIdent, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'IntToStr', RAI2_IntToStr, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'IntToHex', RAI2_IntToHex, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrToInt', RAI2_StrToInt, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'StrToIntDef', RAI2_StrToIntDef, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'LoadStr', RAI2_LoadStr, 1, [varEmpty], varEmpty);
   // AddFun('SysUtils', 'FmtLoadStr', RAI2_FmtLoadStr, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'FileOpen', RAI2_FileOpen, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'FileCreate', RAI2_FileCreate, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'FileRead', RAI2_FileRead, 3, [varEmpty, varByRef, varEmpty], varEmpty);
    AddFun('SysUtils', 'FileWrite', RAI2_FileWrite, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'FileSeek', RAI2_FileSeek, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'FileClose', RAI2_FileClose, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'FileAge', RAI2_FileAge, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'FileExists', RAI2_FileExists, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'FindFirst', RAI2_FindFirst, 3, [varEmpty, varEmpty, varByRef], varEmpty);
    AddFun('SysUtils', 'FindNext', RAI2_FindNext, 1, [varByRef], varEmpty);
    AddFun('SysUtils', 'FindClose', RAI2_FindClose, 1, [varByRef], varEmpty);
    AddFun('SysUtils', 'FileGetDate', RAI2_FileGetDate, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'FileSetDate', RAI2_FileSetDate, 2, [varEmpty, varEmpty], varEmpty);
   {$IFDEF MSWINDOWS}
    AddFun('SysUtils', 'FileGetAttr', RAI2_FileGetAttr, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'FileSetAttr', RAI2_FileSetAttr, 2, [varEmpty, varEmpty], varEmpty);
   {$ENDIF MSWINDOWS}
    AddFun('SysUtils', 'DeleteFile', RAI2_DeleteFile, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'RenameFile', RAI2_RenameFile, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'ChangeFileExt', RAI2_ChangeFileExt, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'ExtractFilePath', RAI2_ExtractFilePath, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'ExtractFileDir', RAI2_ExtractFileDir, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'ExtractFileDrive', RAI2_ExtractFileDrive, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'ExtractFileName', RAI2_ExtractFileName, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'ExtractFileExt', RAI2_ExtractFileExt, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'ExpandFileName', RAI2_ExpandFileName, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'ExpandUNCFileName', RAI2_ExpandUNCFileName, 1, [varEmpty], varEmpty);
   {$IFDEF RA_D3H}
    AddFun('SysUtils', 'ExtractRelativePath', RAI2_ExtractRelativePath, 2, [varEmpty, varEmpty], varEmpty);
   {$ENDIF RA_D3H}
    AddFun('SysUtils', 'FileSearch', RAI2_FileSearch, 2, [varEmpty, varEmpty], varEmpty);
   {$IFDEF MSWINDOWS}
    AddFun('SysUtils', 'DiskFree', RAI2_DiskFree, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'DiskSize', RAI2_DiskSize, 1, [varEmpty], varEmpty);
   {$ENDIF MSWINDOWS}
    AddFun('SysUtils', 'FileDateToDateTime', RAI2_FileDateToDateTime, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'DateTimeToFileDate', RAI2_DateTimeToFileDate, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'GetCurrentDir', RAI2_GetCurrentDir, 0, [0], varEmpty);
    AddFun('SysUtils', 'SetCurrentDir', RAI2_SetCurrentDir, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'CreateDir', RAI2_CreateDir, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'RemoveDir', RAI2_RemoveDir, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'StrLen', RAI2_StrLen, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'StrEnd', RAI2_StrEnd, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'StrMove', RAI2_StrMove, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrCopy', RAI2_StrCopy, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrECopy', RAI2_StrECopy, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrLCopy', RAI2_StrLCopy, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrPCopy', RAI2_StrPCopy, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrPLCopy', RAI2_StrPLCopy, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrCat', RAI2_StrCat, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrLCat', RAI2_StrLCat, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrComp', RAI2_StrComp, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrIComp', RAI2_StrIComp, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrLComp', RAI2_StrLComp, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrLIComp', RAI2_StrLIComp, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrScan', RAI2_StrScan, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrRScan', RAI2_StrRScan, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrPos', RAI2_StrPos, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrUpper', RAI2_StrUpper, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'StrLower', RAI2_StrLower, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'StrPas', RAI2_StrPas, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'StrAlloc', RAI2_StrAlloc, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'StrBufSize', RAI2_StrBufSize, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'StrNew', RAI2_StrNew, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'StrDispose', RAI2_StrDispose, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'Format', RAI2_Format, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'FmtStr', RAI2_FmtStr, 3, [varByRef, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrFmt', RAI2_StrFmt, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrLFmt', RAI2_StrLFmt, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'FormatBuf', RAI2_FormatBuf, 5, [varByRef, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty); 
    AddFun('SysUtils', 'FloatToStr', RAI2_FloatToStr, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'CurrToStr', RAI2_CurrToStr, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'FloatToStrF', RAI2_FloatToStrF, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'CurrToStrF', RAI2_CurrToStrF, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
   // AddFun('SysUtils', 'FloatToText', RAI2_FloatToText, 6, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'FormatFloat', RAI2_FormatFloat, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'FormatCurr', RAI2_FormatCurr, 2, [varEmpty, varEmpty], varEmpty);
   // AddFun('SysUtils', 'FloatToTextFmt', RAI2_FloatToTextFmt, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrToFloat', RAI2_StrToFloat, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'StrToCurr', RAI2_StrToCurr, 1, [varEmpty], varEmpty);
   // AddFun('SysUtils', 'TextToFloat', RAI2_TextToFloat, 3, [varEmpty, varByRef, varEmpty], varEmpty);
   // AddFun('SysUtils', 'FloatToDecimal', RAI2_FloatToDecimal, 5, [varByRef, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
   { AddFun('SysUtils', 'DateTimeToTimeStamp', RAI2_DateTimeToTimeStamp, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'TimeStampToDateTime', RAI2_TimeStampToDateTime, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'MSecsToTimeStamp', RAI2_MSecsToTimeStamp, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'TimeStampToMSecs', RAI2_TimeStampToMSecs, 1, [varEmpty], varEmpty); }
    AddFun('SysUtils', 'EncodeDate', RAI2_EncodeDate, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'EncodeTime', RAI2_EncodeTime, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'DecodeDate', RAI2_DecodeDate, 4, [varEmpty, varByRef, varByRef, varByRef], varEmpty);
    AddFun('SysUtils', 'DecodeTime', RAI2_DecodeTime, 5, [varEmpty, varByRef, varByRef, varByRef, varByRef], varEmpty);
   { AddFun('SysUtils', 'DateTimeToSystemTime', RAI2_DateTimeToSystemTime, 2, [varEmpty, varByRef], varEmpty);
    AddFun('SysUtils', 'SystemTimeToDateTime', RAI2_SystemTimeToDateTime, 1, [varEmpty], varEmpty); }
    AddFun('SysUtils', 'DayOfWeek', RAI2_DayOfWeek, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'Date', RAI2_Date, 0, [0], varEmpty);
    AddFun('SysUtils', 'Time', RAI2_Time, 0, [0], varEmpty);
    AddFun('SysUtils', 'Now', RAI2_Now, 0, [0], varEmpty);
   {$IFDEF RA_D3H}
    AddFun('SysUtils', 'IncMonth', RAI2_IncMonth, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'IsLeapYear', RAI2_IsLeapYear, 1, [varEmpty], varEmpty);
   {$ENDIF RA_D3H}
    AddFun('SysUtils', 'DateToStr', RAI2_DateToStr, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'TimeToStr', RAI2_TimeToStr, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'DateTimeToStr', RAI2_DateTimeToStr, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'StrToDate', RAI2_StrToDate, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'StrToTime', RAI2_StrToTime, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'StrToDateTime', RAI2_StrToDateTime, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'FormatDateTime', RAI2_FormatDateTime, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'DateTimeToString', RAI2_DateTimeToString, 3, [varByRef, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'SysErrorMessage', RAI2_SysErrorMessage, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'GetLocaleStr', RAI2_GetLocaleStr, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'GetLocaleChar', RAI2_GetLocaleChar, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'GetFormatSettings', RAI2_GetFormatSettings, 0, [0], varEmpty);
    AddFun('SysUtils', 'ExceptObject', RAI2_ExceptObject, 0, [0], varEmpty);
    AddFun('SysUtils', 'ExceptAddr', RAI2_ExceptAddr, 0, [0], varEmpty);
   {$IFDEF RA_D3H}
    AddFun('SysUtils', 'ExceptionErrorMessage', RAI2_ExceptionErrorMessage, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
   {$ENDIF RA_D3H}
    AddFun('SysUtils', 'ShowException', RAI2_ShowException, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'Abort', RAI2_Abort, 0, [0], varEmpty);
    AddFun('SysUtils', 'OutOfMemoryError', RAI2_OutOfMemoryError, 0, [0], varEmpty);
    AddFun('SysUtils', 'Beep', RAI2_Beep, 0, [0], varEmpty);
   {$IFDEF RA_D3H}
    AddFun('SysUtils', 'ByteType', RAI2_ByteType, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'StrByteType', RAI2_StrByteType, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'ByteToCharLen', RAI2_ByteToCharLen, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'CharToByteLen', RAI2_CharToByteLen, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'ByteToCharIndex', RAI2_ByteToCharIndex, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'CharToByteIndex', RAI2_CharToByteIndex, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'IsPathDelimiter', RAI2_IsPathDelimiter, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'IsDelimiter', RAI2_IsDelimiter, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'LastDelimiter', RAI2_LastDelimiter, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiCompareFileName', RAI2_AnsiCompareFileName, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiLowerCaseFileName', RAI2_AnsiLowerCaseFileName, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiUpperCaseFileName', RAI2_AnsiUpperCaseFileName, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiPos', RAI2_AnsiPos, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiStrPos', RAI2_AnsiStrPos, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiStrRScan', RAI2_AnsiStrRScan, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'AnsiStrScan', RAI2_AnsiStrScan, 2, [varEmpty, varEmpty], varEmpty);
    AddFun('SysUtils', 'LoadPackage', RAI2_LoadPackage, 1, [varEmpty], varEmpty);
    AddFun('SysUtils', 'UnloadPackage', RAI2_UnloadPackage, 1, [varEmpty], varEmpty);
   {$IFDEF MSWINDOWS}
    AddFun('SysUtils', 'RaiseLastWin32Error', RAI2_RaiseLastWin32Error, 0, [0], varEmpty);
    AddFun('SysUtils', 'Win32Check', RAI2_Win32Check, 1, [varEmpty], varEmpty);
   {$ENDIF MSWINDOWS}
   {$ENDIF RA_D3H}
   { File open modes }
    AddConst('SysUtils', 'fmOpenRead', Integer(fmOpenRead));
    AddConst('SysUtils', 'fmOpenWrite', Integer(fmOpenWrite));
    AddConst('SysUtils', 'fmOpenReadWrite', Integer(fmOpenReadWrite));
   {$IFDEF MSWINDOWS}
    AddConst('SysUtils', 'fmShareCompat', Integer(fmShareCompat));
   {$ENDIF MSWINDOWS}
    AddConst('SysUtils', 'fmShareExclusive', Integer(fmShareExclusive));
    AddConst('SysUtils', 'fmShareDenyWrite', Integer(fmShareDenyWrite));
   {$IFDEF MSWINDOWS}
    AddConst('SysUtils', 'fmShareDenyRead', Integer(fmShareDenyRead));
   {$ENDIF MSWINDOWS}
    AddConst('SysUtils', 'fmShareDenyNone', Integer(fmShareDenyNone));
   { File attribute constants }
    AddConst('SysUtils', 'faReadOnly', Integer(faReadOnly));
    AddConst('SysUtils', 'faHidden', Integer(faHidden));
    AddConst('SysUtils', 'faSysFile', Integer(faSysFile));
    AddConst('SysUtils', 'faVolumeID', Integer(faVolumeID));
    AddConst('SysUtils', 'faDirectory', Integer(faDirectory));
    AddConst('SysUtils', 'faArchive', Integer(faArchive));
    AddConst('SysUtils', 'faAnyFile', Integer(faAnyFile));

    AddRec('SysUtils', 'TSearchRec', sizeof(TSearchRec), [
       RFD('Time', 0, varInteger),
       RFD('Size', 4, varInteger),
       RFD('Attr', 8, varInteger),
       RFD('Name', 12, varString),
       RFD('ExcludeAttr', 16, varInteger),
       RFD('FindHandle', 20, varInteger)
      ], RAI2_NewTSearchRec, RAI2_DisposeTSearchRec, nil
    );


    { regional options }
     { global variables are not supported by rai2 :( }

  end;    { with }
end;    { RegisterRAI2Adapter }

end.
