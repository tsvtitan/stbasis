library StoreVAV;

{$I stbasis.inc}     



uses
  SysUtils,
  Classes,
  Windows,
  UMainUnited in 'United\UMainUnited.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  UStoreVAVCode in 'StoreVAV\UStoreVAVCode.pas',
  UStoreVAVData in 'StoreVAV\UStoreVAVData.pas',
  UStoreVAVDM in 'StoreVAV\UStoreVAVDM.pas' {dm: TDataModule},
  UStoreVAVOptions in 'StoreVAV\UStoreVAVOptions.pas' {fmOptions},
  URBValueProperties in 'StoreVAV\URBValueProperties.pas' {fmRBValueProperties},
  URBStorePlace in 'StoreVAV\URBStorePlace.pas' {fmRBStorePlace},
  URBStoreType in 'StoreVAV\URBStoreType.pas' {fmRBStoreType},
  URBRespondents in 'StoreVAV\URBRespondents.pas' {fmRBRespondents},
  URBMainTreeView in 'United\URBMainTreeView.pas' {fmRBMainTreeView},
  URBProperties in 'StoreVAV\URBProperties.pas' {fmRBProperties},
  tsvInterbase in 'United\tsvInterbase.pas',
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  UEditRBValuesProperties in 'StoreVAV\UEditRBValuesProperties.pas' {fmEditRBValuesProperties},
  UEditRBProperties in 'StoreVAV\UEditRBProperties.pas' {fmEditRBProperties},
  UEditRBRespondents in 'StoreVAV\UEditRBRespondents.pas' {fmEditRBRespondents},
  UEditRBStoreType in 'StoreVAV\UEditRBStoreType.pas' {fmEditRBStoreType},
  StVAVKit in 'United\StVAVKit.pas',
  UEditRBReasons in 'StoreVAV\UEditRBReasons.pas' {fmEditRBReasons},
  URBReasons in 'StoreVAV\URBReasons.pas' {fmRBReasons},
  UEditRBStorePlace in 'StoreVAV\UEditRBStorePlace.pas' {fmEditRBStorePlace};

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

