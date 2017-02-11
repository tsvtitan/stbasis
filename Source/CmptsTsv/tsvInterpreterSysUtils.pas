unit tsvInterpreterSysUtils;

interface

uses UMainUnited, tsvInterpreterCore;

procedure Exception_Create(var Value: Variant; Args: TArguments);
procedure Exception_CreateRes(var Value: Variant; Args: TArguments);
procedure Exception_CreateHelp(var Value: Variant; Args: TArguments);
procedure Exception_CreateResHelp(var Value: Variant; Args: TArguments);
procedure Exception_Read_HelpContext(var Value: Variant; Args: TArguments);
procedure Exception_Write_HelpContext(const Value: Variant; Args: TArguments);
procedure Exception_Read_Message(var Value: Variant; Args: TArguments);
procedure Exception_Write_Message(const Value: Variant; Args: TArguments);

procedure SysUtils_AllocMem(var Value: Variant; Args: TArguments);
procedure SysUtils_NewStr(var Value: Variant; Args: TArguments);
procedure SysUtils_DisposeStr(var Value: Variant; Args: TArguments);
procedure SysUtils_AssignStr(var Value: Variant; Args: TArguments);
procedure SysUtils_AppendStr(var Value: Variant; Args: TArguments);
procedure SysUtils_UpperCase(var Value: Variant; Args: TArguments);
procedure SysUtils_LowerCase(var Value: Variant; Args: TArguments);
procedure SysUtils_CompareStr(var Value: Variant; Args: TArguments);
procedure SysUtils_CompareMem(var Value: Variant; Args: TArguments);
procedure SysUtils_CompareText(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiUpperCase(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiLowerCase(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiSameText(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiCompareStr(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiCompareText(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiStrComp(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiStrIComp(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiStrLComp(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiStrLIComp(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiStrLower(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiStrUpper(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiLastChar(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiStrLastChar(var Value: Variant; Args: TArguments);
procedure SysUtils_Trim(var Value: Variant; Args: TArguments);
procedure SysUtils_TrimLeft(var Value: Variant; Args: TArguments);
procedure SysUtils_TrimRight(var Value: Variant; Args: TArguments);
procedure SysUtils_QuotedStr(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiQuotedStr(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiExtractQuotedStr(var Value: Variant; Args: TArguments);
procedure SysUtils_AdjustLineBreaks(var Value: Variant; Args: TArguments);
procedure SysUtils_IsValidIdent(var Value: Variant; Args: TArguments);
procedure SysUtils_IntToStr(var Value: Variant; Args: TArguments);
procedure SysUtils_IntToHex(var Value: Variant; Args: TArguments);
procedure SysUtils_StrToInt(var Value: Variant; Args: TArguments);
procedure SysUtils_StrToIntDef(var Value: Variant; Args: TArguments);
procedure SysUtils_TryStrToInt(var Value: Variant; Args: TArguments);
procedure SysUtils_TryStrToDate(var Value: Variant; Args: TArguments);
procedure SysUtils_LoadStr(var Value: Variant; Args: TArguments);
procedure SysUtils_FileOpen(var Value: Variant; Args: TArguments);
procedure SysUtils_FileCreate(var Value: Variant; Args: TArguments);
procedure SysUtils_FileRead(var Value: Variant; Args: TArguments);
procedure SysUtils_FileWrite(var Value: Variant; Args: TArguments);
procedure SysUtils_FileSeek(var Value: Variant; Args: TArguments);
procedure SysUtils_FileClose(var Value: Variant; Args: TArguments);
procedure SysUtils_FileAge(var Value: Variant; Args: TArguments);
procedure SysUtils_FileExists(var Value: Variant; Args: TArguments);
procedure SysUtils_FileGetDate(var Value: Variant; Args: TArguments);
procedure SysUtils_FileSetDate(var Value: Variant; Args: TArguments);
procedure SysUtils_FileGetAttr(var Value: Variant; Args: TArguments);
procedure SysUtils_FileSetAttr(var Value: Variant; Args: TArguments);
procedure SysUtils_DeleteFile(var Value: Variant; Args: TArguments);
procedure SysUtils_RenameFile(var Value: Variant; Args: TArguments);
procedure SysUtils_ChangeFileExt(var Value: Variant; Args: TArguments);
procedure SysUtils_ExtractFilePath(var Value: Variant; Args: TArguments);
procedure SysUtils_ExtractFileDir(var Value: Variant; Args: TArguments);
procedure SysUtils_ExtractFileDrive(var Value: Variant; Args: TArguments);
procedure SysUtils_ExtractFileName(var Value: Variant; Args: TArguments);
procedure SysUtils_ExtractFileExt(var Value: Variant; Args: TArguments);
procedure SysUtils_ExpandFileName(var Value: Variant; Args: TArguments);
procedure SysUtils_ExpandUNCFileName(var Value: Variant; Args: TArguments);
procedure SysUtils_ExtractRelativePath(var Value: Variant; Args: TArguments);
procedure SysUtils_FileSearch(var Value: Variant; Args: TArguments);
procedure SysUtils_DiskFree(var Value: Variant; Args: TArguments);
procedure SysUtils_DiskSize(var Value: Variant; Args: TArguments);
procedure SysUtils_FileDateToDateTime(var Value: Variant; Args: TArguments);
procedure SysUtils_DateTimeToFileDate(var Value: Variant; Args: TArguments);
procedure SysUtils_GetCurrentDir(var Value: Variant; Args: TArguments);
procedure SysUtils_SetCurrentDir(var Value: Variant; Args: TArguments);
procedure SysUtils_CreateDir(var Value: Variant; Args: TArguments);
procedure SysUtils_RemoveDir(var Value: Variant; Args: TArguments);
procedure SysUtils_StrLen(var Value: Variant; Args: TArguments);
procedure SysUtils_StrEnd(var Value: Variant; Args: TArguments);
procedure SysUtils_StrMove(var Value: Variant; Args: TArguments);
procedure SysUtils_StrCopy(var Value: Variant; Args: TArguments);
procedure SysUtils_StrECopy(var Value: Variant; Args: TArguments);
procedure SysUtils_StrLCopy(var Value: Variant; Args: TArguments);
procedure SysUtils_StrPCopy(var Value: Variant; Args: TArguments);
procedure SysUtils_StrPLCopy(var Value: Variant; Args: TArguments);
procedure SysUtils_StrCat(var Value: Variant; Args: TArguments);
procedure SysUtils_StrLCat(var Value: Variant; Args: TArguments);
procedure SysUtils_StrComp(var Value: Variant; Args: TArguments);
procedure SysUtils_StrIComp(var Value: Variant; Args: TArguments);
procedure SysUtils_StrLComp(var Value: Variant; Args: TArguments);
procedure SysUtils_StrLIComp(var Value: Variant; Args: TArguments);
procedure SysUtils_StrScan(var Value: Variant; Args: TArguments);
procedure SysUtils_StrRScan(var Value: Variant; Args: TArguments);
procedure SysUtils_StrPos(var Value: Variant; Args: TArguments);
procedure SysUtils_StrUpper(var Value: Variant; Args: TArguments);
procedure SysUtils_StrLower(var Value: Variant; Args: TArguments);
procedure SysUtils_StrPas(var Value: Variant; Args: TArguments);
procedure SysUtils_StrAlloc(var Value: Variant; Args: TArguments);
procedure SysUtils_StrBufSize(var Value: Variant; Args: TArguments);
procedure SysUtils_StrNew(var Value: Variant; Args: TArguments);
procedure SysUtils_StrDispose(var Value: Variant; Args: TArguments);
procedure SysUtils_FloatToStr(var Value: Variant; Args: TArguments);
procedure SysUtils_CurrToStr(var Value: Variant; Args: TArguments);
procedure SysUtils_FloatToStrF(var Value: Variant; Args: TArguments);
procedure SysUtils_CurrToStrF(var Value: Variant; Args: TArguments);
procedure SysUtils_FormatFloat(var Value: Variant; Args: TArguments);
procedure SysUtils_FormatCurr(var Value: Variant; Args: TArguments);
procedure SysUtils_StrToFloat(var Value: Variant; Args: TArguments);
procedure SysUtils_StrToCurr(var Value: Variant; Args: TArguments);
procedure SysUtils_EncodeDate(var Value: Variant; Args: TArguments);
procedure SysUtils_EncodeTime(var Value: Variant; Args: TArguments);
procedure SysUtils_DecodeDate(var Value: Variant; Args: TArguments);
procedure SysUtils_DecodeTime(var Value: Variant; Args: TArguments);
procedure SysUtils_DayOfWeek(var Value: Variant; Args: TArguments);
procedure SysUtils_Date(var Value: Variant; Args: TArguments);
procedure SysUtils_Time(var Value: Variant; Args: TArguments);
procedure SysUtils_Now(var Value: Variant; Args: TArguments);
procedure SysUtils_IncMonth(var Value: Variant; Args: TArguments);
procedure SysUtils_IsLeapYear(var Value: Variant; Args: TArguments);
procedure SysUtils_DateToStr(var Value: Variant; Args: TArguments);
procedure SysUtils_TimeToStr(var Value: Variant; Args: TArguments);
procedure SysUtils_DateTimeToStr(var Value: Variant; Args: TArguments);
procedure SysUtils_StrToDate(var Value: Variant; Args: TArguments);
procedure SysUtils_StrToTime(var Value: Variant; Args: TArguments);
procedure SysUtils_StrToDateTime(var Value: Variant; Args: TArguments);
procedure SysUtils_FormatDateTime(var Value: Variant; Args: TArguments);
procedure SysUtils_DateTimeToString(var Value: Variant; Args: TArguments);
procedure SysUtils_SysErrorMessage(var Value: Variant; Args: TArguments);
procedure SysUtils_GetLocaleStr(var Value: Variant; Args: TArguments);
procedure SysUtils_GetLocaleChar(var Value: Variant; Args: TArguments);
procedure SysUtils_GetFormatSettings(var Value: Variant; Args: TArguments);
procedure SysUtils_ExceptObject(var Value: Variant; Args: TArguments);
procedure SysUtils_ExceptAddr(var Value: Variant; Args: TArguments);
procedure SysUtils_ExceptionErrorMessage(var Value: Variant; Args: TArguments);
procedure SysUtils_ShowException(var Value: Variant; Args: TArguments);
procedure SysUtils_Abort(var Value: Variant; Args: TArguments);
procedure SysUtils_OutOfMemoryError(var Value: Variant; Args: TArguments);
procedure SysUtils_Beep(var Value: Variant; Args: TArguments);
procedure SysUtils_ByteType(var Value: Variant; Args: TArguments);
procedure SysUtils_StrByteType(var Value: Variant; Args: TArguments);
procedure SysUtils_ByteToCharLen(var Value: Variant; Args: TArguments);
procedure SysUtils_CharToByteLen(var Value: Variant; Args: TArguments);
procedure SysUtils_ByteToCharIndex(var Value: Variant; Args: TArguments);
procedure SysUtils_CharToByteIndex(var Value: Variant; Args: TArguments);
procedure SysUtils_IsPathDelimiter(var Value: Variant; Args: TArguments);
procedure SysUtils_IsDelimiter(var Value: Variant; Args: TArguments);
procedure SysUtils_LastDelimiter(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiCompareFileName(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiLowerCaseFileName(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiUpperCaseFileName(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiPos(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiStrPos(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiStrRScan(var Value: Variant; Args: TArguments);
procedure SysUtils_AnsiStrScan(var Value: Variant; Args: TArguments);
procedure SysUtils_LoadPackage(var Value: Variant; Args: TArguments);
procedure SysUtils_UnloadPackage(var Value: Variant; Args: TArguments);
procedure SysUtils_RaiseLastWin32Error(var Value: Variant; Args: TArguments);
procedure SysUtils_Win32Check(var Value: Variant; Args: TArguments);


implementation

uses SysUtils;

  { Exception }

{ constructor Create(Msg: string) }
procedure Exception_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(Exception.Create(Args.Values[0]));
end;

{ constructor CreateRes(Ident: Integer) }
procedure Exception_CreateRes(var Value: Variant; Args: TArguments);
begin
  Value := O2V(Exception.CreateRes(Args.Values[0]));
end;

{ constructor CreateHelp(Msg: string; AHelpContext: Integer) }
procedure Exception_CreateHelp(var Value: Variant; Args: TArguments);
begin
  Value := O2V(Exception.CreateHelp(Args.Values[0], Args.Values[1]));
end;

{ constructor CreateResHelp(Ident: Integer; AHelpContext: Integer) }
procedure Exception_CreateResHelp(var Value: Variant; Args: TArguments);
begin
  Value := O2V(Exception.CreateResHelp(Args.Values[0], Args.Values[1]));
end;

{ property Read HelpContext: Integer }
procedure Exception_Read_HelpContext(var Value: Variant; Args: TArguments);
begin
  Value := Exception(Args.Obj).HelpContext;
end;

{ property Write HelpContext(Value: Integer) }
procedure Exception_Write_HelpContext(const Value: Variant; Args: TArguments);
begin
  Exception(Args.Obj).HelpContext := Value;
end;

{ property Read Message: string }
procedure Exception_Read_Message(var Value: Variant; Args: TArguments);
begin
  Value := Exception(Args.Obj).Message;
end;

{ property Write Message(Value: string) }
procedure Exception_Write_Message(const Value: Variant; Args: TArguments);
begin
  Exception(Args.Obj).Message := Value;
end;


{ function AllocMem(Size: Cardinal): Pointer; }
procedure SysUtils_AllocMem(var Value: Variant; Args: TArguments);
begin
  Value := P2V(AllocMem(Args.Values[0]));
end;

{ function NewStr(const S: string): PString; }
procedure SysUtils_NewStr(var Value: Variant; Args: TArguments);
begin
  Value := P2V(NewStr(Args.Values[0]));
end;

{ procedure DisposeStr(P: PString); }
procedure SysUtils_DisposeStr(var Value: Variant; Args: TArguments);
begin
  DisposeStr(V2P(Args.Values[0]));
end;

{ procedure AssignStr(var P: PString; const S: string); }
procedure SysUtils_AssignStr(var Value: Variant; Args: TArguments);
begin
  AssignStr(PString(TVarData(Args.Values[0]).vPointer), Args.Values[1]);
end;

{ procedure AppendStr(var Dest: string; const S: string); }
procedure SysUtils_AppendStr(var Value: Variant; Args: TArguments);
begin
  AppendStr(string(TVarData(Args.Values[0]).vString), Args.Values[1]);
end;

{ function UpperCase(const S: string): string; }
procedure SysUtils_UpperCase(var Value: Variant; Args: TArguments);
begin
  Value := UpperCase(Args.Values[0]);
end;

{ function LowerCase(const S: string): string; }
procedure SysUtils_LowerCase(var Value: Variant; Args: TArguments);
begin
  Value := LowerCase(Args.Values[0]);
end;

{ function CompareStr(const S1, S2: string): Integer; }
procedure SysUtils_CompareStr(var Value: Variant; Args: TArguments);
begin
  Value := CompareStr(Args.Values[0], Args.Values[1]);
end;

{ function CompareMem(P1, P2: Pointer; Length: Integer): Boolean; }
procedure SysUtils_CompareMem(var Value: Variant; Args: TArguments);
begin
  Value := CompareMem(V2P(Args.Values[0]), V2P(Args.Values[1]), Args.Values[2]);
end;

{ function CompareText(const S1, S2: string): Integer; }
procedure SysUtils_CompareText(var Value: Variant; Args: TArguments);
begin
  Value := CompareText(Args.Values[0], Args.Values[1]);
end;

{ function AnsiUpperCase(const S: string): string; }
procedure SysUtils_AnsiUpperCase(var Value: Variant; Args: TArguments);
begin
  Value := AnsiUpperCase(Args.Values[0]);
end;

{ function AnsiLowerCase(const S: string): string; }
procedure SysUtils_AnsiLowerCase(var Value: Variant; Args: TArguments);
begin
  Value := AnsiLowerCase(Args.Values[0]);
end;

{ function AnsiSameText(const S1, S2: string): Boolean; }
procedure SysUtils_AnsiSameText(var Value: Variant; Args: TArguments);
begin
  Value := AnsiSameText(Args.Values[0],Args.Values[1]);
end;

{ function AnsiCompareStr(const S1, S2: string): Integer; }
procedure SysUtils_AnsiCompareStr(var Value: Variant; Args: TArguments);
begin
  Value := AnsiCompareStr(Args.Values[0], Args.Values[1]);
end;

{ function AnsiCompareText(const S1, S2: string): Integer; }
procedure SysUtils_AnsiCompareText(var Value: Variant; Args: TArguments);
begin
  Value := AnsiCompareText(Args.Values[0], Args.Values[1]);
end;

{ function AnsiStrComp(S1, S2: PChar): Integer; }
procedure SysUtils_AnsiStrComp(var Value: Variant; Args: TArguments);
begin
  Value := AnsiStrComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])));
end;

{ function AnsiStrIComp(S1, S2: PChar): Integer; }
procedure SysUtils_AnsiStrIComp(var Value: Variant; Args: TArguments);
begin
  Value := AnsiStrIComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])));
end;

{ function AnsiStrLComp(S1, S2: PChar; MaxLen: Cardinal): Integer; }
procedure SysUtils_AnsiStrLComp(var Value: Variant; Args: TArguments);
begin
  Value := AnsiStrLComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]);
end;

{ function AnsiStrLIComp(S1, S2: PChar; MaxLen: Cardinal): Integer; }
procedure SysUtils_AnsiStrLIComp(var Value: Variant; Args: TArguments);
begin
  Value := AnsiStrLIComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]);
end;

{ function AnsiStrLower(Str: PChar): PChar; }
procedure SysUtils_AnsiStrLower(var Value: Variant; Args: TArguments);
begin
  Value := string(AnsiStrLower(PChar(string(Args.Values[0]))));
end;

{ function AnsiStrUpper(Str: PChar): PChar; }
procedure SysUtils_AnsiStrUpper(var Value: Variant; Args: TArguments);
begin
  Value := string(AnsiStrUpper(PChar(string(Args.Values[0]))));
end;

{ function AnsiLastChar(const S: string): PChar; }
procedure SysUtils_AnsiLastChar(var Value: Variant; Args: TArguments);
begin
  Value := string(AnsiLastChar(Args.Values[0]));
end;

{ function AnsiStrLastChar(P: PChar): PChar; }
procedure SysUtils_AnsiStrLastChar(var Value: Variant; Args: TArguments);
begin
  Value := string(AnsiStrLastChar(PChar(string(Args.Values[0]))));
end;

{ function Trim(const S: string): string; }
procedure SysUtils_Trim(var Value: Variant; Args: TArguments);
begin
  Value := Trim(Args.Values[0]);
end;

{ function TrimLeft(const S: string): string; }
procedure SysUtils_TrimLeft(var Value: Variant; Args: TArguments);
begin
  Value := TrimLeft(Args.Values[0]);
end;

{ function TrimRight(const S: string): string; }
procedure SysUtils_TrimRight(var Value: Variant; Args: TArguments);
begin
  Value := TrimRight(Args.Values[0]);
end;

{ function QuotedStr(const S: string): string; }
procedure SysUtils_QuotedStr(var Value: Variant; Args: TArguments);
begin
  Value := QuotedStr(Args.Values[0]);
end;

{ function AnsiQuotedStr(const S: string; Quote: Char): string; }
procedure SysUtils_AnsiQuotedStr(var Value: Variant; Args: TArguments);
begin
  Value := AnsiQuotedStr(Args.Values[0], string(Args.Values[1])[1]);
end;

{ function AnsiExtractQuotedStr(var Src: PChar; Quote: Char): string; }
procedure SysUtils_AnsiExtractQuotedStr(var Value: Variant; Args: TArguments);
begin
  Value := AnsiExtractQuotedStr(PChar(TVarData(Args.Values[0]).vPointer), string(Args.Values[1])[1]);
end;

{ function AdjustLineBreaks(const S: string): string; }
procedure SysUtils_AdjustLineBreaks(var Value: Variant; Args: TArguments);
begin
  Value := AdjustLineBreaks(Args.Values[0]);
end;

{ function IsValidIdent(const Ident: string): Boolean; }
procedure SysUtils_IsValidIdent(var Value: Variant; Args: TArguments);
begin
  Value := IsValidIdent(Args.Values[0]);
end;

{ function IntToStr(Value: Integer): string; }
procedure SysUtils_IntToStr(var Value: Variant; Args: TArguments);
begin
  Value := IntToStr(Args.Values[0]);
end;

{ function IntToHex(Value: Integer; Digits: Integer): string; }
procedure SysUtils_IntToHex(var Value: Variant; Args: TArguments);
begin
  Value := IntToHex(Args.Values[0], Args.Values[1]);
end;

{ function StrToInt(const S: string): Integer; }
procedure SysUtils_StrToInt(var Value: Variant; Args: TArguments);
begin
  Value := StrToInt(Args.Values[0]);
end;

{ function StrToIntDef(const S: string; Default: Integer): Integer; }
procedure SysUtils_StrToIntDef(var Value: Variant; Args: TArguments);
begin
  Value := StrToIntDef(Args.Values[0], Args.Values[1]);
end;

{ function TryStrToInt(const S: string; out Value: Integer): Boolean; }
{$HINTS OFF}
procedure SysUtils_TryStrToInt(var Value: Variant; Args: TArguments);
var
  S: String;
  E: Integer;
  V: Integer;
begin
  S:=Args.Values[0];
  Val(S,V,E);
  Args.Values[1]:=V;
  Value:=E=0;
end;
{$HINTS ON}

{ function TryStrToDate(const S: string; out Value: TDateTime): Boolean; }
procedure SysUtils_TryStrToDate(var Value: Variant; Args: TArguments);
var
  S: String;
  V: TDateTime;
begin
  try
    S:=Args.Values[0];
    V:=StrToDate(S);
    Args.Values[1]:=V;
    Value:=true;
  except
    Value:=false;
  end;
end;

{ function LoadStr(Ident: Integer): string; }
procedure SysUtils_LoadStr(var Value: Variant; Args: TArguments);
begin
  Value := LoadStr(Args.Values[0]);
end;

(*
{ function FmtLoadStr(Ident: Integer; const Args: array of const): string; }
procedure SysUtils_FmtLoadStr(var Value: Variant; Args: TArguments);
begin
  Value := FmtLoadStr(Args.Values[0], Args.Values[1]);
end;
*)

{ function FileOpen(const FileName: string; Mode: Integer): Integer; }
procedure SysUtils_FileOpen(var Value: Variant; Args: TArguments);
begin
  Value := FileOpen(Args.Values[0], Args.Values[1]);
end;

{ function FileCreate(const FileName: string): Integer; }
procedure SysUtils_FileCreate(var Value: Variant; Args: TArguments);
begin
  Value := FileCreate(Args.Values[0]);
end;

{ function FileRead(Handle: Integer; var Buffer; Count: Integer): Integer; }
procedure SysUtils_FileRead(var Value: Variant; Args: TArguments);
begin
  Value := FileRead(Args.Values[0], TVarData(Args.Values[1]).vInteger, Args.Values[2]);
end;

{ function FileWrite(Handle: Integer; const Buffer; Count: Integer): Integer; }
procedure SysUtils_FileWrite(var Value: Variant; Args: TArguments);
begin
  Value := FileWrite(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ function FileSeek(Handle, Offset, Origin: Integer): Integer; }
procedure SysUtils_FileSeek(var Value: Variant; Args: TArguments);
begin
  Value := FileSeek(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ procedure FileClose(Handle: Integer); }
procedure SysUtils_FileClose(var Value: Variant; Args: TArguments);
begin
  FileClose(Args.Values[0]);
end;

{ function FileAge(const FileName: string): Integer; }
procedure SysUtils_FileAge(var Value: Variant; Args: TArguments);
begin
  Value := FileAge(Args.Values[0]);
end;

{ function FileExists(const FileName: string): Boolean; }
procedure SysUtils_FileExists(var Value: Variant; Args: TArguments);
begin
  Value := FileExists(Args.Values[0]);
end;


{ function FileGetDate(Handle: Integer): Integer; }
procedure SysUtils_FileGetDate(var Value: Variant; Args: TArguments);
begin
  Value := FileGetDate(Args.Values[0]);
end;

{ function FileSetDate(Handle: Integer; Age: Integer): Integer; }
procedure SysUtils_FileSetDate(var Value: Variant; Args: TArguments);
begin
  Value := FileSetDate(Args.Values[0], Args.Values[1]);
end;

{ function FileGetAttr(const FileName: string): Integer; }
procedure SysUtils_FileGetAttr(var Value: Variant; Args: TArguments);
begin
  Value := FileGetAttr(Args.Values[0]);
end;

{ function FileSetAttr(const FileName: string; Attr: Integer): Integer; }
procedure SysUtils_FileSetAttr(var Value: Variant; Args: TArguments);
begin
  Value := FileSetAttr(Args.Values[0], Args.Values[1]);
end;

{ function DeleteFile(const FileName: string): Boolean; }
procedure SysUtils_DeleteFile(var Value: Variant; Args: TArguments);
begin
  Value := DeleteFile(Args.Values[0]);
end;

{ function RenameFile(const OldName, NewName: string): Boolean; }
procedure SysUtils_RenameFile(var Value: Variant; Args: TArguments);
begin
  Value := RenameFile(Args.Values[0], Args.Values[1]);
end;

{ function ChangeFileExt(const FileName, Extension: string): string; }
procedure SysUtils_ChangeFileExt(var Value: Variant; Args: TArguments);
begin
  Value := ChangeFileExt(Args.Values[0], Args.Values[1]);
end;

{ function ExtractFilePath(const FileName: string): string; }
procedure SysUtils_ExtractFilePath(var Value: Variant; Args: TArguments);
begin
  Value := ExtractFilePath(Args.Values[0]);
end;

{ function ExtractFileDir(const FileName: string): string; }
procedure SysUtils_ExtractFileDir(var Value: Variant; Args: TArguments);
begin
  Value := ExtractFileDir(Args.Values[0]);
end;

{ function ExtractFileDrive(const FileName: string): string; }
procedure SysUtils_ExtractFileDrive(var Value: Variant; Args: TArguments);
begin
  Value := ExtractFileDrive(Args.Values[0]);
end;

{ function ExtractFileName(const FileName: string): string; }
procedure SysUtils_ExtractFileName(var Value: Variant; Args: TArguments);
begin
  Value := ExtractFileName(Args.Values[0]);
end;

{ function ExtractFileExt(const FileName: string): string; }
procedure SysUtils_ExtractFileExt(var Value: Variant; Args: TArguments);
begin
  Value := ExtractFileExt(Args.Values[0]);
end;

{ function ExpandFileName(const FileName: string): string; }
procedure SysUtils_ExpandFileName(var Value: Variant; Args: TArguments);
begin
  Value := ExpandFileName(Args.Values[0]);
end;

{ function ExpandUNCFileName(const FileName: string): string; }
procedure SysUtils_ExpandUNCFileName(var Value: Variant; Args: TArguments);
begin
  Value := ExpandUNCFileName(Args.Values[0]);
end;

{ function ExtractRelativePath(const BaseName, DestName: string): string; }
procedure SysUtils_ExtractRelativePath(var Value: Variant; Args: TArguments);
begin
  Value := ExtractRelativePath(Args.Values[0], Args.Values[1]);
end;

{ function FileSearch(const Name, DirList: string): string; }
procedure SysUtils_FileSearch(var Value: Variant; Args: TArguments);
begin
  Value := FileSearch(Args.Values[0], Args.Values[1]);
end;

{ function DiskFree(Drive: Byte): Integer; }
procedure SysUtils_DiskFree(var Value: Variant; Args: TArguments);
begin
  Value := Integer(DiskFree(Args.Values[0]));
end;

{ function DiskSize(Drive: Byte): Integer; }
procedure SysUtils_DiskSize(var Value: Variant; Args: TArguments);
begin
  Value := Integer(DiskSize(Args.Values[0]));
end;

{ function FileDateToDateTime(FileDate: Integer): TDateTime; }
procedure SysUtils_FileDateToDateTime(var Value: Variant; Args: TArguments);
begin
  Value := FileDateToDateTime(Args.Values[0]);
end;

{ function DateTimeToFileDate(DateTime: TDateTime): Integer; }
procedure SysUtils_DateTimeToFileDate(var Value: Variant; Args: TArguments);
begin
  Value := DateTimeToFileDate(Args.Values[0]);
end;

{ function GetCurrentDir: string; }
procedure SysUtils_GetCurrentDir(var Value: Variant; Args: TArguments);
begin
  Value := GetCurrentDir;
end;

{ function SetCurrentDir(const Dir: string): Boolean; }
procedure SysUtils_SetCurrentDir(var Value: Variant; Args: TArguments);
begin
  Value := SetCurrentDir(Args.Values[0]);
end;

{ function CreateDir(const Dir: string): Boolean; }
procedure SysUtils_CreateDir(var Value: Variant; Args: TArguments);
begin
  Value := CreateDir(Args.Values[0]);
end;

{ function RemoveDir(const Dir: string): Boolean; }
procedure SysUtils_RemoveDir(var Value: Variant; Args: TArguments);
begin
  Value := RemoveDir(Args.Values[0]);
end;

{ function StrLen(Str: PChar): Cardinal; }
procedure SysUtils_StrLen(var Value: Variant; Args: TArguments);
begin
  Value := Integer(StrLen(PChar(string(Args.Values[0]))));
end;

{ function StrEnd(Str: PChar): PChar; }
procedure SysUtils_StrEnd(var Value: Variant; Args: TArguments);
begin
  Value := string(StrEnd(PChar(string(Args.Values[0]))));
end;

{ function StrMove(Dest, Source: PChar; Count: Cardinal): PChar; }
procedure SysUtils_StrMove(var Value: Variant; Args: TArguments);
begin
  Value := string(StrMove(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]));
end;

{ function StrCopy(Dest, Source: PChar): PChar; }
procedure SysUtils_StrCopy(var Value: Variant; Args: TArguments);
begin
  Value := string(StrCopy(PChar(string(Args.Values[0])), PChar(string(Args.Values[1]))));
end;

{ function StrECopy(Dest, Source: PChar): PChar; }
procedure SysUtils_StrECopy(var Value: Variant; Args: TArguments);
begin
  Value := string(StrECopy(PChar(string(Args.Values[0])), PChar(string(Args.Values[1]))));
end;

{ function StrLCopy(Dest, Source: PChar; MaxLen: Cardinal): PChar; }
procedure SysUtils_StrLCopy(var Value: Variant; Args: TArguments);
begin
  Value := string(StrLCopy(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]));
end;

{ function StrPCopy(Dest: PChar; const Source: string): PChar; }
procedure SysUtils_StrPCopy(var Value: Variant; Args: TArguments);
begin
  Value := string(StrPCopy(PChar(string(Args.Values[0])), Args.Values[1]));
end;

{ function StrPLCopy(Dest: PChar; const Source: string; MaxLen: Cardinal): PChar; }
procedure SysUtils_StrPLCopy(var Value: Variant; Args: TArguments);
begin
  Value := string(StrPLCopy(PChar(string(Args.Values[0])), Args.Values[1], Args.Values[2]));
end;

{ function StrCat(Dest, Source: PChar): PChar; }
procedure SysUtils_StrCat(var Value: Variant; Args: TArguments);
begin
  Value := string(StrCat(PChar(string(Args.Values[0])), PChar(string(Args.Values[1]))));
end;

{ function StrLCat(Dest, Source: PChar; MaxLen: Cardinal): PChar; }
procedure SysUtils_StrLCat(var Value: Variant; Args: TArguments);
begin
  Value := string(StrLCat(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]));
end;

{ function StrComp(Str1, Str2: PChar): Integer; }
procedure SysUtils_StrComp(var Value: Variant; Args: TArguments);
begin
  Value := StrComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])));
end;

{ function StrIComp(Str1, Str2: PChar): Integer; }
procedure SysUtils_StrIComp(var Value: Variant; Args: TArguments);
begin
  Value := StrIComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])));
