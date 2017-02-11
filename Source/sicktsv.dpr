library sicktsv;

{$I stbasis.inc}     

uses
  SysUtils,
  Classes,
  Windows,
  USickTsvCode in 'SickTsv\USickTsvCode.pas',
  USickTsvData in 'SickTsv\USickTsvData.pas',
  USickTsvDM in 'SickTsv\USickTsvDM.pas' {dm: TDataModule},
  USickTsvOptions in 'SickTsv\USickTsvOptions.pas' {fmOptions},
  URBSick in 'SickTsv\URBSick.pas' {fmRBSick},
  UEditRBSick in 'SickTsv\UEditRBSick.pas' {fmEditRBSick},
  UMainUnited in 'United\UMainUnited.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  URBSickGroup in 'SickTsv\URBSickGroup.pas' {fmRBSickGroup},
  UEditRBSickGroup in 'SickTsv\UEditRBSickGroup.pas' {fmEditRBSickGroup},
  tsvTVNavigatorEx in 'United\tsvTVNavigatorEx.pas',
  VirtualDBTree in 'United\VirtualDBTree.pas',
  VirtualTrees in 'United\VirtualTrees.pas';

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

