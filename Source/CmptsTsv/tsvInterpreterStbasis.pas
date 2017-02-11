unit tsvInterpreterStbasis;

interface

uses Classes, UMainUnited, tsvInterpreterCore, UCmptsTsvData, IbDataBase;

procedure stbasis_MainDataBase(var Value: Variant; Args: TArguments);

procedure stbasis_ShowErrorEx(var Value: Variant; Args: TArguments);
procedure stbasis_ShowWarningEx(var Value: Variant; Args: TArguments);
procedure stbasis_ShowInfoEx(var Value: Variant; Args: TArguments);
procedure stbasis_ShowQuestionEx(var Value: Variant; Args: TArguments);
procedure stbasis_DeleteWarningEx(var Value: Variant; Args: TArguments);

procedure stbasis_CreateLogItem(var Value: Variant; Args: TArguments);
procedure stbasis_SetSplashStatus(var Value: Variant; Args: TArguments);

procedure stbasis_CreateProgressBar(var Value: Variant; Args: TArguments);
procedure stbasis_FreeProgressBar(var Value: Variant; Args: TArguments);
procedure stbasis_SetProgressBarStatus(var Value: Variant; Args: TArguments);

procedure stbasis_Iff(var Value: Variant; Args: TArguments);
procedure stbasis_RepeatStr(var Value: Variant; Args: TArguments);
procedure stbasis_StrBetween(var Value: Variant; Args: TArguments);

procedure stbasis_isExistsParam(var Value: Variant; Args: TArguments);
procedure stbasis_WriteParam(var Value: Variant; Args: TArguments);
procedure stbasis_ReadParam(var Value: Variant; Args: TArguments);
procedure stbasis_ClearParams(var Value: Variant; Args: TArguments);
procedure stbasis_SaveParams(var Value: Variant; Args: TArguments);
procedure stbasis_EraseParams(var Value: Variant; Args: TArguments);

procedure stbasis_GetDateTimeFromServer(var Value: Variant; Args: TArguments);
procedure stbasis_ViewEnterPeriod(var Value: Variant; Args: TArguments);
procedure stbasis_GetGenId(var Value: Variant; Args: TArguments);
procedure stbasis_GetUserId(var Value: Variant; Args: TArguments);
procedure stbasis_GetUniqueId(var Value: Variant; Args: TArguments);
procedure stbasis_ChangeString(var Value: Variant; Args: TArguments);
procedure stbasis_FillWordsByString(var Value: Variant; Args: TArguments);
procedure stbasis_GetTempDir(var Value: Variant; Args: TArguments);
procedure stbasis_ExecSql(var Value: Variant; Args: TArguments);
procedure stbasis_CopyFile(var Value: Variant; Args: TArguments);

// TInterface
procedure TInterface_View(var Value: Variant; Args: TArguments);
procedure TInterface_Refresh(var Value: Variant; Args: TArguments);
procedure TInterface_Close(var Value: Variant; Args: TArguments);
procedure TInterface_ExecProc(var Value: Variant; Args: TArguments);


implementation

uses Windows, SysUtils, StbasisSUtils, tsvInterbase;

{ function MainDataBase: TIBDatabase; }
procedure stbasis_MainDataBase(var Value: Variant; Args: TArguments);
begin
  Value:=O2V(IBDB);
end;

{ function ShowErrorEx(Mess: String): Integer; }
procedure stbasis_ShowErrorEx(var Value: Variant; Args: TArguments);
begin
  Value := ShowErrorEx(Args.Values[0]);
end;

{function ShowWarningEx(Mess: String): Integer;}
procedure stbasis_ShowWarningEx(var Value: Variant; Args: TArguments);
begin
  Value := ShowWarningEx(Args.Values[0]);
end;

{ function ShowInfoEx(Mess: String): Integer; }
procedure stbasis_ShowInfoEx(var Value: Variant; Args: TArguments);
begin
  Value := ShowInfoEx(Args.Values[0]);
end;

{ function ShowQuestionEx(Mess: String): Integer;}
procedure stbasis_ShowQuestionEx(var Value: Variant; Args: TArguments);
begin
  Value := ShowQuestionEx(Args.Values[0]);