end;

{ function StrLComp(Str1, Str2: PChar; MaxLen: Cardinal): Integer; }
procedure SysUtils_StrLComp(var Value: Variant; Args: TArguments);
begin
  Value := StrLComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]);
end;

{ function StrLIComp(Str1, Str2: PChar; MaxLen: Cardinal): Integer; }
procedure SysUtils_StrLIComp(var Value: Variant; Args: TArguments);
begin
  Value := StrLIComp(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]);
end;

{ function StrScan(Str: PChar; Chr: Char): PChar; }
procedure SysUtils_StrScan(var Value: Variant; Args: TArguments);
begin
  Value := string(StrScan(PChar(string(Args.Values[0])), string(Args.Values[1])[1]));
end;

{ function StrRScan(Str: PChar; Chr: Char): PChar; }
procedure SysUtils_StrRScan(var Value: Variant; Args: TArguments);
begin
  Value := string(StrRScan(PChar(string(Args.Values[0])), string(Args.Values[1])[1]));
end;

{ function StrPos(Str1, Str2: PChar): PChar; }
procedure SysUtils_StrPos(var Value: Variant; Args: TArguments);
begin
  Value := string(StrPos(PChar(string(Args.Values[0])), PChar(string(Args.Values[1]))));
end;

{ function StrUpper(Str: PChar): PChar; }
procedure SysUtils_StrUpper(var Value: Variant; Args: TArguments);
begin
  Value := string(StrUpper(PChar(string(Args.Values[0]))));
