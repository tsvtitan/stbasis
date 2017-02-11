library Calendar;

{$I stbasis.inc}

uses
  Windows,
  CalendarCode in 'Calendar\CalendarCode.pas',
  CalendarData in 'Calendar\CalendarData.pas' {dmCalendar: TDataModule},
  CalendarNew in 'Calendar\CalendarNew.pas' {frmCalendarNew},
  CalHolidayEdit in 'Calendar\CalHolidayEdit.pas' {frmCalHolidayEdit},
  CalCarryEdit in 'Calendar\CalCarryEdit.pas' {frmCalCarryEdit},
  CalendarEdit in 'Calendar\CalendarEdit.pas' {frmCalendar},
  UMainUnited in 'United\UMainUnited.pas',
  StCalendarUtil in 'United\StCalendarUtil.pas',
  CalendarView in 'Calendar\CalendarView.pas' {frmCalendarView},
  UAdjust in 'United\UAdjust.pas' {fmAdjust},
  ActualTime in 'ActualTime\ActualTime.pas' {frmActualTime},
  ATimeFilter in 'ActualTime\ATimeFilter.pas' {frmATimeFilter},
  ATimeDivergenceEdit in 'ActualTime\ATimeDivergenceEdit.pas' {frmDivergenceEdit},
  RoundType in 'Calendar\RoundType.pas' {frmRoundType},
  RoundTypeEdit in 'Calendar\RoundTypeEdit.pas' {frmRoundTypeEdit},
  ChargeGroup in 'Calendar\ChargeGroup.pas' {frmChargeGroup},
  ChargeGroupEdit in 'Calendar\ChargeGroupEdit.pas' {frmChargeGroupEdit},
  ATimeInfo in 'ActualTime\ATimeInfo.pas' {ftmATimeInfo},
  StCalendarGrid in 'United\StCalendarGrid.pas',
  StCalendarEdit in 'United\StCalendarEdit.pas';

{$R *.RES}

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
    end;
    DLL_PROCESS_DETACH: begin
      DeInitAll;
    end;
  end;
end;

exports
  GetInfoLibrary_ name ConstGetInfoLibrary,
  RefreshLibrary_ name ConstRefreshLibrary,
  SetConnection_ name ConstSetConnection,
  InitAll_ name ConstInitAll;

begin
  Randomize;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
