library docturntsv;

{$I stbasis.inc}     



uses
  SysUtils,
  Classes,
  Windows,
  UDocTurnTsvCode in 'DocTurnTsv\UDocTurnTsvCode.pas',
  UDocTurnTsvData in 'DocTurnTsv\UDocTurnTsvData.pas',
  UDocTurnTsvDM in 'DocTurnTsv\UDocTurnTsvDM.pas' {dm: TDataModule},
  UDocTurnTsvOptions in 'DocTurnTsv\UDocTurnTsvOptions.pas' {fmOptions},
  UMainUnited in 'United\UMainUnited.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  URBTypeDoc in 'DocTurnTsv\URBTypeDoc.pas' {fmRBTypeDoc},
  UEditRBTypeDoc in 'DocTurnTsv\UEditRBTypeDoc.pas' {fmEditRBTypeDoc},
  UJRMainGrid in 'United\UJRMainGrid.pas' {fmJRMainGrid},
  UJRDocum in 'DocTurnTsv\UJRDocum.pas' {fmJRDocum},
  UEditJRDocum in 'DocTurnTsv\UEditJRDocum.pas' {fmEditJRDocum},
  URBBasisTypeDoc in 'DocTurnTsv\URBBasisTypeDoc.pas' {fmRBBasisTypeDoc},
  UEditRBBasisTypeDoc in 'DocTurnTsv\UEditRBBasisTypeDoc.pas' {fmEditRBBasisTypeDoc},
  UDocWarrant in 'DocTurnTsv\UDocWarrant.pas' {fmDocWarrant},
  UDocMainGrid in 'United\UDocMainGrid.pas' {fmDocMainGrid},
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  URBMainTreeView in 'United\URBMainTreeView.pas' {fmRBMainTreeView},
  tsvInterbase in 'United\tsvInterbase.pas',
  RxMemDS in 'United\RxMemDS.pas',
  UEditDocWarrant in 'DocTurnTsv\UEditDocWarrant.pas' {fmEditDocWarrant};

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