end;

{ function StrLower(Str: PChar): PChar; }
procedure SysUtils_StrLower(var Value: Variant; Args: TArguments);
begin
  Value := string(StrLower(PChar(string(Args.Values[0]))));
end;

{ function StrPas(Str: PChar): string; }
procedure SysUtils_StrPas(var Value: Variant; Args: TArguments);
begin
  Value := StrPas(PChar(string(Args.Values[0])));
end;

{ function StrAlloc(Size: Cardinal): PChar; }
procedure SysUtils_StrAlloc(var Value: Variant; Args: TArguments);
begin
  Value := string(StrAlloc(Args.Values[0]));
end;

{ function StrBufSize(Str: PChar): Cardinal; }
procedure SysUtils_StrBufSize(var Value: Variant; Args: TArguments);
begin
  Value := Integer(StrBufSize(PChar(string(Args.Values[0]))));
end;

{ function StrNew(Str: PChar): PChar; }
procedure SysUtils_StrNew(var Value: Variant; Args: TArguments);
begin
  Value := string(StrNew(PChar(string(Args.Values[0]))));
end;

{ procedure StrDispose(Str: PChar); }
procedure SysUtils_StrDispose(var Value: Variant; Args: TArguments);
begin
  StrDispose(PChar(string(Args.Values[0])));
