library interpreter;

{$I stbasis.inc}     

uses
  SysUtils,
  Classes,
  Windows,
  UMainUnited in 'United\UMainUnited.pas',
  tsvHint in 'United\tsvHint.pas',
  UIntrprTsvCode in 'IntrprTsv\UIntrprTsvCode.pas',
  UIntrprTsvData in 'IntrprTsv\UIntrprTsvData.pas',
  UIntrprTsvDM in 'IntrprTsv\UIntrprTsvDM.pas' {dm: TDataModule},
  RAI2 in 'IntrprTsv\RAI2.pas',
  RAI2Const in 'IntrprTsv\RAI2Const.pas',
  RAI2Parser in 'IntrprTsv\RAI2Parser.pas',
  UInterpreter in 'IntrprTsv\UInterpreter.pas',
  tsvDesignCore in 'United\tsvDesignCore.pas',
  UMainForm in 'United\UMainForm.pas' {fmMainForm},
  tsvDocument in 'IntrprTsv\tsvDocument.pas';

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

{$R *.RES}
  
begin
  Randomize;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.

