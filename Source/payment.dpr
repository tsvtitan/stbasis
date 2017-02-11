library payment;

{$I stbasis.inc}     

{%File 'stbasis.inc'}

uses
  SysUtils,
  Classes,
  Windows,
  UMainUnited in 'United\UMainUnited.pas',
  tsvDbGrid in 'United\tsvDbGrid.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  RxRichEd in 'Ancement\RxRichEd.pas',
  MaxMin in 'Ancement\MAXMIN.PAS',
  tsvRTFStream in 'Ancement\tsvRTFStream.pas',
  RxMemDS in 'Ancement\RxMemDS.pas',
  StrUtils in 'United\StrUtils.pas',
  tsvInterbase in 'United\tsvInterbase.pas',
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  tsvTVNavigator in 'United\tsvTVNavigator.pas',
  tsvStdCtrls in 'United\tsvStdCtrls.pas',
  UPaymentCode in 'Payment\UPaymentCode.pas',
  UPaymentData in 'Payment\UPaymentData.pas',
  UPaymentDM in 'Payment\UPaymentDM.pas' {dm: TDataModule},
  URBPurpose in 'Payment\URBPurpose.pas' {fmRBPurpose},
  UEditRBPurpose in 'Payment\UEditRBPurpose.pas' {fmEditRBPurpose},
  URBCard in 'Payment\URBCard.pas' {fmRBCard},
  UEditRBCard in 'Payment\UEditRBCard.pas' {fmEditRBCard},
  URBPayment in 'Payment\URBPayment.pas' {fmRBPayment},
  UEditRBPayment in 'Payment\UEditRBPayment.pas' {fmEditRBPayment};

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

{$R *.RES}
  
begin
  Randomize;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.