end;

{ function FloatToStr(Value: Extended): string; }
procedure SysUtils_FloatToStr(var Value: Variant; Args: TArguments);
begin
  Value := FloatToStr(Args.Values[0]);
end;

{ function CurrToStr(Value: Currency): string; }
procedure SysUtils_CurrToStr(var Value: Variant; Args: TArguments);
begin
  Value := CurrToStr(Args.Values[0]);
end;

{ function FloatToStrF(Value: Extended; Format: TFloatFormat; Precision, Digits: Integer): string; }
procedure SysUtils_FloatToStrF(var Value: Variant; Args: TArguments);
begin
  Value := FloatToStrF(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3]);
end;

{ function CurrToStrF(Value: Currency; Format: TFloatFormat; Digits: Integer): string; }
procedure SysUtils_CurrToStrF(var Value: Variant; Args: TArguments);
begin
  Value := CurrToStrF(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

(*
{ function FloatToText(Buffer: PChar; const Value; ValueType: TFloatValue; Format: TFloatFormat; Precision, Digits: Integer): Integer; }
procedure SysUtils_FloatToText(var Value: Variant; Args: TArguments);
begin
  Value := FloatToText(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2], Args.Values[3], Args.Values[4], Args.Values[5]);
end;
*)

{ function FormatFloat(const Format: string; Value: Extended): string; }
procedure SysUtils_FormatFloat(var Value: Variant; Args: TArguments);
begin
  Value := FormatFloat(Args.Values[0], Args.Values[1]);
