program ancement;

uses
  Windows,Forms,SysUtils,ShellApi,
  UMain in 'UMain.pas' {fmMain},
  tsvDbGrid in 'tsvDbGrid.pas',
  UTreeHeading in 'UTreeHeading.pas' {fmTreeHeading},
  tsvRTFStream in 'tsvRTFStream.pas';

{$R *.res}

procedure RegisterMidas;
var
  s: String;
begin
  s:=Format(fmtRegisterMidas,[GetWinSysDir+ConstFileRegSvr32,GetDataDir+ConstFileMidas]);
  ShellExecute(0,'open',PChar(s),nil,nil,SW_SHOW);
end;

begin
  RegisterMidas;
  Application.Initialize;
  Application.Title := '¬вод объ€влений';
  if CheckData then begin
    Application.CreateForm(TfmMain, fmMain);
    Application.CreateForm(TfmTreeHeading, fmTreeHeading);
    if not fmMain.InitData then begin
      ShowErrorEx(ConstInitDataFail);
      exit;
    end;  
  end else begin
    ShowErrorEx(ConstCheckDataFail);
    exit;
  end;  
  Application.Run;
end.