end;

{function DeleteWarningEx(Mess: String): Integer;}
procedure stbasis_DeleteWarningEx(var Value: Variant; Args: TArguments);
begin
  Value := DeleteWarningEx(Args.Values[0]);
end;


{ function _CreateLogItem(PCLI: PCreateLogItem): THandle;stdcall; }
procedure stbasis_CreateLogItem(var Value: Variant; Args: TArguments);
var
  s: string;
  TCLI: TCreateLogItem;
begin
  FillChar(TCLI,SizeOf(TCLI),0);
  s:=Args.Values[0];
  TCLI.Text:=PChar(s);
  TCLI.TypeLogItem:=TTypeLogItem(Args.Values[1]);
  _CreateLogItem(@TCLI);
end;

procedure stbasis_SetSplashStatus(var Value: Variant; Args: TArguments);
var
  S: String;
begin
  S:=Args.Values[0];
  _SetSplashStatus(PChar(S));
end;

{ function _CreateProgressBar(PCPB: PCreateProgressBar): THandle;stdcall; }
procedure stbasis_CreateProgressBar(var Value: Variant; Args: TArguments);
var
  TCPB: TCreateProgressBar;
  s: string;
begin
  FillChar(TCPB,SizeOf(TCPB),0);
  TCPB.Min:=Args.Values[0];
  TCPB.Max:=Args.Values[1];
  s:=Args.Values[2];
  TCPB.Hint:=PChar(s);
  TCPB.Color:=Args.Values[3];
  Value:=Integer(_CreateProgressBar(@TCPB));
end;

{ function _FreeProgressBar(ProgressBarHandle: THandle): Boolean;stdcall; }
procedure stbasis_FreeProgressBar(var Value: Variant; Args: TArguments);
begin
  Value:=_FreeProgressBar(Args.Values[0]);
end;

{ procedure _SetProgressBarStatus(ProgressBarHandle: THandle; PSPBS: PSetProgressBarStatus);stdcall; }
procedure stbasis_SetProgressBarStatus(var Value: Variant; Args: TArguments);
var
  TSPBS: TSetProgressBarStatus;
  s: string;
begin
  FillChar(TSPBS,SizeOf(TSPBS),0);
  TSPBS.Progress:=Args.Values[1];
  TSPBS.Max:=Args.Values[2];
  s:=Args.Values[3];
  TSPBS.Hint:=PChar(s);
  _SetProgressBarStatus(Args.Values[0],@TSPBS);
end;


{function Iff(isTrue: Boolean; TrueValue, FalseValue: Variant): Variant;}
procedure stbasis_Iff(var Value: Variant; Args: TArguments);
begin
  Value := Iff(Args.Values[0],Args.Values[1],Args.Values[2]);
end;

{ function RepeatStr(const S: string; const Count: Integer): string; }
procedure stbasis_RepeatStr(var Value: Variant; Args: TArguments);
var
  Test: Int64;
begin
  Test:=Integer(Args.Values[1]);
  Value:=RepeatStr(Args.Values[0],Test);
end;

{ function StrBetween(InStr: String; S1,S2: string): String; }
procedure stbasis_StrBetween(var Value: Variant; Args: TArguments);
begin
  Value:=StrBetween(Args.Values[0],Args.Values[1],Args.Values[2]);
end;

{procedure WriteParam(const Section,Param: String; Value: Variant); }
procedure stbasis_WriteParam(var Value: Variant; Args: TArguments);
begin
  WriteParam(Args.Values[0],Args.Values[1],Args.Values[2]);
end;

{function ReadParam(const Section,Param: String; Default: Variant): Variant; }
procedure stbasis_ReadParam(var Value: Variant; Args: TArguments);
begin
  Value:=ReadParam(Args.Values[0],Args.Values[1],Args.Values[2]);
end;

{ function _isExistsParam(Section,Param: PChar): Boolean; stdcall; }
procedure stbasis_isExistsParam(var Value: Variant; Args: TArguments);
var
  s1,s2: string;