end;

{ function FormatCurr(const Format: string; Value: Currency): string; }
procedure SysUtils_FormatCurr(var Value: Variant; Args: TArguments);
begin
  Value := FormatCurr(Args.Values[0], Args.Values[1]);
end;

(*
{ function FloatToTextFmt(Buffer: PChar; const Value; ValueType: TFloatValue; Format: PChar): Integer; }
procedure SysUtils_FloatToTextFmt(var Value: Variant; Args: TArguments);
begin
  Value := FloatToTextFmt(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2], PChar(string(Args.Values[3])));
end;
*)

{ function StrToFloat(const S: string): Extended; }
procedure SysUtils_StrToFloat(var Value: Variant; Args: TArguments);
begin
  Value := StrToFloat(Args.Values[0]);
end;

{ function StrToCurr(const S: string): Currency; }
procedure SysUtils_StrToCurr(var Value: Variant; Args: TArguments);
begin
  Value := StrToCurr(Args.Values[0]);
end;

(*
{ function TextToFloat(Buffer: PChar; var Value; ValueType: TFloatValue): Boolean; }
procedure SysUtils_TextToFloat(var Value: Variant; Args: TArguments);
begin
  Value := TextToFloat(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]);
end;
*)
(* need record
{ procedure FloatToDecimal(var Result: TFloatRec; const Value; ValueType: TFloatValue; Precision, Decimals: Integer); }
procedure SysUtils_FloatToDecimal(var Value: Variant; Args: TArguments);
begin
  FloatToDecimal(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3], Args.Values[4]);
