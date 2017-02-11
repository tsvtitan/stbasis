///////////////////////////////////////
//
//    Calendar
//    Volkov V.D.
//
//
///////////////////////////////////////
library rbksClrvvd;

uses
  Windows,
  CalendarCode in 'Calendar\CalendarCode.pas',
  CalendarConst in 'Calendar\CalendarConst.pas',
  CalendarData in 'Calendar\CalendarData.pas' {dmCalendar: TDataModule},
  CalendarNew in 'Calendar\CalendarNew.pas' {frmCalendarNew},
  CalWeekEdit in 'Calendar\CalWeekEdit.pas' {frmCalWeekEdit},
  CalHolidayEdit in 'Calendar\CalHolidayEdit.pas' {frmCalHolidayEdit},
  CalCarryEdit in 'Calendar\CalCarryEdit.pas' {frmCalCarryEdit},
  CalExceptEdit in 'Calendar\CalExceptEdit.pas' {frmCalExceptEdit},
  CalendarEdit in 'Calendar\CalendarEdit.pas' {frmCalendar},
  UMainUnited in 'United\UMainUnited.pas',
  tsvHint in 'United\tsvHint.pas';

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
  GetInfoLibrary_ name ConstGetInfoLibrary,
  GetListEntryRoot_ name ConstGetListEntryRoot,
  ViewEntry_ name ConstViewEntry,
  RefreshEntryes_ name ConstRefreshEntryes,
  SetAppAndScreen_ name ConstSetAppAndScreen,
  SetConnection_ name ConstSetConnection;

begin
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
