library salarytsv;

{$I stbasis.inc}     



uses
  SysUtils,
  Classes,
  Windows,
  dbtree in 'United\DBTREE.PAS',
  tsvPicture in 'United\tsvPicture.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  URBMainTreeView in 'United\URBMainTreeView.pas' {fmRBMainTreeView},
  UMainUnited in 'United\UMainUnited.pas',
  UAdjust in 'United\UAdjust.pas' {fmAdjust},
  tsvDbGrid in 'United\tsvDbGrid.pas',
  tsvHint in 'United\tsvHint.pas',
  URptThread in 'United\URptThread.pas',
  Excel97 in 'United\excel97.pas',
  URptMain in 'United\URptMain.pas' {fmRptMain},
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  StCalendarUtil in 'United\StCalendarUtil.pas',
  USalaryTsvOptions in 'SalaryTsv\USalaryTsvOptions.pas' {fmOptions},
  USalaryTsvData in 'SalaryTsv\USalaryTsvData.pas',
  USalaryTsvDM in 'SalaryTsv\USalaryTsvDM.pas' {dm: TDataModule},
  USalaryTsvCode in 'SalaryTsv\USalaryTsvCode.pas',
  URBAlgorithm in 'SalaryTsv\URBAlgorithm.pas' {fmRBAlgorithm},
  UEditRBAlgorithm in 'SalaryTsv\UEditRBAlgorithm.pas' {fmEditRBAlgorithm},
  URBCharge in 'SalaryTsv\URBCharge.pas' {fmRBCharge},
  UEditRBCharge in 'SalaryTsv\UEditRBCharge.pas' {fmEditRBCharge},
  URBChargeTree in 'SalaryTsv\URBChargeTree.pas' {fmRBChargeTree},
  UEditRBChargeTree in 'SalaryTsv\UEditRBChargeTree.pas' {fmEditRBChargeTree},
  URptAccountSheets in 'SalaryTsv\URptAccountSheets.pas' {fmRptAccountSheets},
  DateUtil in '..\Imports\RX\Units\DATEUTIL.PAS',
  URBTypeBordereau in 'SalaryTsv\URBTypeBordereau.pas' {fmRBTypeBordereau},
  UEditRBTypeBordereau in 'SalaryTsv\UEditRBTypeBordereau.pas' {fmEditRBTypeBordereau},
  URptBordereau in 'SalaryTsv\URptBordereau.pas' {fmRptBordereau},
  tsvTVNavigatorEx in 'United\tsvTVNavigatorEx.pas',
  tsvComCtrls in 'United\tsvComCtrls.pas';

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
     // InitAll;
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