end;
*)

(* need record
{ function DateTimeToTimeStamp(DateTime: TDateTime): TTimeStamp; }
procedure SysUtils_DateTimeToTimeStamp(var Value: Variant; Args: TArguments);
begin
  Value := DateTimeToTimeStamp(Args.Values[0]);
end;

{ function TimeStampToDateTime(const TimeStamp: TTimeStamp): TDateTime; }
procedure SysUtils_TimeStampToDateTime(var Value: Variant; Args: TArguments);
begin
  Value := TimeStampToDateTime(Args.Values[0]);
end;

{ function MSecsToTimeStamp(MSecs: Comp): TTimeStamp; }
procedure SysUtils_MSecsToTimeStamp(var Value: Variant; Args: TArguments);
begin
  Value := MSecsToTimeStamp(Args.Values[0]);
end;

{ function TimeStampToMSecs(const TimeStamp: TTimeStamp): Comp; }
procedure SysUtils_TimeStampToMSecs(var Value: Variant; Args: TArguments);
begin
  Value := TimeStampToMSecs(Args.Values[0]);
end;
*)

{ function EncodeDate(Year, Month, Day: Word): TDateTime; }
procedure SysUtils_EncodeDate(var Value: Variant; Args: TArguments);
begin
  Value := EncodeDate(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime; }
