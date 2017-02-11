library StoreVAV;

{$I stbasis.inc}     



uses
  SysUtils,
  Classes,
  Windows,
  UMainUnited in 'United\UMainUnited.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  URBMainTreeView in 'United\URBMainTreeView.pas' {fmRBMainTreeView},
  tsvInterbase in 'United\tsvInterbase.pas',
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  StVAVKit in 'United\StVAVKit.pas',
  UEditRBLinkSummPercent in 'TaxesVAV\UEditRBLinkSummPercent.pas' {fmEditRBLinkSummPercent},
  UEditRBTreeTaxes in 'TaxesVAV\UEditRBTreeTaxes.pas' {fmEditRBTreeTaxes},
  URBLinkSummPercent in 'TaxesVAV\URBLinkSummPercent.pas' {fmRBLinkSummPercent},
  URBTreeTaxes in 'TaxesVAV\URBTreeTaxes.pas' {fmRBTreeTaxes},
  UTaxesVAVCode in 'TaxesVAV\UTaxesVAVCode.pas',
  UTaxesVAVData in 'TaxesVAV\UTaxesVAVData.pas',
  UTaxesVAVDM in 'TaxesVAV\UTaxesVAVDM.pas' {dm: TDataModule},
  UTaxesVAVOptions in 'TaxesVAV\UTaxesVAVOptions.pas' {fmOptions},
  URBTaxesType in 'TaxesVAV\URBTaxesType.pas' {fmRBTaxesType},
  UEditRBTaxesType in 'TaxesVAV\UEditRBTaxesType.pas' {fmEditRBTaxesType};

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

