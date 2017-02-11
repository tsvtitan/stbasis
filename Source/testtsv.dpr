library testtsv;

{$I stbasis.inc}     

uses
  SysUtils,
  Classes,
  Windows,
  UTestTsvCode in 'TestTsv\UTestTsvCode.pas',
  UTestTsvData in 'TestTsv\UTestTsvData.pas',
  UTestTsvDM in 'TestTsv\UTestTsvDM.pas' {dm: TDataModule},
  URBCurrency in 'TestTsv\URBCurrency.pas' {fmRBCurrency},
  UEditRBCurrency in 'TestTsv\UEditRBCurrency.pas' {fmEditRBCurrency},
  URBRateCurrency in 'TestTsv\URBRateCurrency.pas' {fmRBRateCurrency},
  UEditRBRateCurrency in 'TestTsv\UEditRBRateCurrency.pas' {fmEditRBRateCurrency},
  URptEmpUniversal in 'TestTsv\URptEmpUniversal.pas' {fmRptEmpUniversal},
  UMainUnited in 'United\UMainUnited.pas',
  tsvHint in 'United\tsvHint.pas',
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  tsvDbGrid in 'United\tsvDbGrid.pas',
  URptThread in 'United\URptThread.pas',
  URptMain in 'United\URptMain.pas' {fmRptMain};

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
    //  InitAll;
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