procedure SysUtils_EncodeTime(var Value: Variant; Args: TArguments);
begin
  Value := EncodeTime(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3]);
end;

{ procedure DecodeDate(Date: TDateTime; var Year, Month, Day: Word); }
procedure SysUtils_DecodeDate(var Value: Variant; Args: TArguments);
begin
  DecodeDate(Args.Values[0], Word(TVarData(Args.Values[1]).vSmallint), Word(TVarData(Args.Values[2]).vSmallint), Word(TVarData(Args.Values[3]).vSmallint));
end;

{ procedure DecodeTime(Time: TDateTime; var Hour, Min, Sec, MSec: Word); }
procedure SysUtils_DecodeTime(var Value: Variant; Args: TArguments);
begin
  DecodeTime(Args.Values[0], Word(TVarData(Args.Values[1]).vSmallint), Word(TVarData(Args.Values[2]).vSmallint), Word(TVarData(Args.Values[3]).vSmallint), Word(TVarData(Args.Values[4]).vSmallint));
end;

(* need record
{ procedure DateTimeToSystemTime(DateTime: TDateTime; var SystemTime: TSystemTime); }
procedure SysUtils_DateTimeToSystemTime(var Value: Variant; Args: TArguments);
begin
  DateTimeToSystemTime(Args.Values[0], Args.Values[1]);
end;

{ function SystemTimeToDateTime(const SystemTime: TSystemTime): TDateTime; }
procedure SysUtils_SystemTimeToDateTime(var Value: Variant; Args: TArguments);
begin
  Value := SystemTimeToDateTime(Args.Values[0]);
end;
*)

{ function DayOfWeek(Date: TDateTime): Integer; }
procedure SysUtils_DayOfWeek(var Value: Variant; Args: TArguments);
begin
  Value := DayOfWeek(Args.Values[0]);
end;

{ function Date: TDateTime; }
procedure SysUtils_Date(var Value: Variant; Args: TArguments);
begin
  Value := Date;
end;

{ function Time: TDateTime; }
procedure SysUtils_Time(var Value: Variant; Args: TArguments);
begin
  Value := Time;
end;

{ function Now: TDateTime; }
procedure SysUtils_Now(var Value: Variant; Args: TArguments);
begin
  Value := Now;
end;

{ function IncMonth(const Date: TDateTime; NumberOfMonths: Integer): TDateTime; }
procedure SysUtils_IncMonth(var Value: Variant; Args: TArguments);
begin
  Value := IncMonth(Args.Values[0], Args.Values[1]);
end;

{ function IsLeapYear(Year: Word): Boolean; }
procedure SysUtils_IsLeapYear(var Value: Variant; Args: TArguments);
begin
  Value := IsLeapYear(Args.Values[0]);
end;

{ function DateToStr(Date: TDateTime): string; }
procedure SysUtils_DateToStr(var Value: Variant; Args: TArguments);
begin
  Value := DateToStr(Args.Values[0]);
end;

{ function TimeToStr(Time: TDateTime): string; }
procedure SysUtils_TimeToStr(var Value: Variant; Args: TArguments);
begin
  Value := TimeToStr(Args.Values[0]);
end;

{ function DateTimeToStr(DateTime: TDateTime): string; }
procedure SysUtils_DateTimeToStr(var Value: Variant; Args: TArguments);
begin
  Value := DateTimeToStr(Args.Values[0]);
end;

{ function StrToDate(const S: string): TDateTime; }
procedure SysUtils_StrToDate(var Value: Variant; Args: TArguments);
begin
  Value := StrToDate(Args.Values[0]);
end;

{ function StrToTime(const S: string): TDateTime; }
procedure SysUtils_StrToTime(var Value: Variant; Args: TArguments);
begin
  Value := StrToTime(Args.Values[0]);
end;

{ function StrToDateTime(const S: string): TDateTime; }
procedure SysUtils_StrToDateTime(var Value: Variant; Args: TArguments);
begin
  Value := StrToDateTime(Args.Values[0]);
end;

{ function FormatDateTime(const Format: string; DateTime: TDateTime): string; }
procedure SysUtils_FormatDateTime(var Value: Variant; Args: TArguments);
begin
  Value := FormatDateTime(Args.Values[0], Args.Values[1]);
end;

{ procedure DateTimeToString(var Result: string; const Format: string; DateTime: TDateTime); }
procedure SysUtils_DateTimeToString(var Value: Variant; Args: TArguments);
begin
  DateTimeToString(string(TVarData(Args.Values[0]).vString), Args.Values[1], Args.Values[2]);
end;

{ function SysErrorMessage(ErrorCode: Integer): string; }
procedure SysUtils_SysErrorMessage(var Value: Variant; Args: TArguments);
begin
  Value := SysErrorMessage(Args.Values[0]);
end;

{ function GetLocaleStr(Locale, LocaleType: Integer; const Default: string): string; }
procedure SysUtils_GetLocaleStr(var Value: Variant; Args: TArguments);
begin
  Value := GetLocaleStr(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ function GetLocaleChar(Locale, LocaleType: Integer; Default: Char): Char; }
procedure SysUtils_GetLocaleChar(var Value: Variant; Args: TArguments);
begin
  Value := GetLocaleChar(Args.Values[0], Args.Values[1], string(Args.Values[2])[1]);
end;

{ procedure GetFormatSettings; }
procedure SysUtils_GetFormatSettings(var Value: Variant; Args: TArguments);
begin
  GetFormatSettings;
end;