begin
  s1:=Args.Values[0];
  s2:=Args.Values[1];
  Value:=_isExistsParam(PChar(s1),PChar(s2));
end;

{  procedure _ClearParams; stdcall; }
procedure stbasis_ClearParams(var Value: Variant; Args: TArguments);
begin
  _ClearParams;
end;

{ procedure _SaveParams; stdcall; }
procedure stbasis_SaveParams(var Value: Variant; Args: TArguments);
begin
  _SaveParams;
end;

{ function _EraseParams(Section: PChar): Boolean; stdcall; }
procedure stbasis_EraseParams(var Value: Variant; Args: TArguments);
var
  S: string;
begin
  S:=Args.Values[0];
  Value:=_EraseParams(PChar(S));
end;

{ function _GetDateTimeFromServer: TDateTime; stdcall; }
procedure stbasis_GetDateTimeFromServer(var Value: Variant; Args: TArguments);
begin
  Value:=_GetDateTimeFromServer;
end;
                           
{ function _ViewEnterPeriod(P: PInfoEnterPeriod): Boolean; stdcall; }
procedure stbasis_ViewEnterPeriod(var Value: Variant; Args: TArguments);
var
  T: TInfoEnterPeriod;
begin
  FillChar(T,SizeOf(T),0);
  T.DateBegin:=Args.Values[0];
  T.DateEnd:=Args.Values[1];
  T.TypePeriod:=TTypeEnterPeriod(Args.Values[2]);
  T.LoadAndSave:=Args.Values[3];
  Value:=_ViewEnterPeriod(@T);
  Args.Values[0]:=T.DateBegin;
  Args.Values[1]:=T.DateEnd;
end;

//function GetGenId(DB: TIBDataBase; TableName: string; Increment: Word): Longword;
procedure stbasis_GetGenId(var Value: Variant; Args: TArguments);
begin
  Value:=Integer(GetGenId(TIbDataBase(V2O(Args.Values[0])),Args.Values[1],Args.Values[2]));
end;

procedure stbasis_GetUserId(var Value: Variant; Args: TArguments);
var
  T: TInfoConnectUser;
begin
  FillChar(T,SizeOf(T),0);
  _GetInfoConnectUser(@T);
  Value:=T.User_id;
end;

procedure stbasis_GetUniqueId(var Value: Variant; Args: TArguments);
begin
  Value:=CreateUniqueId;
end;

procedure stbasis_ChangeString(var Value: Variant; Args: TArguments);
begin
  Value:=ChangeString(Args.Values[0],Args.Values[1],Args.Values[2]);
end;

procedure stbasis_FillWordsByString(var Value: Variant; Args: TArguments);
begin
  FillWordsByString(Args.Values[0],TStringList(V2O(Args.Values[1])));
end;

procedure stbasis_GetTempDir(var Value: Variant; Args: TArguments);
var
  M: TMainOption;
  S: String;
begin
  M:=_GetOptions;
  S:=ExpandFileName(M.DirTemp);
  Value:=S;
end;

procedure stbasis_ExecSql(var Value: Variant; Args: TArguments);
begin
  ExecSql(TIBDatabase(V2O(Args.Values[0])),Args.Values[1]);
end;

procedure stbasis_CopyFile(var Value: Variant; Args: TArguments);
var
  S1, S2: String;
begin
  S1:=Args.Values[0];
  S2:=Args.Values[1];
  Value:=CopyFile(PChar(S1),PChar(S2),false);
end;

// TInterface

{ function View: Boolean }
procedure TInterface_View(var Value: Variant; Args: TArguments);
begin
  Value := TInterface(Args.Obj).View;
end;

{ function Refresh: Boolean }
procedure TInterface_Refresh(var Value: Variant; Args: TArguments);
begin
  Value := TInterface(Args.Obj).Refresh;
end;

{ function Close: Boolean }
procedure TInterface_Close(var Value: Variant; Args: TArguments);
begin
  Value := TInterface(Args.Obj).Close;
end;

{ function ExecProc: Boolean; }
procedure TInterface_ExecProc(var Value: Variant; Args: TArguments);
begin
  Value := TInterface(Args.Obj).ExecProc;
end;


end.
