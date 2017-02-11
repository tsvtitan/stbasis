library stbasisudf;


uses
  Windows,
  StbasisUdfCode in 'StbasisUdfCode.pas',
  StbasisUdfData in 'StbasisUdfData.pas';

{$R *.RES}

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
      InitAll;
    end;
    DLL_PROCESS_DETACH: begin
      DeInitAll;
    end;
  end;
end;

exports
  ServerDate, Trim, LTrim, RTrim, SubStr, Now, AddStr, SubStrEx, ChangeStringEx,

  sys_CreateMainId,
  sys_DateTimeToDate,
  sys_DateTimeToTime,
  sys_DateTimeToYear,
  sys_DateTimeToMonth,
  sys_DateTimeToDay,
  sys_FormatDateTime,
  sys_AddStr,
  sys_CompareStr,
  sys_CompareStr2,
  sys_CompareStrByWord,
  sys_CompareStr4,
  sys_AnsiPos,
  sys_Like;

begin
  IsMultiThread := True;
  Randomize;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