{ function ExceptObject: TObject; }
procedure SysUtils_ExceptObject(var Value: Variant; Args: TArguments);
begin
  Value := O2V(ExceptObject);
end;

{ function ExceptAddr: Pointer; }
procedure SysUtils_ExceptAddr(var Value: Variant; Args: TArguments);
begin
  Value := P2V(ExceptAddr);
end;

{ function ExceptionErrorMessage(ExceptObject: TObject; ExceptAddr: Pointer; Buffer: PChar; Size: Integer): Integer; }
procedure SysUtils_ExceptionErrorMessage(var Value: Variant; Args: TArguments);
begin
  Value := ExceptionErrorMessage(V2O(Args.Values[0]), V2P(Args.Values[1]), PChar(string(Args.Values[2])), Args.Values[3]);
end;

{ procedure ShowException(ExceptObject: TObject; ExceptAddr: Pointer); }
procedure SysUtils_ShowException(var Value: Variant; Args: TArguments);
begin
  ShowException(V2O(Args.Values[0]), V2P(Args.Values[1]));
end;

{ procedure Abort; }
procedure SysUtils_Abort(var Value: Variant; Args: TArguments);
begin
  Abort;
end;

{ procedure OutOfMemoryError; }
procedure SysUtils_OutOfMemoryError(var Value: Variant; Args: TArguments);
begin
  OutOfMemoryError;
end;

{ procedure Beep; }
procedure SysUtils_Beep(var Value: Variant; Args: TArguments);
begin
  Beep;
end;

{ function ByteType(const S: string; Index: Integer): TMbcsByteType; }
procedure SysUtils_ByteType(var Value: Variant; Args: TArguments);
begin
  Value := ByteType(Args.Values[0], Args.Values[1]);
end;

{ function StrByteType(Str: PChar; Index: Cardinal): TMbcsByteType; }
procedure SysUtils_StrByteType(var Value: Variant; Args: TArguments);
begin
  Value := StrByteType(PChar(string(Args.Values[0])), Args.Values[1]);
end;

{ function ByteToCharLen(const S: string; MaxLen: Integer): Integer; }
procedure SysUtils_ByteToCharLen(var Value: Variant; Args: TArguments);
begin
  Value := ByteToCharLen(Args.Values[0], Args.Values[1]);
end;

{ function CharToByteLen(const S: string; MaxLen: Integer): Integer; }
procedure SysUtils_CharToByteLen(var Value: Variant; Args: TArguments);
begin
  Value := CharToByteLen(Args.Values[0], Args.Values[1]);
end;

{ function ByteToCharIndex(const S: string; Index: Integer): Integer; }
procedure SysUtils_ByteToCharIndex(var Value: Variant; Args: TArguments);
begin
  Value := ByteToCharIndex(Args.Values[0], Args.Values[1]);
end;

{ function CharToByteIndex(const S: string; Index: Integer): Integer; }
procedure SysUtils_CharToByteIndex(var Value: Variant; Args: TArguments);
begin
  Value := CharToByteIndex(Args.Values[0], Args.Values[1]);
end;

{ function IsPathDelimiter(const S: string; Index: Integer): Boolean; }
procedure SysUtils_IsPathDelimiter(var Value: Variant; Args: TArguments);
begin
  Value := IsPathDelimiter(Args.Values[0], Args.Values[1]);
end;

{ function IsDelimiter(const Delimiters, S: string; Index: Integer): Boolean; }
procedure SysUtils_IsDelimiter(var Value: Variant; Args: TArguments);
begin
  Value := IsDelimiter(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ function LastDelimiter(const Delimiters, S: string): Integer; }
procedure SysUtils_LastDelimiter(var Value: Variant; Args: TArguments);
begin
  Value := LastDelimiter(Args.Values[0], Args.Values[1]);
end;

{ function AnsiCompareFileName(const S1, S2: string): Integer; }
procedure SysUtils_AnsiCompareFileName(var Value: Variant; Args: TArguments);
begin
  Value := AnsiCompareFileName(Args.Values[0], Args.Values[1]);
end;

{ function AnsiLowerCaseFileName(const S: string): string; }
procedure SysUtils_AnsiLowerCaseFileName(var Value: Variant; Args: TArguments);
begin
  Value := AnsiLowerCaseFileName(Args.Values[0]);
end;

{ function AnsiUpperCaseFileName(const S: string): string; }
procedure SysUtils_AnsiUpperCaseFileName(var Value: Variant; Args: TArguments);
begin
  Value := AnsiUpperCaseFileName(Args.Values[0]);
end;

{ function AnsiPos(const Substr, S: string): Integer; }
procedure SysUtils_AnsiPos(var Value: Variant; Args: TArguments);
begin
  Value := AnsiPos(Args.Values[0], Args.Values[1]);
end;

{ function AnsiStrPos(Str, SubStr: PChar): PChar; }
procedure SysUtils_AnsiStrPos(var Value: Variant; Args: TArguments);
begin
  Value := string(AnsiStrPos(PChar(string(Args.Values[0])), PChar(string(Args.Values[1]))));
end;

{ function AnsiStrRScan(Str: PChar; Chr: Char): PChar; }
procedure SysUtils_AnsiStrRScan(var Value: Variant; Args: TArguments);
begin
  Value := string(AnsiStrRScan(PChar(string(Args.Values[0])), string(Args.Values[1])[1]));
end;

{ function AnsiStrScan(Str: PChar; Chr: Char): PChar; }
procedure SysUtils_AnsiStrScan(var Value: Variant; Args: TArguments);
begin
  Value := string(AnsiStrScan(PChar(string(Args.Values[0])), string(Args.Values[1])[1]));
end;

{ function LoadPackage(const Name: string): HMODULE; }
procedure SysUtils_LoadPackage(var Value: Variant; Args: TArguments);
begin
  Value := Integer(LoadPackage(Args.Values[0]));
end;

{ procedure UnloadPackage(Module: HMODULE); }
procedure SysUtils_UnloadPackage(var Value: Variant; Args: TArguments);
begin
  UnloadPackage(Args.Values[0]);
end;

{ procedure RaiseLastWin32Error; }
procedure SysUtils_RaiseLastWin32Error(var Value: Variant; Args: TArguments);
begin
  RaiseLastWin32Error;
end;

{ function Win32Check(RetVal: BOOL): BOOL; }
procedure SysUtils_Win32Check(var Value: Variant; Args: TArguments);
begin
  Value := Win32Check(Args.Values[0]);
end;


end.



